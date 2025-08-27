import 'package:mains/app_imports.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> bounceAnimation;
  var initialJumpDone = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Initial jump after 100ms
    Future.delayed(const Duration(milliseconds: 100), () {
      initialJumpDone.value = true;
    });

    // Bounce animation
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    bounceAnimation = Tween<double>(begin: 0.0, end: -20.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
