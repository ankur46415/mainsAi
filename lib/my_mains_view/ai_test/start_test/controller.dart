import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_objective.dart';

class ObjectiveTestController extends GetxController {
  // Test data and state management
  late AiTestItem testData;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeTestData();
  }

  void _initializeTestData() {
    try {
      final arguments = Get.arguments;

      if (arguments == null) {
        _handleError('No test data provided');
        return;
      }

      if (arguments is AiTestItem) {
        testData = arguments;
      } else {
        _handleError('Invalid test data format');
        return;
      }

      if (testData.testId.isEmpty) {
        _handleError('Test ID is missing');
        return;
      }

      if (testData.name.isEmpty) {
        _handleError('Test name is missing');
        return;
      }
    } catch (e) {
      _handleError('Error initializing test data: $e');
    }
  }

  void _handleError(String message) {
    hasError.value = true;
    errorMessage.value = message;
  }

  void startTest() {
    if (testData.totalQuestions == 0) {
      return;
    }

    try {
      Get.toNamed(
        AppRoutes.mainTestForAiTest,
        arguments: {'testId': testData.testId, 'testData': testData},
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to start test: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
