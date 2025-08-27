import 'package:get/get.dart';
import 'package:mains/common/api_urls.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

      Get.snackbar(
        "QR Code Scanned",
        code,
        snackPosition: SnackPosition.BOTTOM,
      );

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

    // Build the API URL
    final apiUrl = "${ApiUrls.getAssetData}$id";
    debugPrint("API URL to fetch: $apiUrl");
    fetchQrResponse(apiUrl);
  }

  Future<void> fetchQrResponse(String url) async {
    debugPrint(">>> fetchQrResponse CALLED WITH: $url");
    try {
      isLoading.value = true;
      hasError.value = false;
      qrResponse.value = '';

      debugPrint("Fetching response from: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(response.body);
          qrResponse.value = json.encode(jsonData);
          debugPrint("Successfully parsed JSON response");
        } catch (e) {
          qrResponse.value = response.body;
          debugPrint("Response is plain text");
        }
      } else {
        hasError.value = true;
        qrResponse.value = "Error: HTTP ${response.statusCode}";
        debugPrint("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      hasError.value = true;
      qrResponse.value = "Error: $e";
      debugPrint("Exception occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearResponse() {
    qrResponse.value = '';
    hasError.value = false;
  }
}

class AsssetQrBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AsssetQrController());
  }
}
