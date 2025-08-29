import 'dart:async';
import 'package:get/get.dart';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';
import 'package:mains/common/shred_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../../model/subjective_question.dart';

class SubjectiveQuestionsController extends GetxController {
  var questions = <Data>[].obs;
  var isLoading = false.obs;
  String? authToken;
  late SharedPreferences prefs;
  late Timer _timer;
  var totalEstimatedTime = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (totalEstimatedTime.value > 0) {
        totalEstimatedTime.value--;
      } else {
        timer.cancel();
        //Get.offAllNamed(AppRoutes.subTestAnswrUpload);
      }
    });
  }

  Future<void> startSubjectiveTest(String testId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';

    if (authToken.isEmpty) {
      return;
    }

    final url = '${ApiUrls.subjectiveTestStart}$testId/start';

    try {
      await callWebApi(
        null,
        url,
        {},
        token: authToken,
        showLoader: false,
        onResponse: (response) {
          try {
            json.decode(response.body);
          } catch (e) {}
        },
        onError: () {},
      );
    } catch (e) {}
  }

  Future<void> fetchQuestions(String testId, {bool showLoader = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (testId.isEmpty) return;

    if (showLoader) isLoading.value = true;

    final String url = '${ApiUrls.subjectiveTestQns}$testId';

    await callWebApiGet(
      null,
      url,
      onResponse: (response) {
        if (response.statusCode == 200) {
          try {
            final jsonResponse = json.decode(response.body);

            final data = SubjectiveOfQuestions.fromJson(jsonResponse);

            questions.value = data.data ?? [];

            totalEstimatedTime.value = questions.fold<int>(
              0,
              (sum, question) => sum + (question.metadata?.estimatedTime ?? 0),
            );

            _startTimer();
            startSubjectiveTest(testId);
          } catch (e) {
            Get.snackbar(
              'Error',
              'Failed to parse questions data',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to load questions',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onError: () {
        Get.snackbar(
          'Error',
          'Something went wrong while fetching questions.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );

    if (showLoader) isLoading.value = false;
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
