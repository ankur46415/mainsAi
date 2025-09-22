import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
import 'package:mains/common/auth_service/auth_service.dart';
import 'package:mains/my_mains_view/creidt/addCredit/paytm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';

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

  final String backendUrl = ApiUrls.paytmInitiate;

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


      await callWebApi(
        null,
        backendUrl,
        requestBody,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
        
          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);

            final String? paytmUrl = data['paytmUrl'];
            final Map<String, dynamic>? paytmParams = Map<String, dynamic>.from(
              data['paytmParams'] ?? {},
            );

          
            if (paytmUrl != null &&
                paytmParams != null &&
                paytmParams.isNotEmpty) {
              final params = paytmParams.map(
                (key, value) => MapEntry(key, value.toString()),
              );
              Get.to(
                () => PaytmPaymentPage(paytmUrl: paytmUrl, paytmParams: params),
              );
            } else {
            }
          } else {
            Get.snackbar("Error", "Failed to initiate payment.");
            log("Failed Response: ${response.body}");
          }
        },
        onError: () {
        },
      );
    } catch (e, stack) {
      log("Exception", error: e, stackTrace: stack);
    }
  }
}
