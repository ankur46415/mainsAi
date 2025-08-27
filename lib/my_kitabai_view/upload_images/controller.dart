import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import '../TestScreens/controller.dart';

class UploadAnswersController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  final Rx<String?> questionId = Rx<String?>(null);
  final http.Client _client = http.Client();
  final RxList<File> capturedImages = <File>[].obs;
  final RxBool isUploading = false.obs;

  // Add upload status variables
  final RxBool isUploadingToServer = false.obs;
  final RxString uploadStatus = ''.obs;
  final RxInt uploadProgress = 0.obs;
  final RxInt totalImages = 0.obs;

  void setQuestionId(String? raw) {
    if (raw == null) {
      print('Warning: Setting null questionId');
      return;
    }

    print('Setting questionId: $raw');
    questionId.value = raw;
  }

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);

    ever(isUploadingToServer, (bool isUploading) {
      if (!isUploading) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (Get.isDialogOpen ??
              false && uploadStatus.value != 'Upload limit reached') {
            print('Closing dialog due to upload completion');
            Get.back();
          } else if (uploadStatus.value == 'Upload limit reached') {
            print('Not closing dialog - limit reached dialog is showing');
          }
        });
      }
    });

    super.onInit();
  }

  final ImagePicker _picker = ImagePicker();
  bool _showingLimitDialog = false;

  void showLimitReachedDialog() {
    print('showLimitReachedDialog called');
    _showingLimitDialog = true;

    if (Get.isDialogOpen ?? false) {
      print('Closing existing dialog before showing limit dialog');
      Get.back();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      print('Showing limit reached dialog');
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 16),
                Text(
                  'Limit Reached',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'You have used this QR 5 times.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      print('Limit dialog OK button pressed');
                      _showingLimitDialog = false;
                      Get.back();
                      Get.back();
                    },
                    child: Text(
                      'OK',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  Future<void> captureImage() async {
    try {
      if (capturedImages.length >= 5) {
        Get.snackbar('Limit Reached', 'Maximum 5 images allowed');
        return;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        final file = File(image.path);
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0) {
            if (fileSize > 10 * 1024 * 1024) {
              Get.snackbar(
                'Warning',
                'Image file is too large. Please try again.',
              );
              return;
            }

            capturedImages.add(file);
          } else {
            Get.snackbar('Error', 'Failed to capture image');
          }
        } else {
          Get.snackbar('Error', 'Failed to save image');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to capture image: ${e.toString()}');
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      if (capturedImages.length >= 5) {
        Get.snackbar('Limit Reached', 'Maximum 5 images allowed');
        return;
      }
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (image != null) {
        final file = File(image.path);
        if (await file.exists()) {
          final fileSize = await file.length();
          if (fileSize > 0) {
            if (fileSize > 10 * 1024 * 1024) {
              Get.snackbar(
                'Warning',
                'Image file is too large. Please try again.',
              );
              return;
            }
            capturedImages.add(file);
          } else {
            Get.snackbar('Error', 'Failed to select image');
          }
        } else {
          Get.snackbar('Error', 'Failed to save image');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to select image: ${e.toString()}');
    }
  }

  Future<File> _compressImage(File file) async {
    try {
      // Check if file exists
      if (!await file.exists()) {
        print('Error: File does not exist for compression: ${file.path}');
        return file;
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        print('Error: File is empty: ${file.path}');
        return file;
      }
      final bytes = await file.readAsBytes();
      if (bytes.isEmpty) {
        print('Error: File is empty: ${file.path}');
        return file;
      }

      // Decode image with error handling
      final image = img.decodeImage(bytes);
      if (image == null) {
        print('Error: Could not decode image: ${file.path}');
        return file;
      }

      // Resize image if it's too large to reduce memory usage
      var resized = image;
      if (image.width > 1200 || image.height > 1200) {
        resized = img.copyResize(
          image,
          width: image.width > image.height ? 1200 : null,
          height: image.height > image.width ? 1200 : null,
        );
      }

      final compressed = img.encodeJpg(resized, quality: 80);
      if (compressed.isEmpty) {
        print('Error: Compression resulted in empty data');
        return file;
      }

      final tempDir = await getTemporaryDirectory();
      final tempFile = File(
        '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await tempFile.writeAsBytes(compressed);
      print(
        'Compressed image saved to: ${tempFile.path}, size: ${compressed.length} bytes',
      );

      return tempFile;
    } catch (e) {
      print('Error compressing image: $e');
      return file;
    }
  }

  Future<void> uploadImagesToAPI() async {
    void showSnack(String title, String message, {bool isError = true}) {
      Get.rawSnackbar(
        title: title,
        message: message,
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
        reverseAnimationCurve: Curves.easeInBack,
        snackStyle: SnackStyle.FLOATING,
        overlayBlur: 0.0,
      );
    }

    try {
      if (capturedImages.isEmpty) {
        showSnack('Error', 'No images to upload');
        return;
      }

      isUploadingToServer.value = true;
      uploadStatus.value = 'Preparing upload...';
      uploadProgress.value = 0;

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null) {
        showSnack('Error', 'Authentication token missing');
        isUploadingToServer.value = false;
        return;
      }

      if (questionId.value == null || questionId.value!.isEmpty) {
        showSnack('Error', 'Invalid question ID');
        isUploadingToServer.value = false;
        return;
      }

      totalImages.value = capturedImages.length;
      uploadStatus.value = 'Starting upload...';

      final uri = Uri.parse(
        '${ApiUrls.userAnswersBase}${questionId.value}/answers',
      );
      final request =
          http.MultipartRequest('POST', uri)
            ..headers.addAll({
              'Authorization': 'Bearer $authToken',
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            })
            ..fields['reviewStatus'] = 'pending';

      List<File> tempFiles = [];

      for (var i = 0; i < capturedImages.length; i++) {
        try {
          uploadStatus.value =
              'Processing image ${i + 1} of ${capturedImages.length}';
          final file = capturedImages[i];

          if (!await file.exists()) {
            print('Warning: File does not exist: ${file.path}');
            continue;
          }

          final compressedFile = await _compressImage(file);
          if (compressedFile.path != file.path) {
            tempFiles.add(compressedFile);
          }

          if (await compressedFile.exists() &&
              await compressedFile.length() > 0) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'images',
                compressedFile.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          } else {
            print('Warning: Skipped invalid compressed file');
          }
        } catch (e) {
          print('Error processing image ${i + 1}: $e');
        }

        uploadProgress.value = ((i + 1) / capturedImages.length * 100).round();
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (request.files.isEmpty) {
        showSnack('Error', 'No valid images to upload');
        isUploadingToServer.value = false;
        _cleanupTempFiles(tempFiles);
        return;
      }

      uploadStatus.value = 'Uploading Your Answers...';

      final startTime = DateTime.now();
      final response = await request.send().timeout(
        const Duration(seconds: 60),
      );
      final body = await response.stream.bytesToString();
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      final statusCode = response.statusCode;
      uploadProgress.value = 100;

      print('\n📤 Upload response status code: $statusCode');
      print('📤 Upload response body: $body');
      print('⏱ Upload took: ${duration.inMilliseconds} ms');

      int? responseCodeFromBody;
      try {
        final jsonResponse = json.decode(body);
        print('📦 Parsed response JSON: $jsonResponse');
        responseCodeFromBody = jsonResponse['responseCode'];
      } catch (e) {
        print('❌ Error parsing JSON response: $e');
      }

      if (statusCode == 555 || responseCodeFromBody == 1573) {
        uploadStatus.value = 'Upload limit reached';
        showSnack('Error', 'Upload limit reached. Please try again later.');
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (Get.isDialogOpen ?? false) Get.back(closeOverlays: true);
        });
      } else if (responseCodeFromBody == 1576) {
        uploadStatus.value = 'Invalid image content';
        showSnack('Error', 'One or more uploaded images are invalid.');
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (Get.isDialogOpen ?? false) Get.back(closeOverlays: true);
        });
      } else {
        switch (statusCode) {
          case 1566:
            uploadStatus.value = 'Invalid input data (manual evaluation)';
            showSnack('Error', 'Invalid input data (manual evaluation)');
            break;
          case 1567:
            uploadStatus.value = 'Answer not found';
            showSnack('Error', 'Answer not found.');
            break;
          case 1568:
            uploadStatus.value = 'Answer evaluated successfully';
            showSnack(
              'Success',
              'Answer evaluated successfully.',
              isError: false,
            );
            break;
          case 1569:
            uploadStatus.value = 'Evaluation failed';
            showSnack('Error', 'Manual evaluation failed.');
            break;
          case 1570:
            uploadStatus.value = 'Internal server error';
            showSnack('Error', 'Internal server error.');
            break;
          case 1571:
            uploadStatus.value = 'Invalid submission data';
            showSnack('Error', 'Invalid submission data.');
            break;
          case 1572:
            uploadStatus.value = 'No answer provided';
            showSnack('Error', 'No answer provided (images/text missing).');
            break;
          case 1574:
            uploadStatus.value = 'Question not found';
            showSnack('Error', 'Question not found.');
            break;
          case 1575:
            uploadStatus.value = 'Set not found';
            showSnack('Error', 'Set not found.');
            break;
          case 1577:
            uploadStatus.value = 'Unreadable image content';
            showSnack('Error', 'Image text unreadable.');
            break;
          case 1578:
            uploadStatus.value = 'Text extraction failed';
            showSnack('Error', 'Text extraction failed.');
            break;
          case 1579:
          case 200:
          case 201:
            uploadStatus.value = 'Upload completed successfully';
            showSnack(
              'Success',
              'Your answers have been uploaded!',
              isError: false,
            );
            Get.find<MainTestScreenController>().getAllSubmittedAnswers();
            Future.delayed(const Duration(milliseconds: 2000), () {
              if (Get.isDialogOpen ?? false) Get.back(closeOverlays: true);
            });
            break;
          default:
            uploadStatus.value = 'Upload failed';
            String message = 'Upload failed. Please try again.';
            try {
              final jsonResponse = json.decode(body);
              if (jsonResponse is Map && jsonResponse.containsKey('message')) {
                message = jsonResponse['message'] ?? message;
              }
            } catch (_) {}
            showSnack('Error', message);
            if (Get.isDialogOpen ?? false) Get.back();
            break;
        }
      }

      capturedImages.clear();
      _cleanupTempFiles(tempFiles);
    } catch (e, stackTrace) {
      uploadStatus.value = 'Error: ${e.toString()}';
      showSnack('Error', 'Upload failed: ${e.toString()}');
      print('❌ Exception occurred during upload: $e');
      print('🪵 Stack trace: $stackTrace');
      if (Get.isDialogOpen ?? false) Get.back();
      capturedImages.clear();
    } finally {
      isUploadingToServer.value = false;
      print('✅ Upload process completed');
    }
  }

  void _cleanupTempFiles(List<File> tempFiles) {
    for (final file in tempFiles) {
      try {
        if (file.existsSync()) {
          file.deleteSync();
          print('Cleaned up temp file: ${file.path}');
        }
      } catch (e) {
        print('Error cleaning up temp file ${file.path}: $e');
      }
    }
  }

  void clearImages() {
    try {
      capturedImages.clear();
      print('Cleared captured images');
    } catch (e) {
      print('Error clearing images: $e');
    }
  }

  // Method to clear all temporary files in the temp directory
  Future<void> clearAllTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();

      for (final file in files) {
        if (file is File && file.path.contains('compressed_')) {
          try {
            if (file.existsSync()) {
              file.deleteSync();
              print('Cleaned up temp file: ${file.path}');
            }
          } catch (e) {
            print('Error deleting temp file ${file.path}: $e');
          }
        }
      }
    } catch (e) {
      print('Error clearing temp files: $e');
    }
  }

  @override
  void onClose() {
    try {
      // Close HTTP client
      _client.close();

      // Clear captured images
      capturedImages.clear();

      // Clear temporary files
      clearAllTempFiles();

      // Reset all reactive variables
      isUploadingToServer.value = false;
      uploadStatus.value = '';
      uploadProgress.value = 0;
      totalImages.value = 0;
      questionId.value = null;

      print('UploadAnswersController: Cleaned up resources');
    } catch (e) {
      print('Error during controller cleanup: $e');
    }
    super.onClose();
  }
}

class UploadAnswersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UploadAnswersController());
  }
}
