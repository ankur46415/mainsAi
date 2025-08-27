import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  var isLoading = false.obs;
  String message = 'Loading...';
  Color textColor = Colors.red;
  double imageHeight = 100;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });
  }

  void showLoading({String? message, Color? color, double? height}) {
    if (message != null) this.message = message;
    if (color != null) textColor = color;
    if (height != null) imageHeight = height;
    isLoading.value = true;
    animationController.forward();
  }

  void hideLoading() {
    isLoading.value = false;
    animationController.stop();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

class LoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoadingController());
  }
}
