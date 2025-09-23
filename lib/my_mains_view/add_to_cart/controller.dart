import 'package:mains/app_imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mains/models/get_all_cart_list.dart';

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
    await fetchCartList();
  }

  Future<void> fetchCartList() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    isLoading.value = true;
    error.value = '';

    final url = Uri.parse(
      'https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart',
    );

    print("🔗 FetchCartList API URL: $url");
    print("🔑 Auth Token: $authToken");

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print(
        "📤 Request Headers: {Authorization: Bearer $authToken, Content-Type: application/json}",
      );
      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        cartList.value = GetCartList.fromJson(json.decode(response.body));
        print("✅ Cart list parsed successfully: ${cartList.value!.toJson()}");
      } else {
        error.value = 'Failed to load cart: ${response.statusCode}';
        print("❌ Error: ${error.value}");
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
      print("❌ Exception: ${e.toString()}");
    } finally {
      isLoading.value = false;
      print("ℹ️ Loading finished (isLoading = false)");
    }
  }

  Future<void> deleteCartItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final url = Uri.parse('https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/cart/item/$itemId');
    isLoading.value = true;
    error.value = '';
    print("🔗 DeleteCartItem API URL: $url");
    print("🔑 Auth Token: $authToken");
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );
      print(
        "📤 Request Headers: {Authorization: Bearer $authToken, Content-Type: application/json}",
      );
      print("📥 Response Status: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");
      if (response.statusCode == 200) {
        print("✅ Item deleted successfully");
        await fetchCartList();
      } else {
        error.value = 'Failed to delete item: ${response.statusCode}';
        print("❌ Error: ${error.value}");
      }
    } catch (e) {
      error.value = 'Error: ${e.toString()}';
      print("❌ Exception: ${e.toString()}");
    } finally {
      isLoading.value = false;
      print("ℹ️ Loading finished (isLoading = false)");
    }
  }
}
