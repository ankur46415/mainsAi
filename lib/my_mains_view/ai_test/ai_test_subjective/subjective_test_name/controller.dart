import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_subjective.dart';

class SubjectiveTestController extends GetxController {
  // Test data and state management
  late Test testData;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var isExpanded = false.obs;
  var isLongDescription = false.obs;

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

      if (arguments is Test) {
        testData = arguments;
      } else {
        _handleError('Invalid test data format');
        return;
      }

      if (testData.testId == null || testData.testId!.isEmpty) {
        _handleError('Test ID is missing');
        return;
      }

      if (testData.name == null || testData.name!.isEmpty) {
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

  void checkIfLongDescription(BuildContext context) {
    if (testData.description != null && testData.description!.isNotEmpty) {
      final textSpan = TextSpan(
        text: testData.description!,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70),
      );

      final tp = TextPainter(
        text: textSpan,
        maxLines: 3,
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: MediaQuery.of(context).size.width - 40);
      isLongDescription.value = tp.didExceedMaxLines;
    }
  }

  void toggleDescriptionExpansion() {
    isExpanded.value = !isExpanded.value;
  }

  String formatDateTime(dynamic date) {
    if (date == null) return '-';
    try {
      final dt =
          date is String
              ? DateTime.parse(date).toLocal()
              : (date as DateTime).toLocal();

      // Convert to 12-hour format
      final hour = dt.hour;
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);

      return '${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}, '
          '$displayHour:$minute $period';
    } catch (e) {
      return date.toString();
    }
  }

  String _monthName(int m) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[m];
  }

  void startTest(BuildContext context) {
    final DateTime? startsAt =
        testData.startsAt != null
            ? DateTime.tryParse(testData.startsAt!)
            : null;
    final now = DateTime.now();

    if (startsAt != null && now.isBefore(startsAt)) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Test Not Started'),
              content: Text('Test will start on: ${formatDateTime(startsAt)}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
      );
      return;
    }

    try {
      Get.toNamed(AppRoutes.subjectiveDescription, arguments: testData);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to navigate to test: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
