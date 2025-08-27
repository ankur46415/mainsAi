import 'package:get/get.dart';

class BottomNavController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = 0; 
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  void resetToHome() {
    currentIndex.value = 0;
  }
}

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BottomNavController());
  }
}
