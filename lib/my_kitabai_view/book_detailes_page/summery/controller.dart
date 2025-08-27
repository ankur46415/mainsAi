import 'package:get/get.dart';

class SummaryController extends GetxController {
  final RxBool isExpanded = false.obs;

  void toggle() {
    isExpanded.toggle();
  }

  void expand() {
    isExpanded.value = true;
  }

  void collapse() {
    isExpanded.value = false;
  }
}

class SummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SummaryController());
  }
}
