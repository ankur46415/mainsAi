import 'package:mains/app_imports.dart';
import 'package:mains/models/get_all_cart_list.dart';
import 'package:mains/my_mains_view/creidt/addCredit/paytm_page.dart';

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
    authToken = prefs.getString(Constants.userEmail);
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

  Future<void> proceedToPayment(List<String> workbookIds) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString(Constants.authToken) ?? '';
    final customerEmail = prefs.getString(Constants.userEmail) ?? '';

    if (workbookIds.isEmpty) {
      Get.snackbar(
        "Error",
        "No items selected for payment",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final url =
        'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart/checkout/item';

    final body = {"workbookIds": workbookIds, "customerEmail": customerEmail};

    isLoading.value = true;

    await callWebApi(
      null,
      url,
      body,
      token: authToken,
      showLoader: false,
      hideLoader: true,
      onResponse: (response) {
        isLoading.value = false;

        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(response.body);

            final paytmUrl = data['paytmUrl'] as String?;
            final paytmParams = Map<String, String>.from(
              (data['paytmParams'] as Map).map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              ),
            );

            if (paytmUrl != null && paytmParams.isNotEmpty) {
              Get.to(
                () => PaytmPaymentPage(
                  paytmUrl: paytmUrl,
                  paytmParams: paytmParams,
                ),
              );
            } else {
              Get.snackbar(
                "Error",
                "Invalid payment data received",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } catch (e) {
            Get.snackbar(
              "Error",
              "Failed to parse payment data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to proceed to payment",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onError: () {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Failed to proceed to payment",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

}
