import 'package:mains/app_imports.dart';

class SubjectiveTestDescriptionController extends GetxController {
  var testName = "Essay Writing Test - 1".obs;
  var duration = "90 mins".obs;
  var questionCount = "1".obs;
  var maxMarks = "250".obs;
  var description = "Write an essay on the topic...".obs;
  var testId = "".obs; // Add test ID variable

  // Method to set test data including test ID
  void setTestData(String id, String name, String desc, String dur, String questions, String marks) {
    print('🔧 SubjectiveTestDescriptionController: Setting test data');
    print('🔧 SubjectiveTestDescriptionController: Test ID: $id');
    print('🔧 SubjectiveTestDescriptionController: Test Name: $name');
    
    testId.value = id;
    testName.value = name;
    description.value = desc;
    duration.value = dur;
    questionCount.value = questions;
    maxMarks.value = marks;
    
    print('✅ SubjectiveTestDescriptionController: Test data set successfully');
  }

  // Method to get test ID
  String getTestId() {
    print('📤 SubjectiveTestDescriptionController: Getting test ID: ${testId.value}');
    return testId.value;
  }
}

class SubjectiveTestDescriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SubjectiveTestDescriptionController());
  }
}
