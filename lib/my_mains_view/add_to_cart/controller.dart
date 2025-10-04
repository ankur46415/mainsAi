import 'package:mains/app_imports.dart';
import 'package:mains/models/get_all_cart_list.dart';
import 'package:mains/my_mains_view/creidt/addCredit/paytm_page.dart';

class AddToCartController extends GetxController {
  // Cart UI state management
  var selectedIndexes = <int>{}.obs;
  var initialSelectionDone = false.obs;
  var showSummary = false.obs;

  // Get cart list from CreditCardController
  Rxn<GetCartList> get cartList {
    try {
      final creditController = Get.find<CreditCardController>();
      return creditController.cartList;
    } catch (e) {
      return Rxn<GetCartList>();
    }
  }

  // Computed properties
  double get subTotal {
    final items = cartList.value?.data?.items;
    if (items == null) return 0;
    double sum = 0;
    for (int i = 0; i < (items.length); i++) {
      if (selectedIndexes.contains(i)) {
        sum += (items[i].price ?? 0) * 1;
      }
    }
    return sum;
  }

  double get gstAmount {
    final items = cartList.value?.data?.items;
    if (items == null) return 0;
    double gstSum = 0;
    for (int i = 0; i < items.length; i++) {
      if (selectedIndexes.contains(i)) {
        final price = items[i].price ?? 0;
        final gstPercent = items[i].workbookId?.gst ?? 0;
        gstSum += price * (gstPercent / 100);
      }
    }
    return gstSum;
  }

  double get total => subTotal + gstAmount;

  // Methods for managing selection
  void toggleItemSelection(int index) {
    if (selectedIndexes.contains(index)) {
      selectedIndexes.remove(index);
    } else {
      selectedIndexes.add(index);
    }
  }

  void toggleSelectAll() {
    final items = cartList.value?.data?.items ?? [];
    if (selectedIndexes.length == items.length) {
      selectedIndexes.clear();
    } else {
      selectedIndexes.value = Set<int>.from(
        List.generate(items.length, (i) => i),
      );
    }
  }

  void initializeSelection() {
    final items = cartList.value?.data?.items ?? [];
    if (!initialSelectionDone.value && items.isNotEmpty) {
      selectedIndexes.value = Set<int>.from(
        List.generate(items.length, (i) => i),
      );
      initialSelectionDone.value = true;
    }
    // If cart becomes empty, reset the flag
    if (items.isEmpty && initialSelectionDone.value) {
      initialSelectionDone.value = false;
    }
  }

  void resetSelectionAfterDelete() {
    final items = cartList.value?.data?.items ?? [];
    selectedIndexes.value = Set<int>.from(
      List.generate(items.length, (i) => i),
    );
    initialSelectionDone.value = true;
  }

  void toggleSummary() {
    showSummary.value = !showSummary.value;
  }

  void hideSummary() {
    showSummary.value = false;
  }

  // Get CreditCardController instance
  CreditCardController get creditController {
    return Get.find<CreditCardController>();
  }

  // Proceed to payment method
  Future<void> proceedToPayment() async {
    final items = cartList.value?.data?.items ?? [];
    final selectedWorkbookIds = selectedIndexes
        .map((i) => items[i].workbookId?.id)
        .whereType<String>()
        .toList();

    await creditController.proceedToPayment(selectedWorkbookIds);
  }
}

class CreditCardController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  var cartList = Rxn<GetCartList>();
  var isLoading = false.obs;
  var error = ''.obs;

  // Getter to access cart list from AddToCartController
  Rxn<GetCartList> get cartListData => cartList;
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

    isLoading.value = true; // Show loader immediately

    await callWebApi(
      null,
      url,
      body,
      token: authToken,
      showLoader: false, // we control loader manually
      hideLoader: true,
      onResponse: (response) async {
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
              // Navigate to Paytm page
              await Get.to(
                () => PaytmPaymentPage(
                  paytmUrl: paytmUrl,
                  paytmParams: paytmParams,
                ),
              );

              // Hide loader only after navigation completes
              isLoading.value = false;
            } else {
              isLoading.value = false;
              Get.snackbar(
                "Error",
                "Invalid payment data received",
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } catch (e) {
            isLoading.value = false;
            Get.snackbar(
              "Error",
              "Failed to parse payment data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          isLoading.value = false;
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
