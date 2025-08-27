import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_painter/image_painter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../app_imports.dart';
import '../../../database/annoted_images.dart';
import '../../../database/model/anotation_model.dart';
import '../../../database/model/annotated_list_model.dart';
import '../../../model/GetAnswerAnalysis.dart';
import '../controller.dart';
import 'image_status.dart';
import '../../../common/api_services.dart';

class AnotationController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  RxBool isLoading = false.obs;

  TextEditingController scoreMark = TextEditingController();
  TextEditingController expertRemark = TextEditingController();
  TextEditingController reviewResultRemark = TextEditingController();

  final RxList<ImageWithStatus> imagesWithStatus = <ImageWithStatus>[].obs;
  final RxList<ImagePainterController> controllers =
      <ImagePainterController>[].obs;
  final RxInt currentIndex = (-1).obs;
  final RxBool isEditMode = false.obs;
  final RxBool isAccepted = false.obs;
  late ImagePainterController currentController;
  final Rx<ImagePainterController?> _currentControllerRx =
      Rx<ImagePainterController?>(null);
  String? currentAnswerId;
  String? currentRequestId;
  final RxBool needsSaving = false.obs;
  final RxList<String> reviewImages = <String>[].obs;

  Future<void> fetchReviewImages(String questionId) async {
    try {
      isLoading.value = true;
      if (authToken == null) {
        prefs = await SharedPreferences.getInstance();
        authToken = prefs.getString('authToken');
      }

      if (authToken == null) {
        print("❌ Auth token is null");
        throw Exception('Authentication token not found. Please login again.');
      }

      if (questionId.isEmpty) {
        print("❌ Question ID is empty");
        throw Exception('Question ID is required');
      }

      final url = '${ApiUrls.getTestSubmissions}/$questionId';
     
      final headers = {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      await callWebApiGet(
        null,
        url,
        onResponse: (response) {
          print("📡 Response Status Code: \\${response.statusCode}");
          print("📨 Raw Response Body: \\${response.body}");
          print(authToken);
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);
            final GetAnswerAnlaysis analysis = GetAnswerAnlaysis.fromJson(
              jsonData,
            );
            if (analysis.success == true &&
                analysis.data?.answer?.submission?.answerImages != null) {
              final images = analysis.data!.answer!.submission!.answerImages!;
              reviewImages.value =
                  images
                      .where(
                        (img) =>
                            img.imageUrl != null && img.imageUrl!.isNotEmpty,
                      )
                      .map((img) => img.imageUrl!)
                      .toList();
              print("📸 Found \\${reviewImages.length} images");
              if (reviewImages.isEmpty) {
                print("⚠️ No valid images found in the response");
                throw Exception('No images found for this question');
              }
              imagesWithStatus.value =
                  reviewImages
                      .map(
                        (url) => ImageWithStatus(
                          imagePath: url,
                          isNetworkImage: true,
                        ),
                      )
                      .toList();
              controllers.value = List.generate(
                reviewImages.length,
                (index) => ImagePainterController(),
              );
              print("✅ Successfully processed \\${reviewImages.length} images");
            } else {
              print("⚠️ No valid data or images found in response");
              throw Exception('No images found for this question');
            }
          } else if (response.statusCode == 401) {
            print("❌ Authentication failed");
             SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
            throw Exception('Authentication failed. Please login again.');
            
          } else if (response.statusCode == 404) {
            print("❌ Question not found: $questionId");
            throw Exception('Question not found');
          } else {
            print("❌ API Error: \\${response.statusCode}");
            throw Exception('Failed to fetch images. Please try again.');
          }
        },
        onError: () {
          print("🛑 Error: Could not fetch images");
          reviewImages.clear();
          imagesWithStatus.clear();
          controllers.clear();
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
      print("🛑 Error: $e");
      reviewImages.clear();
      imagesWithStatus.clear();
      controllers.clear();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  List<ImageWithStatus> get displayImages =>
      imagesWithStatus
          .where(
            (img) =>
                !img.isAnnotated ||
                (img.isAnnotated && img.annotatedPath != null),
          )
          .toList();

  bool get areAllImagesAnnotated =>
      imagesWithStatus.isNotEmpty &&
      imagesWithStatus.every((img) => img.isAnnotated);

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  Future<void> _initializeController() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
    print(
      "🔑 Auth token initialized: ${authToken != null ? 'Present' : 'Null'}",
    );
  }

  void _initializeWithImages(List<String> images) {
    imagesWithStatus.value =
        images
            .map(
              (path) => ImageWithStatus(
                imagePath: path,
                isNetworkImage: path.startsWith('http'),
              ),
            )
            .toList();

    controllers.value = List.generate(
      images.length,
      (index) => ImagePainterController(),
    );
    currentIndex.value = -1;
    _currentControllerRx.value = null;
    currentController = ImagePainterController();
  }

  Future<void> loadImages(String questionId) async {
    print('Loading images for questionId: $questionId');
    currentAnswerId = questionId;
    try {
      _initializeWithImages(reviewImages.value);

      print('Getting annotations for questionId: $questionId');
      final db = await AnnotationsDatabase.instance;
      final annotations = await db.getAnnotationsByQuestionId(questionId);
      print('Found ${annotations.length} saved annotations');

      if (annotations.isNotEmpty) {
        // Update status of images that have been annotated
        for (var annotation in annotations) {
          if (File(annotation.imagePath).existsSync()) {
            // Find the original image and mark it as annotated
            final originalImageIndex = imagesWithStatus.indexWhere(
              (img) =>
                  !img.isAnnotated && img.imagePath == annotation.imagePath,
            );

            if (originalImageIndex != -1) {
              imagesWithStatus[originalImageIndex] =
                  imagesWithStatus[originalImageIndex].copyWith(
                    isAnnotated: true,
                    annotatedPath: annotation.imagePath,
                  );
            }
          }
        }
      }
    } catch (e) {
      print('Error loading images: $e');
      rethrow;
    }
  }

  void resetCurrentController() {
    if (currentController != null) {
      try {
        currentController.clear();
      } catch (e) {
        print('Error clearing controller: $e');
      }
      currentController = ImagePainterController();
      _currentControllerRx.value = currentController;
    }
    isEditMode.value = false; // Ensure edit mode is turned off
  }

  void setCurrentIndex(int index) {
    if (isEditMode.value) {
      return;
    }
    currentIndex.value = index;
  }

  Future<void> saveCurrentImage() async {
    if (currentIndex.value < 0 ||
        currentIndex.value >= imagesWithStatus.length) {
      throw Exception('No image selected');
    }

    if (currentAnswerId == null) {
      throw Exception('No question ID set');
    }

    try {
      final currentImage = imagesWithStatus[currentIndex.value];
      final imagePath = currentImage.imagePath;
      final isAsset = imagePath.startsWith('assets/');
      final isNetwork = imagePath.startsWith('http');

      // Get the image bytes
      Uint8List imageBytes;
      if (isAsset) {
        final ByteData data = await rootBundle.load(imagePath);
        imageBytes = data.buffer.asUint8List();
      } else if (isNetwork) {
        print('Downloading image from: $imagePath');
        imageBytes = await fetchNetworkImageBytes(imagePath);
      } else {
        final file = File(imagePath);
        imageBytes = await file.readAsBytes();
      }

      final editedImageBytes = await currentController.exportImage();
      if (editedImageBytes == null) {
        throw Exception('Failed to export edited image');
      }

      // Decode the edited image
      final decodedImage = img.decodeImage(editedImageBytes);
      if (decodedImage == null) {
        throw Exception('Failed to decode edited image');
      }

      // Save the image directly without any rotation
      final fixedImageBytes = img.encodePng(decodedImage);

      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final savedPath = '${directory.path}/annotated_$timestamp.png';

      final file = File(savedPath);
      await file.writeAsBytes(fixedImageBytes);
      print('✅ Image saved successfully at: $savedPath');

      final db = await AnnotationsDatabase.instance;
      await db.insertAnnotation(
        Annotation(
          id: null,
          questionId: currentAnswerId!,
          imagePath: savedPath,
          imageData: fixedImageBytes.toList(),
          createdAt: DateTime.now(),
        ),
      );
      print('✅ Annotation saved to database for questionId: $currentAnswerId');
      imagesWithStatus[currentIndex.value] = currentImage.copyWith(
        isAnnotated: true,
        annotatedPath: savedPath,
      );

      currentIndex.value = -1;
      _currentControllerRx.value = null;
      currentController = ImagePainterController();

      if (areAllImagesAnnotated) {
        needsSaving.value = true;
      }
    } catch (e) {
      print('❌ Error saving image: $e');
      Get.snackbar(
        'Error',
        'Failed to save annotation: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }

  Future<void> saveAnnotatedList() async {
    if (currentAnswerId == null) return;

    try {
      final db = await AnnotationsDatabase.instance;

      final annotatedPaths =
          imagesWithStatus
              .where((img) => img.isAnnotated && img.annotatedPath != null)
              .map((img) => img.annotatedPath!)
              .toList();

      final annotatedList = AnnotatedList(
        questionId: currentAnswerId!,
        annotatedImagePaths: annotatedPaths,
        createdAt: DateTime.now(),
        isCompleted: true,
      );

      await db.insertAnnotatedList(annotatedList);

      needsSaving.value = false;

      Get.snackbar(
        'Success',
        'All annotated images have been saved to database successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error saving annotated list: $e');
      Get.snackbar(
        'Error',
        'Failed to save annotated list: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> saveAnnotatedListAndUploadImages() async {
    if (currentAnswerId == null) {
      print('❌ Cannot save: currentAnswerId is null');
      return;
    }

    print('📝 Starting save and upload process');
    print('📋 Current Answer ID: $currentAnswerId');
    print('📋 Current Request ID: $currentRequestId');

    try {
      final db = await AnnotationsDatabase.instance;

      final annotatedPaths =
          imagesWithStatus
              .where((img) => img.isAnnotated && img.annotatedPath != null)
              .map((img) => img.annotatedPath!)
              .toList();

      final annotatedList = AnnotatedList(
        questionId: currentAnswerId!,
        annotatedImagePaths: annotatedPaths,
        createdAt: DateTime.now(),
        isCompleted: true,
      );

      await db.insertAnnotatedList(annotatedList);
      needsSaving.value = false;

      print(
        '✅ Annotated list saved locally with ${annotatedPaths.length} images.',
      );

      List<String> uploadedKeys = [];

      for (int i = 0; i < annotatedPaths.length; i++) {
        final filePath = annotatedPaths[i];
        final fileName = 'annotated_image_$i.png';
        final file = File(filePath);

        final uploadReqBody = {
          "fileName": fileName,
          "contentType": "image/png",
          "clientId": "CLI147189HIGB",
          "answerId": currentAnswerId!,
        };

        // Direct API call to get S3 upload URL
        final response = await http.post(
          Uri.parse(ApiUrls.s3),
          headers: {"Content-Type": "application/json"},
          body: json.encode(uploadReqBody),
        );

        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          final uploadUrl = body['data']?['uploadUrl'];
          final s3Key = body['data']?['key'];
          print(
            'Direct upload: uploadUrl: '
            '[32m$uploadUrl[0m, s3Key: [32m$s3Key[0m',
          );
          if (uploadUrl != null && s3Key != null) {
            final uploadSuccess = await uploadImageToS3Presigned(
              file,
              uploadUrl,
              fileName,
            );
            print(
              'Direct upload: uploadSuccess: $uploadSuccess, s3Key: $s3Key',
            );
            if (uploadSuccess) {
              print('✅ Image $fileName uploaded to S3 successfully.');
              uploadedKeys.add(s3Key);
            } else {
              print('❌ Upload to S3 failed for $fileName');
            }
          } else {
            print(
              '❌ uploadUrl or s3Key is null. uploadUrl: $uploadUrl, s3Key: $s3Key',
            );
          }
        } else {
          print(
            '❌ Failed to get S3 upload URL. Status: ${response.statusCode}',
          );
        }
      }

      if (uploadedKeys.isNotEmpty) {
        print(
          '📤 All images uploaded. Submitting review with ${uploadedKeys.length} images',
        );
        await submitReviewToBackend(uploadedKeys);
      } else {
        print('❌ No images were uploaded successfully');
        throw Exception('Failed to upload any images');
      }
    } catch (e) {
      print('❌ Error in save and upload process: $e');
      Get.snackbar(
        'Error',
        'Failed to save and upload: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }

  Future<Uint8List> fetchNetworkImageBytes(String imagePath) async {
    final response = await http.get(Uri.parse(imagePath));
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: \\${response.statusCode}');
    }
    return response.bodyBytes;
  }

  Future<bool> uploadImageToS3Presigned(
    File file,
    String uploadUrl,
    String fileName,
  ) async {
    try {
      final imageBytes = await file.readAsBytes();
      final uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/png'},
        body: imageBytes,
      );
      if (uploadResponse.statusCode == 200) {
        print('✅ Image $fileName uploaded to S3 successfully.');
        return true;
      } else {
        print(
          '❌ PUT upload failed for $fileName. Status: \\${uploadResponse.statusCode}',
        );
        return false;
      }
    } catch (e) {
      print('❌ Error uploading image $fileName to S3: $e');
      return false;
    }
  }

  Future<void> submitReviewToBackend(List<String> s3Keys) async {
    try {
      if (currentRequestId == null || currentRequestId!.isEmpty) {
        print('❌ Error: currentRequestId is null or empty');
        throw Exception('Review request ID is missing. Cannot submit review.');
      }

      print('📝 Submitting review for request ID: $currentRequestId');
      final annotatedImages = s3Keys.map((key) => {"s3Key": key}).toList();

      // Validate expert score before submitting
      final int? expertScore = int.tryParse(scoreMark.text.trim());
      if (expertScore == null || expertScore < 0 || expertScore > 100) {
        Get.snackbar(
          'Invalid Score',
          'Expert score must be between 0 and 100.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }

      final body = {
        "review_result": expertRemark.text.trim(),
        "expert_score": expertScore.toString(),
        "expert_remarks": reviewResultRemark.text.trim(),
        "annotated_images": annotatedImages,
      };
      print(body);
      final apiUrl = '${ApiUrls.annotationImages}$currentRequestId/submit';

      print('🔗 Making API call to: $apiUrl');

      await callWebApi(
        null,
        apiUrl,
        body,
        onResponse: (response) async {
          print(
            '📨 Final review POST response: \\${response.statusCode} - \\${response.body}',
          );
          if (response.statusCode == 200) {
            await Get.find<ListOfSubmissionsController>()
                .getAllSubmittedAnswers();
            Get.back();
            print('✅ Review submitted successfully.');
            Get.snackbar(
              'Success',
              'Review submitted successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          } else {
            print(
              '❌ Failed to submit review. Status: \\${response.statusCode}',
            );
            throw Exception(
              'Failed to submit review. Server returned \\${response.statusCode}',
            );
          }
        },
        onError: () {
          print('❌ Error submitting review');
          Get.snackbar(
            'Error',
            'Failed to submit review',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
      print('❌ Error submitting review: $e');
      Get.snackbar(
        'Error',
        'Failed to submit review: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      rethrow;
    }
  }

  void toggleAcceptance() {
    isAccepted.value = !isAccepted.value;
  }

  @override
  void onClose() {
    for (var controller in controllers) {
      try {
        controller.dispose();
      } catch (e) {
        print('Error disposing controller: $e');
      }
    }
    controllers.clear();
    super.onClose();
  }
}

class AnotationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AnotationController());
  }
}
