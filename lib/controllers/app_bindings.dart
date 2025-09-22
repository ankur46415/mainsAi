import 'package:get/get.dart';
import 'package:mains/my_mains_view/profile_screen/profile_controller.dart';
import 'package:mains/my_mains_view/upload_images/controller.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    // Always register UploadAnswersController eagerly and permanently
    if (!Get.isRegistered<UploadAnswersController>()) {
      Get.put(UploadAnswersController(), permanent: true);
    }
  }
}
