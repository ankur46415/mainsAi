import 'package:mains/app_imports.dart';

class IntroController extends GetxController {
  var currentPage = 0.obs;
  late PageController pageController;

  final List<String> images = [
    "assets/images/intro_t.png",
    "assets/images/intro_s.png",
    "assets/images/intro_f.png",
  ];

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  void nextPage() {
    if (currentPage.value < images.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.off(() => UseerLogInScreen());
    }
  }

  void skipToEnd() {
    pageController.jumpToPage(images.length - 1);
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}

class IntroBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IntroController());
  }
}
