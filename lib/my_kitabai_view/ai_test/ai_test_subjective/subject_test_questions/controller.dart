import 'dart:async';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    print("🚀 Starting subjective test...");
    print("🆔 Test ID: $testId");

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';

    if (authToken.isEmpty) {
      print("❌ Error: Auth token is empty or null");
      return;
    }

    print("🔐 Auth Token: $authToken");

    final url =
        'https://aipbbackend-c5ed.onrender.com/api/subjectivetest/clients/CLI147189HIGB/tests/$testId/start';

    try {
      print('🌐 Sending GET request to: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
        } catch (e) {}
      } else {}
    } catch (e) {
      print('❗ Exception while starting test: $e');
    }
  }

  Future<void> fetchQuestions(String testId, {bool showLoader = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (testId.isEmpty) return;

    if (showLoader) isLoading.value = true;

    final String url = '${ApiUrls.subjectiveTestQns}$testId';

    print("🔍 Fetching questions from: $url");

    await callWebApiGet(
      null,
      url,
      onResponse: (response) {
        print("📡 Response Status: ${response.statusCode}");
        print("📄 Response Body: ${response.body}");

        if (response.statusCode == 200) {
          try {
            final jsonResponse = json.decode(response.body);
            print("✅ Parsed JSON: $jsonResponse");

            final data = SubjectiveOfQuestions.fromJson(jsonResponse);
            print("📊 Parsed data success: ${data.success}");
            print("📊 Parsed data message: ${data.message}");
            print("📊 Questions count: ${data.data?.length ?? 0}");

            questions.value = data.data ?? [];
            print("🎯 Questions assigned to controller: ${questions.length}");

            totalEstimatedTime.value = questions.fold<int>(
              0,
              (sum, question) => sum + (question.metadata?.estimatedTime ?? 0),
            );

            _startTimer();
            startSubjectiveTest(testId);
          } catch (e) {
            print("❌ Error parsing response: $e");
            Get.snackbar(
              'Error',
              'Failed to parse questions data',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          print("❌ HTTP Error: ${response.statusCode}");
          Get.snackbar(
            'Error',
            'Failed to load questions',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onError: () {
        print("❌ Network error occurred");
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
