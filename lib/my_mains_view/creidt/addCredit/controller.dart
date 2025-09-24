import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/my_mains_view/creidt/addCredit/paytm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mains/models/addAmount.dart' as model;
import '../../../common/api_urls.dart';
import '../../../common/api_services.dart';

import '../../../common/shred_pref.dart';
import '../../../common/auth_service/auth_service.dart';

class PaymentController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  final AuthService _authService = Get.find<AuthService>();

  var isLoading = false.obs;
  var plans = <model.AddAmount>[].obs;
  var currentAmount = 0.0.obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
    fetchRechargePlans();
  }

  Future<void> fetchRechargePlans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString(Constants.authToken);

    isLoading.value = true;

    final String url = '${ApiUrls.creditPlans}/without-items';

    try {
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final jsonData = json.decode(response.body);
          final parsed = model.AddAmountResponse.fromJson(jsonData);
          plans.value = parsed.data ?? [];
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  final String backendUrl = ApiUrls.paytmInitiate;

  Future<void> initiatePayment({
    required double amount,
    required BuildContext context,
  }) async {
    try {
      String? authToken = _authService.authToken;
      String? userId = _authService.userId;
      String? userEmail = _authService.userEmail;
      String? userName = _authService.userName;
      String? userPhone = _authService.userPhone;

      final selectedPlan = plans.firstWhereOrNull(
        (plan) => plan.offerPrice == amount.toInt(),
      );

      if (selectedPlan == null) {
        Get.snackbar("Error", "Selected plan not found");
        return;
      }

      final requestBody = {
        "amount": selectedPlan.offerPrice,
        "customerEmail": userEmail ?? "",
        "customerPhone": userPhone ?? "",
        "customerName": userName ?? " ",
        "projectId": "ailisher",
        "userId": userId ?? "",
        "planId": selectedPlan.id,
        "credits": selectedPlan.credits,
      };

      await callWebApi(
        null,
        backendUrl,
        requestBody,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
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
            Get.snackbar("Error", "Missing Paytm URL or Params");
          }
        },
        onError: () {
          Get.snackbar("Error", "Failed to initiate payment.");
        },
      );
    } catch (e, stack) {
      log("Exception", error: e, stackTrace: stack);
      Get.snackbar("Error", e.toString());
    }
  }
}
