import 'package:get/get.dart';
import 'package:mains/my_mains_view/yt_reel/yt_reel_controller.dart';

class ReelsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReelsController>(() => ReelsController());
  }
}


