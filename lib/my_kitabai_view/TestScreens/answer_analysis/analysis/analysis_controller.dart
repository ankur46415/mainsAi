import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';

import '../../../../common/loading_dialog.dart';
import '../main_analysis/main_analytics_controller.dart';

class AnalysisController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  String? answerId;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
  }

  void setAnswerId(String id) {
    answerId = id;
  }

  Future<bool> postReviewData({
    required String selectedOption,
    String? otherText,
  }) async {
    if (answerId == null) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (authToken == null) {
      return false;
    }

    final url = Uri.parse('${ApiUrls.reviewForAnswer}/$answerId');
    print('Review URL: $url');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    // Prepare the review notes based on the selected option
    String reviewNotes = selectedOption;
    if (selectedOption == 'Others' &&
        otherText != null &&
        otherText.isNotEmpty) {
      reviewNotes = otherText;
    }

    final body = jsonEncode({'notes': reviewNotes, 'priority': 'medium'});
    print('Request body: $body');
    showSmallLoadingDialog();
    try {
      await callWebApi(
        null,
        url.toString(),
        json.decode(body),
        onResponse: (response) async {
          print('Response status: \\${response.statusCode}');
          print('Response body: \\${response.body}');
          Get.back();
          if (response.statusCode == 200 || response.statusCode == 201) {
            await Future.delayed(Duration(milliseconds: 300));
            final bottomNavController = Get.find<BottomNavController>();
            bottomNavController.changeIndex(3);
            Get.offAll(() => MyHomePage());

            Get.snackbar(
              'Success',
              'Review submitted successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100,
            );

            return true;
          } else {
            final errorData = jsonDecode(response.body);
            final errorMessage =
                errorData['message'] ?? 'Failed to submit review';
            Get.snackbar(
              'Error',
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
            );
            return false;
          }
        },
        onError: () {
          Get.back();
          print('Error submitting review');
          Get.snackbar(
            'Error',
            'Failed to submit review. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
          );
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
      return true;
    } catch (e) {
      Get.back();
      print('Error submitting review: $e');
      Get.snackbar(
        'Error',
        'Failed to submit review. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
  }

  Future<bool> submitFeedBack({
    required String selectedOption,
    String? otherText,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (authToken == null) {
      Get.snackbar(
        'Error',
        'Authentication token not found. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    final mainController = Get.find<MainAnalyticsController>();
    final answerId = mainController.answerAnalysis.value?.data?.answer?.sId;

    if (answerId == null) {
      Get.snackbar(
        'Error',
        'Answer ID is missing',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }

    final url = Uri.parse(
      '${ApiUrls.apiUrl5}/mobile/userAnswers/answers/$answerId/feedback',
    );
    print('Feedback URL: $url');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    String feedbackMessage = selectedOption;
    if (selectedOption == 'Others' &&
        otherText != null &&
        otherText.isNotEmpty) {
      feedbackMessage = otherText;
    }

    final body = jsonEncode({'message': feedbackMessage});

    print('Request body: $body');
    showSmallLoadingDialog();
    try {
      await callWebApi(
        null,
        url.toString(),
        json.decode(body),
        onResponse: (response) async {
          print('Response status: \\${response.statusCode}');
          print('Response body: \\${response.body}');
          Get.back();
          if (response.statusCode == 200 || response.statusCode == 201) {
            return true;
          } else {
            final errorData = jsonDecode(response.body);
            final errorMessage =
                errorData['message'] ?? 'Failed to submit feedback';
            Get.snackbar(
              'Error',
              errorMessage,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
            );
            return false;
          }
        },
        onError: () {
          Get.back();
          print('Error submitting feedback');
          Get.snackbar(
            'Error',
            'Failed to submit feedback. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.shade100,
          );
        },
        token: authToken ?? '',
        showLoader: false,
        hideLoader: false,
      );
      return true;
    } catch (e) {
      Get.back();
      print('Error submitting feedback: $e');
      Get.snackbar(
        'Error',
        'Failed to submit feedback. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
      return false;
    }
  }
}

class AnalysisBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AnalysisController());
  }
}
