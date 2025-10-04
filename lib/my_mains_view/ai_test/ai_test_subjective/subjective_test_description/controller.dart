import 'package:mains/app_imports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../common/shred_pref.dart';
import '../../../../models/ai_test_subjective.dart';

class SubjectiveTestDescriptionController extends GetxController {
  var testName = "".obs;
  var duration = "".obs;
  var questionCount = "".obs;
  var maxMarks = "".obs;
  var description = "".obs;
  var testId = "".obs;
  var isTestStarted = false.obs;

  // Method to set test data including test ID
  void setTestData(String id, String name, String desc, String dur, String questions, String marks) {
    testId.value = id;
    testName.value = name;
    description.value = desc;
    duration.value = dur;
    questionCount.value = questions;
    maxMarks.value = marks;
  }

  // Initialize controller with Test model data
  void initializeWithTestData(Test test) {
    testId.value = test.testId ?? "";
    testName.value = test.name ?? "";
    description.value = test.instructions ?? "";
    duration.value = "${test.estimatedTime ?? 0} Min";
    questionCount.value = "${test.userTestStatus?.totalQuestions ?? 0}";
    maxMarks.value = test.testMaximumMarks?.toString() ?? "0";
    
    // Check test status after setting data
    checkTestStatus();
  }

  // Method to get test ID
  String getTestId() {
    return testId.value;
  }

  // Check if test has been started
  Future<void> checkTestStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final startTime = prefs.getInt('${Constants.testStartTime}_${testId.value}');
    isTestStarted.value = startTime != null;
  }

  // Get button text based on test status
  String getButtonText() {
    return isTestStarted.value ? "Continue Test" : "Start Test Now";
  }
}

class SubjectiveTestDescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubjectiveTestDescriptionController());
  }
}
