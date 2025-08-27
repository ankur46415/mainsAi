import 'package:get/get.dart';
import 'controller.dart';

class MyLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyLibraryController>(() => MyLibraryController());
  }
} 