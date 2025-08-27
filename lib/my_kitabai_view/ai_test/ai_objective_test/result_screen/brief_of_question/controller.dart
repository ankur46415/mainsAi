import 'package:get/get.dart';

class BriefOfQuestionController extends GetxController {
  var question =
      "भारतीय संविधान की नौवीं अनुसूची से संबंधित कौन सा कथन सही है?".obs;

  var options =
      [
        "यह मूल अधिकारों से संबंधित है।",
        "यह राज्य नीति के निदेशक सिद्धांतों से संबंधित है।",
        "यह भूमि सुधार से संबंधित है।",
        "यह संसद की शक्तियों को सीमित करता है।",
      ].obs;

  var selectedAnswer = "यह भूमि सुधार से संबंधित है।".obs;
  var correctAnswer = "यह भूमि सुधार से संबंधित है।".obs;
}

class BriefOfQuestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BriefOfQuestionController());
  }
}
