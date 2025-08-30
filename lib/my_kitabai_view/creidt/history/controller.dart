import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/payment_history.dart';


class PaymentHistoryController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  Rx<PaymentHistory?> paymentHistory = Rx<PaymentHistory?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    print("📌 PaymentHistoryController onInit called");
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
    print("🔑 Loaded authToken: $authToken");
  }

  Future<void> fetchPaymentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    print("📌 fetchPaymentHistory() called");
    try {
      isLoading.value = true;
      print("⏳ Loading payment history...");

      final url = Uri.parse(
        "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/transactions",
      );

      print("🌐 GET Request URL: $url");
      print("📩 Request Headers: {Authorization: Bearer $authToken, Content-Type: application/json}");

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      print("📥 Response Status Code: ${response.statusCode}");
      print("📥 Raw Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        print("✅ Decoded JSON: $jsonData");

        paymentHistory.value = PaymentHistory.fromJson(jsonData);
        print("📊 Parsed Payment History: ${paymentHistory.value}");
        print("📊 Total Records: ${paymentHistory.value?.data?.length ?? 0}");
      } else {
        print("❌ Failed to load payment history: ${response.statusCode}");
      }
    } catch (e) {
      print("💥 Error fetching payment history: $e");
    } finally {
      isLoading.value = false;
      print("🏁 Finished fetching payment history.");
    }
  }
}
