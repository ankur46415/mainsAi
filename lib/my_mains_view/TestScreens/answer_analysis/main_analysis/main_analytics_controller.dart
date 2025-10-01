import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/common/api_urls.dart';
import 'package:mains/models/GetAnswerAnalysis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/shred_pref.dart';
import '../../../logIn_flow/logIn_page_screen/User_Login_option.dart';
import '../../../../common/api_services.dart';

class MainAnalyticsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;

  final String? questionId;
  final int? attemptNumber;
  late SharedPreferences prefs;
  String? authToken;

  Rx<GetAnswerAnlaysis?> answerAnalysis = Rx<GetAnswerAnlaysis?>(null);
  RxList<AnswerImages> answerImagesList = <AnswerImages>[].obs;

  RxBool isSeeMoreExpanded = false.obs;
  RxInt currentPage = 0.obs;
  Rx<Color> currentColor = Colors.blue.shade50.obs;
  RxString selectedFeedbackOption = ''.obs;
  RxString selectedReviewOption = ''.obs;
  RxBool isLoading = false.obs;
  final RxList<AnalysedAnnotations> annotatedImages =
      <AnalysedAnnotations>[].obs;

  static const List<String> topTabs = [
    'Expert Review  ',
    'Analysis',
    'Model Answer',
    "Video ",
  ];
  final List<Color> tabColors = [
    Colors.blue.shade50,
    Colors.red.shade50,
    Colors.purple.shade50,
  ];

  final questionText = '''
Discuss the significance of the Directive Principles of State Policy (DPSP) in the Indian Constitution. How do they complement the Fundamental Rights? The DPSP are guidelines to the state to frame laws and policies for establishing a just society. They help bridge social inequalities and ensure welfare. Together with Fundamental Rights, they create a balance between individual freedom and social responsibility, aiming at inclusive development. (Answer in 150 words)
''';

  RxList<String> sliderImages =
      <String>[
        'assets/images/q1.jpeg',
        'assets/images/q2.jpeg',
        'assets/images/q3.jpeg',
        'assets/images/q4.jpeg',
      ].obs;

  MainAnalyticsController({this.questionId, this.attemptNumber}) {
    _initController();
  }

  Future<void> _initController() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: topTabs.length, vsync: this);
    pageController = PageController();
    tabController.addListener(_handleTabChange);
    pageController.addListener(_handlePageChange);
  }

  Future<void> fetchEvaluations() async {
    isLoading.value = true;

    if (authToken == null) {
      await _initController();
    }

    if (authToken == null) {
      isLoading.value = false;
      return;
    }

    if (questionId == null || questionId!.isEmpty) {
      isLoading.value = false;
      return;
    }

    try {
      final url = "${ApiUrls.bookfullAnalysis}$questionId";

      await callWebApiGet(
        null,
        url,
        onResponse: (response) {
          if (response.statusCode == 200) {
            isLoading.value = false;
            try {
              final Map<String, dynamic> jsonData = json.decode(response.body);
              final GetAnswerAnlaysis analysis = GetAnswerAnlaysis.fromJson(
                jsonData,
              );
              if (analysis.success == true && analysis.data?.answer != null) {
                answerAnalysis.value = analysis;
                if (analysis.data?.answer?.submission?.answerImages != null) {
                  answerImagesList.value =
                      analysis.data!.answer!.submission!.answerImages!;
                }
                if (analysis.data?.answer?.annotatedImages != null) {
                  annotatedImages.clear();
                  annotatedImages.addAll(
                    analysis.data!.answer!.annotatedImages!,
                  );
                }
              } else {
                _clearAllData();
              }
            } catch (e, stackTrace) {
              _clearAllData();
            }
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            SharedPreferences.getInstance().then((prefs) async {
              await prefs.clear();
              Get.offAll(() => User_Login_option());
            });
          } else {
            _clearAllData();
          }
        },
        onError: () {
          _clearAllData();
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
    } catch (e, stackTrace) {
      _clearAllData();
    } finally {
      isLoading.value = false;
    }
  }

  void _clearAllData() {
    answerAnalysis.value = null;
    answerImagesList.clear();
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) {
      currentColor.value = tabColors[tabController.index];
    }
  }

  void _handlePageChange() {
    if (pageController.page != null) {
      currentPage.value = pageController.page!.round();
    }
  }

  void setFeedbackOption(String value) {
    selectedFeedbackOption.value = value;
  }

  void setReviewOption(String value) {
    selectedReviewOption.value = value;
  }

  String getImageUrl(int index) {
    if (index >= 0 && index < answerImagesList.length) {
      return answerImagesList[index].imageUrl ?? '';
    }
    return '';
  }

  bool canMoveToNext() {
    return currentPage.value < answerImagesList.length - 1;
  }

  bool canMoveToPrevious() {
    return currentPage.value > 0;
  }

  void moveToNextImage() {
    if (canMoveToNext()) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void moveToPreviousImage() {
    if (canMoveToPrevious()) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    tabController.dispose();
    pageController.removeListener(_handlePageChange);
    pageController.dispose();
    super.onClose();
  }
}

class MainAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainAnalyticsController());
  }
}
