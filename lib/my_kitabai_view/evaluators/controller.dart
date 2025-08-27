import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../../../common/api_urls.dart';
import '../../../common/shred_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_imports.dart';
import '../../model/ReviewPendingList.dart';
import '../../model/getAllUploadedAnswers.dart';
import '../../common/api_services.dart';
import '../../common/loading_dialog.dart';

class ListOfSubmissionsController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  RxBool isLoading = false.obs;
  String formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "Unknown";
    try {
      final dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return "Unknown";
    }
  }

  String formatDate(String? dateTimeStr) {
    if (dateTimeStr == null) return "Unknown";
    try {
      final dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat(
        'MMM dd, yyyy',
      ).format(dateTime); // Format as "Jun 12, 2025"
    } catch (e) {
      return "Unknown";
    }
  }

  var isAccepted = false.obs;
  RxList<Requests> answersList = RxList<Requests>();
  RxList<AnnotatedImage> allAnnotatedImagesList = RxList<AnnotatedImage>();
  RxList<Answers> testAnswersList = RxList<Answers>();
  RxList<TestAnswerImages> allImagesList = RxList<TestAnswerImages>();
  RxList<CompletedAnnotatedImages> completedAnnotatedImages =
      RxList<CompletedAnnotatedImages>();

  RxMap<String, List<String>> annotatedImagesMap = <String, List<String>>{}.obs;

  void accept() {
    isAccepted.value = true;
  }

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    await getAllReviewRequest();
  }

  Future<void> getAllReviewRequest() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    String url = ApiUrls.getAllReviewRequest;
    try {
      isLoading.value = true;
    
      await callWebApiGet(
        null,
        url,
        onResponse: (response) {
       
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);
            final data = ReviewPendingList.fromJson(jsonData);
            if (data.data?.requests != null) {
              answersList.value = data.data!.requests!;
              final annotatedImages =
                  data.data!.requests!
                      .expand(
                        (answer) => answer.reviewData?.annotatedImages ?? [],
                      )
                      .toList()
                      .cast<AnnotatedImage>();
              allAnnotatedImagesList.value = annotatedImages;
           
            } else {
            }
          } else if (response.statusCode == 401) {
            SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
          } else {
          }
        },
        onError: () {
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getAllSubmittedAnswers() async {
    if (isLoading.value) return;

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    try {
      isLoading.value = true;
  
      await callWebApiGet(
        null,
        ApiUrls.getTestSubmissions,
        onResponse: (response) {
          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body);
            annotatedImagesMap.clear();
            final answers = jsonData['data']?['answers'] ?? [];
            for (var answer in answers) {
              final answerId = answer['_id'] ?? '';
              final annotatedImages =
                  answer['feedback']?['expertReview']?['annotatedImages'] ?? [];
              final urls = <String>[];
              for (var img in annotatedImages) {
                final url = img['downloadUrl'];
                if (url != null && url.isNotEmpty) {
                  urls.add(url);
                }
              }
              if (answerId.isNotEmpty) {
                annotatedImagesMap[answerId] = urls;
              }
            }
            final data = GetAllAnswers.fromJson(jsonData);
            if (data.data?.answers != null) {
              testAnswersList.value = data.data!.answers!;
              final images =
                  data.data!.answers!
                      .expand((answer) => answer.images ?? [])
                      .toList()
                      .cast<TestAnswerImages>();
              allImagesList.value = images;
              if (completedAnnotatedImages.isNotEmpty) {
              
              }
            } else {
            }
          } else if (response.statusCode == 401) {
             SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
          } else {
          }
        },
        onError: () {
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e, stackTrace) {
    
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendReviewRequest(String answerId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final String url = '${ApiUrls.annotationImages}$answerId/accept';
    final uri = Uri.parse(url);

    print('Sending review request to URL: $url');

    final body = jsonEncode({
      "notes": "please review my answer once",
      "priority": "medium",
    });

    showSmallLoadingDialog();
    try {
      await callWebApi(
        null,
        url,
        json.decode(body),
        onResponse: (response) async {
          Get.back();
          print(url);
          print(body);
          print("Status Code: \\${response.statusCode}");
          print("Response Body: \\${response.body}");
          if (response.statusCode == 200) {
            await getAllReviewRequest();
            await getAllSubmittedAnswers();
            Get.snackbar(
              'Success',
              'Successfully accepted',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
            );
          } else {
            Get.snackbar(
              'Error',
              'Failed to accept review. Please try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: Duration(seconds: 3),
            );
          }
        },
        onError: () {
          Get.back();
          print('❌ Error in sendReviewRequest');
          Get.snackbar('Error', 'Something went wrong');
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e) {
      Get.back();
      print("Exception: $e");
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}

class ListOfSubmissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListOfSubmissionsController());
  }
}
