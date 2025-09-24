import 'package:mains/app_imports.dart';
import 'dart:convert';
import 'package:mains/models/get_all_cart_list.dart';
import 'package:mains/common/api_services.dart';

class CreditCardController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  var cartList = Rxn<GetCartList>();
  var isLoading = false.obs;
  var error = ''.obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    await fetchCartList(null);
  }

  Future<void> fetchCartList(TickerProvider? tickerProvider) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';
    isLoading.value = true;
    error.value = '';

    final url =
        'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart';

    await callWebApiGet(
      tickerProvider,
      url,
      token: authToken,
      onResponse: (response) {
        try {
          cartList.value = GetCartList.fromJson(json.decode(response.body));
        } catch (e) {
          error.value = 'Failed to parse cart data';
        }
        isLoading.value = false;
      },
      onError: () {
        error.value = 'Failed to load cart';
        isLoading.value = false;
      },
    );
  }

  Future<void> deleteCartItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final url = Uri.parse(
      'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart/item/$itemId',
    );
    isLoading.value = true;
    error.value = '';
    print("🔗 DeleteCartItem API URL: $url");
    print("🔑 Auth Token: $authToken");

    await callWebApiDelete(
      null,
      url.toString(),
      token: authToken ?? '',
      showLoader: false,
      hideLoader: true,
      onResponse: (response) async {
        print("✅ Item deleted successfully");
        await fetchCartList(null);
      },
      onError: () {
        error.value = 'Failed to delete item';
        print("❌ Error: ${error.value}");
      },
    );

    isLoading.value = false;
    print("ℹ️ Loading finished (isLoading = false)");
  }
}
