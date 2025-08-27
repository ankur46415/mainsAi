import 'package:http/http.dart' as http;

import '../../app_imports.dart';
import '../../model/creditGetModel.dart';

class CreditBalanceController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;

  Rx<CreditGetApi?> creditData = Rx<CreditGetApi?>(null);
  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    fetchCreditBalance();
  }

  void fetchCreditBalance() async {
    print("Starting fetchCreditBalance...");

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    print("Retrieved authToken: $authToken");

    if (authToken == null) {
      Get.snackbar("Error", "Auth token not found");
      print("Auth token not found, aborting fetchCreditBalance.");
      return;
    }

    try {
      isLoading.value = true;
      print("Sending GET request to fetch credit balance...");

      final url = "https://aipbbackend-c5ed.onrender.com/api/clients/CLI147189HIGB/mobile/credit/account";
      print("Request URL: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print("Response JSON: $jsonData");

        creditData.value = CreditGetApi.fromJson(jsonData);
        print("Parsed credit data: ${creditData.value}");
      } else {
        Get.snackbar(
          "Error",
          "Failed to load credit data: ${response.statusCode}",
        );
        print("Failed to load data. Status: ${response.statusCode}, Body: ${response.body}");
      }
    } catch (e) {
      print("Exception occurred while fetching credit balance: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
      print("Finished fetchCreditBalance.");
    }
  }

}
