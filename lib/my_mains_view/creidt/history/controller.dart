import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/api_services.dart';
import '../../../models/payment_history.dart';
import '../../../models/order_history.dart';

class PaymentHistoryController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  Rx<PaymentHistory?> paymentHistory = Rx<PaymentHistory?>(null);
  Rx<OrderHistory?> orderHistory = Rx<OrderHistory?>(null);

  RxBool isLoadingPayment = false.obs;
  RxBool isLoadingOrder = false.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString("authToken");

    if (authToken != null && authToken!.isNotEmpty) {
      await fetchPaymentHistory();
      await fetchOrderHistory();
    } else {
      print("Auth token missing! Please login first.");
    }
  }

  Future<void> fetchPaymentHistory() async {
    if (authToken == null) return;

    try {
      isLoadingPayment.value = true;
      final url =
          "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/transactions";

      await callWebApiGet(
        null,
        url,
        token: authToken!, // use class-level token consistently
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          paymentHistory.value = PaymentHistory.fromJson(jsonData);
        },
        onError: () {
          print("Failed to fetch payment history");
        },
      );
    } catch (e) {
      print("Exception fetching payment history: $e");
    } finally {
      isLoadingPayment.value = false;
    }
  }

  Future<void> fetchOrderHistory() async {
    if (authToken == null) return;

    try {
      isLoadingOrder.value = true;
      final url =
          "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/orders";

      await callWebApiGet(
        null,
        url,
        token: authToken!, // same token here
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final Map<String, dynamic> jsonData = jsonDecode(response.body);
          orderHistory.value = OrderHistory.fromJson(jsonData);
        },
        onError: () {
          print("Failed to fetch order history");
        },
      );
    } catch (e) {
      print("Exception fetching order history: $e");
    } finally {
      isLoadingOrder.value = false;
    }
  }
}
