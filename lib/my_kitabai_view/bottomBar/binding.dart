import 'package:get/get.dart';
import 'controller.dart';

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    // Only create if not already registered
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController(), permanent: true);
    }
  }
} 