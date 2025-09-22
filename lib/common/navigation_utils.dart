import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_subjective.dart';

class NavigationUtils {
  static Future<T?> safeNavigate<T>({
    required String route,
    dynamic arguments,
    bool preventDuplicates = true,
  }) async {
    try {
      if (arguments == null) {
      }

      return await Get.toNamed<T>(
        route,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
      );
    } catch (e) {
      Get.snackbar(
        'Navigation Error',
        'Failed to navigate to $route',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }

  static T? getArguments<T>() {
    try {
      final arguments = Get.arguments;
      if (arguments == null) {
        return null;
      }

      if (arguments is T) {
        return arguments;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static bool validateTestData(dynamic testData) {
    if (testData == null) {
      return false;
    }

    if (testData is Test) {
      if (testData.testId == null || testData.testId!.isEmpty) {
        return false;
      }
      if (testData.name == null || testData.name!.isEmpty) {
        return false;
      }
      return true;
    } else if (testData is AiTestItem) {
      if (testData.testId == null || testData.testId!.isEmpty) {
        return false;
      }
      if (testData.name == null || testData.name!.isEmpty) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  static Future<void> navigateToTestDetails(
    dynamic testData,
    String route,
  ) async {
    if (!validateTestData(testData)) {
      Get.snackbar(
        'Invalid Test Data',
        'Test information is incomplete',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    await safeNavigate(route: route, arguments: testData);
  }

  static void showErrorDialog(String title, String message) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  static void showLoadingDialog(String message) {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void navigateToHome() {
    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        Get.offAll(() => MyHomePage());

        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.currentIndex.value = 0;
      } else {
        Get.offAll(() => IntroMainScreen());
      }
    } catch (e) {
      Get.offAll(() => MyHomePage());
    }
  }

  static void navigateToHomeWithTab(int tabIndex) {
    try {
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        Get.offAll(() => MyHomePage());

        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.currentIndex.value = 0;
      } else {
        Get.offAll(() => IntroMainScreen());
      }
    } catch (e) {
      Get.offAll(() => MyHomePage());
    }
  }
}
