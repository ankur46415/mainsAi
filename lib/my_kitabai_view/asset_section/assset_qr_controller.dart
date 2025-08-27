import 'package:get/get.dart';
import 'package:mains/common/api_urls.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

import '../../app_routes.dart';

class AsssetQrController extends GetxController {
  bool isScanning = true;
  var isLoading = false.obs;
  var qrResponse = ''.obs;
  var hasError = false.obs;

  void handleQrDetection(BarcodeCapture barcodeCapture) {
    if (!isScanning) return;

    final barcode = barcodeCapture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code != null) {
      isScanning = false;
      debugPrint('Scanned QR Code: $code');
      debugPrint('Passing to onQrScanned: $code');

      onQrScanned(code);

      Future.delayed(const Duration(seconds: 2), () {
        isScanning = true;
      });
    }
  }

  void onQrScanned(String data) {
    data = data.trim();
    debugPrint("Controller received QR: $data");

    String id;
    if (data.contains('/')) {
      id = data.split('/').last;
    } else {
      id = data;
    }

    final apiUrl = "${ApiUrls.getAssetData}$id";
    debugPrint("API URL to fetch: $apiUrl");
    Get.toNamed(AppRoutes.assetResult, arguments: {'assetUrl': data});
  }

  void clearResponse() {
    qrResponse.value = '';
    hasError.value = false;
  }
}
