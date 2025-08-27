import 'package:get/get.dart';
import 'package:mains/my_kitabai_view/profile_screen/profile_controller.dart';
import 'package:mains/my_kitabai_view/upload_images/controller.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<UploadAnswersController>(
      () => UploadAnswersController(),
      fenix: true,
    );
  }
}
