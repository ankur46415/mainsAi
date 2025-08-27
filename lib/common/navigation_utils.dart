import 'package:mains/app_imports.dart';
import 'package:mains/model/ai_test_subjective.dart';

class NavigationUtils {
  static Future<T?> safeNavigate<T>({
    required String route,
    dynamic arguments,
    bool preventDuplicates = true,
  }) async {
    try {
      if (arguments == null) {
        print('⚠️ Warning: No arguments provided for route: $route');
      }

      return await Get.toNamed<T>(
        route,
        arguments: arguments,
        preventDuplicates: preventDuplicates,
      );
    } catch (e) {
      print('❌ Navigation error: $e');
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
        print('⚠️ Warning: No arguments found');
        return null;
      }

      if (arguments is T) {
        return arguments;
      } else {
        print('❌ Type mismatch: Expected $T, got ${arguments.runtimeType}');
        return null;
      }
    } catch (e) {
      print('❌ Error getting arguments: $e');
      return null;
    }
  }

  /// Validate test data before navigation
  static bool validateTestData(dynamic testData) {
    if (testData == null) {
      print('❌ Test data is null');
      return false;
    }

    // Check if it's a Test (subjective) or AiTestItem (objective)
    if (testData is Test) {
      if (testData.testId == null || testData.testId!.isEmpty) {
        print('❌ Test ID is missing');
        return false;
      }
      if (testData.name == null || testData.name!.isEmpty) {
        print('❌ Test name is missing');
        return false;
      }
      return true;
    } else if (testData is AiTestItem) {
      if (testData.testId == null || testData.testId!.isEmpty) {
        print('❌ Test ID is missing');
        return false;
      }
      if (testData.name == null || testData.name!.isEmpty) {
        print('❌ Test name is missing');
        return false;
      }
      return true;
    } else {
      print('❌ Invalid test data type: ${testData.runtimeType}');
      return false;
    }
  }

  /// Navigate to test details with validation
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

  /// Show error dialog
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

  /// Show loading dialog
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

  /// Hide loading dialog
  static void hideLoadingDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  static void navigateToHome() {
    try {
      // Check if user is logged in
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        // Navigate to home with proper tab index
        Get.offAll(() => MyHomePage());

        // Set the bottom navigation to home tab (index 0)
        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.currentIndex.value = 0;
      } else {
        // If not logged in, go to intro screen
        Get.offAll(() => IntroMainScreen());
      }
    } catch (e) {
      print('Navigation error: $e');
      // Fallback navigation - try direct navigation
      Get.offAll(() => MyHomePage());
    }
  }

  static void navigateToHomeWithTab(int tabIndex) {
    try {
      // Check if user is logged in
      final authService = Get.find<AuthService>();
      if (authService.isLoggedIn) {
        // Navigate to home
        Get.offAll(() => MyHomePage());

        // Set the bottom navigation to home tab (index 0)
        final bottomNavController = Get.find<BottomNavController>();
        bottomNavController.currentIndex.value = 0;

        // Note: Tab index will be handled by the HomeScreenPage when it initializes
        // You can pass tabIndex as arguments if needed
      } else {
        // If not logged in, go to intro screen
        Get.offAll(() => IntroMainScreen());
      }
    } catch (e) {
      print('Navigation error: $e');
      // Fallback navigation
      Get.offAll(() => MyHomePage());
    }
  }
}
