import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/my_kitabai_view/auth_service/auth_service.dart';
import 'package:mains/my_kitabai_view/creidt/addCredit/paytm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MakePaymentController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
  }

  final String backendUrl = 'https://test.ailisher.com/api/paytm/initiate';

  Future<void> initiatePayment({
    required String planId,
    required BuildContext context,
  }) async {
    try {
      String? authToken = _authService.authToken;
      String? userId = _authService.userId;
      String? userEmail = _authService.userEmail;
      String? userName = _authService.userName;

      final requestBody = {
        "planId": planId,
        "customerName": userEmail,
        "customerEmail": userName,
      };

      print("Sending POST request to $backendUrl");
      print("Request Body: ${jsonEncode(requestBody)}");

      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Decoded response: $data");

        final String? paytmUrl = data['paytmUrl'];
        final Map<String, dynamic>? paytmParams = Map<String, dynamic>.from(
          data['paytmParams'] ?? {},
        );

        print("Paytm URL: $paytmUrl");
        print("Paytm Params: $paytmParams");

        if (paytmUrl != null && paytmParams != null && paytmParams.isNotEmpty) {
          // Convert all paytmParams values to String
          final params = paytmParams.map(
            (key, value) => MapEntry(key, value.toString()),
          );
          Get.to(
            () => PaytmPaymentPage(paytmUrl: paytmUrl, paytmParams: params),
          );
        } else {
          Get.snackbar("Error", "Missing Paytm URL or Params");
        }
      } else {
        Get.snackbar("Error", "Failed to initiate payment.");
        log("Failed Response: ${response.body}");
      }
    } catch (e, stack) {
      print("Exception occurred: $e");
      log("Exception", error: e, stackTrace: stack);
      Get.snackbar("Error", e.toString());
    }
  }
}
