import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';
import 'package:mains/my_kitabai_view/logIn_flow/logIn_page_screen/User_Login_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/shred_pref.dart';
import '../../model/getAllUploadedAnswers.dart';

class MainTestScreenController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  RxBool isLoading = false.obs;
  RxBool isWorkBook = false.obs;
  RxInt currentTabIndex = 0.obs;

  void setIsWorkBook(bool value) {
    isWorkBook.value = value;
  }

  final RxList<Annotation> annotations = <Annotation>[].obs;
  RxList<Answers> testAnswersList = RxList<Answers>();
  RxList<BookWorkbookInfo> workBookInfo = RxList<BookWorkbookInfo>();
  RxList<Workbook> workBookList = RxList<Workbook>();
  RxList<TestAnswerImages> allImagesList = RxList<TestAnswerImages>();
  RxMap<String, List<String>> annotatedImagesMap = <String, List<String>>{}.obs;

  String formatTime(String? dateTimeStr) {
    if (dateTimeStr == null) return "Unknown";
    try {
      final dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      print('Error formatting time: $e for date: $dateTimeStr');
      return "Unknown";
    }
  }

  String formatDate(String? dateTimeStr) {
    if (dateTimeStr == null) return "Unknown";
    try {
      final dateTime = DateTime.parse(dateTimeStr).toLocal();
      return DateFormat('MMM dd, yyyy').format(dateTime);
    } catch (e) {
      print('Error formatting date: $e for date: $dateTimeStr');
      return "Unknown";
    }
  }

  @override
  void onInit() async {
    super.onInit();
    print('🔄 MainTestScreenController: onInit called');
    try {
      prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString(Constants.authToken);
      print('🔄 MainTestScreenController: Auth token retrieved: ${authToken != null ? 'Yes' : 'No'}');
      getAllSubmittedAnswers();
      ever(allImagesList, (_) {
        print('🔄 MainTestScreenController: allImagesList updated');
      });
    } catch (e) {
      print('❌ MainTestScreenController: Error in onInit: $e');
    }
  }

  // Add a method to force refresh data
  Future<void> refreshData() async {
    print('🔄 MainTestScreenController: Refreshing data');
    try {
      await getAllSubmittedAnswers();
    } catch (e) {
      print('❌ MainTestScreenController: Error refreshing data: $e');
    }
  }

  Future<void> getAllSubmittedAnswers() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (isLoading.value) return;

    isLoading.value = true;
    print('Using token: $authToken');
    await callWebApiGet(
      null,
      ApiUrls.getTestSubmissions,
      token: authToken ?? '',
      onResponse: (response) {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          annotatedImagesMap.clear();
          final data = GetAllAnswers.fromJson(jsonData);
          final answers = jsonData['data']?['answers'] ?? [];
          workBookInfo.clear();
          workBookList.clear();

          for (final answer in data.data?.answers ?? []) {
            final info = answer.bookWorkbookInfo;
            if (info != null) {
              workBookInfo.add(info);
              if (info.workbook != null) {
                workBookList.add(info.workbook!);
              }
            }
          }

          for (var answer in answers) {
            final answerId = answer['_id'] ?? '';
            final expertReviewAnnotated =
                answer['feedback']?['expertReview']?['annotatedImages'] ?? [];
            final topLevelAnnotations = answer['annotations'] ?? [];
            final urls = <String>[];
            for (var img in expertReviewAnnotated) {
              final url = img['downloadUrl'];
              if (url != null && url.isNotEmpty) {
                urls.add(url);
              }
            }
            for (var annotation in topLevelAnnotations) {
              final url = annotation['downloadUrl'];
              if (url != null && url.isNotEmpty) {
                urls.add(url);
              }
            }
            if (answerId.isNotEmpty) {
              annotatedImagesMap[answerId] = urls;
            }
          }
          if (data.data?.answers != null) {
            testAnswersList.value = data.data!.answers!;

            final images =
                data.data!.answers!
                    .expand((answer) => answer.images ?? [])
                    .toList()
                    .cast<TestAnswerImages>();
            allImagesList.value = images;
          } else {}
          annotations.clear();
          for (var answer in answers) {
            final annotationList = answer['annotations'] ?? [];
            for (var annotationJson in annotationList) {
              annotations.add(Annotation.fromJson(annotationJson));
            }
          }
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
        } else {}
        isLoading.value = false;
      },
      onError: () {
        isLoading.value = false;
      },

      showLoader: false,
      hideLoader: false,
    );
  }

  @override
  void onClose() {
    isWorkBook.value = false;
    super.onClose();
  }
}

class MainTestScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainTestScreenController());
  }
}
