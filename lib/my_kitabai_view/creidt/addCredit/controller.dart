import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/my_kitabai_view/creidt/addCredit/paytm_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mains/model/addAmount.dart' as model;

import '../../../common/shred_pref.dart';
import '../../auth_service/auth_service.dart';

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

    print("🔄 Starting fetchRechargePlans...");
    isLoading.value = true;

    const url =
        'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/recharge-plans';
    print("🌐 API URL: $url");
    print("🛡️ Authorization Token: $authToken");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("✅ JSON Decoded: $jsonData");

        final parsed = model.AddAmountResponse.fromJson(jsonData);
        plans.value = parsed.data ?? [];

        print("✅ Parsed ${plans.length} plans:");
        for (var plan in plans) {
          print("""
🔹 Plan ID: ${plan.id}
   Name: ${plan.name}
   Description: ${plan.description}
   Credits: ${plan.credits}
   MRP: ₹${plan.mrp}
   Offer Price: ₹${plan.offerPrice}
   Status: ${plan.status}
   Created At: ${plan.createdAt}
""");
        }
      } else {
        print(
          "❌ Failed to fetch plans: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("💥 Exception occurred while fetching recharge plans: $e");
    } finally {
      isLoading.value = false;
      print("✅ fetchRechargePlans finished. isLoading: ${isLoading.value}");
    }
  }

  final String backendUrl =
      'https://test.ailisher.com/api/paytm/initiate';

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

      print("🔍 Debug - AuthService Values:");
      print("   userId: $userId");
      print("   userEmail: $userEmail");
      print("   userName: $userName");
      print("   userPhone: $userPhone");
      print("   authToken: $authToken");

      // Find the selected plan to get planId and credits
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
