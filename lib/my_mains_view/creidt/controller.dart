import '../../app_imports.dart';
import '../../models/creditGetModel.dart';
import '../../common/api_services.dart';

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

    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');


    if (authToken == null) {
      return;
    }

    try {
      isLoading.value = true;

      final url = "https://test.ailisher.com/api/clients/CLI147189HIGB/mobile/credit/account";
      await callWebApiGet(
        null,
        url,
        token: authToken,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final jsonData = json.decode(response.body);
          creditData.value = CreditGetApi.fromJson(jsonData);
        },
        onError: () {},
      );
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

}
