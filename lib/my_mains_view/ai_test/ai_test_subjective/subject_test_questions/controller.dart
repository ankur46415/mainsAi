import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';
import 'package:mains/common/shred_pref.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../models/subjective_question.dart';

class SubjectiveQuestionsController extends GetxController {
  var questions = <Data>[].obs;
  var isLoading = false.obs;
  String? authToken;
  late SharedPreferences prefs;
  late Timer _timer;
  var totalTime = 0.obs;
  var remainingTime = 0.obs;
  var hasExtendedTime = false.obs;
  var _dialogShown = false;
  String? testId;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value > 0) {
        remainingTime.value--;
      } else {
        if (!hasExtendedTime.value) {
          _checkAndShowExtensionDialog();
          timer.cancel();
        } else {
          timer.cancel();
          _clearTestStartTime();
          //Get.offAllNamed(AppRoutes.subTestAnswrUpload);
        }
      }
    });
  }

  // Save test start time when test begins
  Future<void> _saveTestStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      '${Constants.testStartTime}_$testId',
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Get remaining time based on elapsed time
  Future<int> _getRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('${Constants.testStartTime}_$testId');
    final extensionTime = prefs.getInt(
      '${Constants.testTimeExtension}_$testId',
    );

    if (startTime == null) {
      // Test not started yet, return full time
      return totalTime.value;
    }

    // Check if time was extended
    if (extensionTime != null) {
      // Calculate remaining extension time
      final extensionStartTime = prefs.getInt(
        '${Constants.testTimeExtension}_${testId}_start',
      );
      if (extensionStartTime != null) {
        final elapsed =
            DateTime.now().millisecondsSinceEpoch - extensionStartTime;
        final remainingMillis = (extensionTime * 1000) - elapsed;
        final remainingSeconds =
            remainingMillis > 0 ? (remainingMillis / 1000).round() : 0;

        // Debug logging
        print('Extension Debug:');
        print('Extension Time: $extensionTime seconds');
        print('Extension Start Time: $extensionStartTime');
        print('Current Time: ${DateTime.now().millisecondsSinceEpoch}');
        print('Elapsed: $elapsed ms');
        print('Remaining: $remainingSeconds seconds');

        return remainingSeconds;
      } else {
        // Extension just started, return full extension time
        return extensionTime;
      }
    }

    final elapsed = DateTime.now().millisecondsSinceEpoch - startTime;
    final remainingMillis = (totalTime.value * 1000) - elapsed;

    if (remainingMillis <= 0) {
      return 0; // Test time over
    } else {
      return (remainingMillis / 1000).round(); // Convert back to seconds
    }
  }

  // Clear test start time when test ends
  Future<void> _clearTestStartTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${Constants.testStartTime}_$testId');
    await prefs.remove('${Constants.testTimeExtension}_$testId');
    await prefs.remove('${Constants.testTimeExtension}_${testId}_start');
  }

  // Check and show extension dialog only if not already given
  Future<void> _checkAndShowExtensionDialog() async {
    // Check if dialog was already shown in this session
    if (_dialogShown) {
      print('Dialog already shown in this session, skipping');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final extensionTime = prefs.getInt(
      '${Constants.testTimeExtension}_$testId',
    );

    if (extensionTime == null) {
      // Extension not given yet, show dialog
      _dialogShown = true; // Mark dialog as shown
      _showTimeExtensionDialog();
    } else {
      // Extension already given, don't show dialog
      print('Extension already given, skipping dialog');
    }
  }

  // Show time extension dialog
  void _showTimeExtensionDialog() async {
    // Double check if extension was already given
    final prefs = await SharedPreferences.getInstance();
    final extensionTime = prefs.getInt(
      '${Constants.testTimeExtension}_$testId',
    );

    if (extensionTime != null) {
      // Extension already given, don't show dialog
      print('Extension already given, skipping dialog');
      return;
    }

    // Auto-extend time immediately without waiting for user
    await _extendTestTime();

    // Show popup to inform user (but time is already extended)
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Time Extended",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.green.shade700,
          ),
        ),
        content: Text(
          "Your test time has been automatically extended by 1 minute.",
          style: GoogleFonts.poppins(fontSize: 14, height: 1.4),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "OK",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.green.shade600,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Extend test time by 1 minute
  Future<void> _extendTestTime() async {
    final prefs = await SharedPreferences.getInstance();
    final extensionKey = '${Constants.testTimeExtension}_$testId';
    final extensionStartKey = '${Constants.testTimeExtension}_${testId}_start';

    // Save extension time (1 minute = 60 seconds)
    await prefs.setInt(extensionKey, 60);

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt(extensionStartKey, currentTime);

    print('Extension Saved:');
    print('Extension Key: $extensionKey');
    print('Extension Start Key: $extensionStartKey');
    print('Extension Time: 60 seconds');
    print('Extension Start Time: $currentTime');

    remainingTime.value = 60;
    hasExtendedTime.value = true;

    // Restart timer for extension
    _startTimer();

    Get.snackbar(
      "Time Extended",
      "You have been given 1 additional minute",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade800,
      duration: Duration(seconds: 2),
    );
  }

  // Public method to end test but preserve timer state
  Future<void> endTest() async {
    // Don't cancel timer or clear data - let it continue on next page
    // _timer.cancel();
    // await _clearTestStartTime();
    // await _clearTimeExtension();
    // remainingTime.value = 0;
  }

  // Method to actually clear timer when test is submitted
  Future<void> clearTimerOnSubmission() async {
    _timer.cancel();
    await _clearTestStartTime();
    await _clearTimeExtension();
    remainingTime.value = 0;
  }

  // Public method to check and show time extension dialog (for other pages)
  Future<void> checkAndShowTimeExtension() async {
    if (remainingTime.value <= 0 && !hasExtendedTime.value) {
      await _checkAndShowExtensionDialog();
    }
  }

  // Method to reset timer to full time
  Future<void> resetTimer() async {
    // Cancel current timer
    _timer.cancel();

    // Clear all timer data
    await _clearTestStartTime();
    await _clearTimeExtension();

    // Reset extension flags
    hasExtendedTime.value = false;
    _dialogShown = false;

    // Set timer to full time
    remainingTime.value = totalTime.value;

    // Save new start time
    await _saveTestStartTime();

    // Restart timer
    _startTimer();
  }

  // Clear time extension data
  Future<void> _clearTimeExtension() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('${Constants.testTimeExtension}_$testId');
    await prefs.remove('${Constants.testTimeExtension}_${testId}_start');
    hasExtendedTime.value = false;
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

    this.testId = testId; // Store testId for persistent timer
    _dialogShown = false; // Reset dialog flag for new test

    if (showLoader) isLoading.value = true;

    final String url = '${ApiUrls.subjectiveTestQns}$testId';

    await callWebApiGet(
      null,
      url,
      onResponse: (response) async {
        if (response.statusCode == 200) {
          try {
            final jsonResponse = json.decode(response.body);

            final data = SubjectiveOfQuestions.fromJson(jsonResponse);

            questions.value = data.data ?? [];

            final totalMinutes = int.tryParse(data.totalTime ?? '0') ?? 0;
            totalTime.value = totalMinutes * 60;

            // Check if test was already started
            final startTime = prefs.getInt(
              '${Constants.testStartTime}_$testId',
            );
            if (startTime == null) {
              // First time starting test, save start time
              await _saveTestStartTime();
              remainingTime.value = totalTime.value;
            } else {
              // Test was already started, calculate remaining time
              remainingTime.value = await _getRemainingTime();
            }

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
