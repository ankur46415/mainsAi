import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/api_services.dart';

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

      final url = "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/transactions";
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          paymentHistory.value = PaymentHistory.fromJson(jsonData);
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }
}
