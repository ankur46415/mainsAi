import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

 showSmallLoadingDialog() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10),
            ],
          ),
          child: Lottie.asset(
            'assets/lottie/book_loading.json',
            fit: BoxFit.contain,
          ),
        ),
      );
    },
  );
}

void showLogoLoadingDialog() {
  Get.dialog(
    Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Center(
            child: Lottie.asset(
              'assets/lottie/book_loading.json',
              fit: BoxFit.contain,
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(const ['**'], value: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
