import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/payment_history.dart';


class PaymentHistoryController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  Rx<PaymentHistory?> paymentHistory = Rx<PaymentHistory?>(null);
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");
  }

  Future<void> fetchPaymentHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    try {
      isLoading.value = true;

      final url = Uri.parse(
        "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/transactions",
      );

    
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

    

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        paymentHistory.value = PaymentHistory.fromJson(jsonData);
      
      } else {
      }
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
