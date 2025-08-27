import 'package:mains/app_imports.dart';
import 'package:mains/common/utils.dart';
import 'package:http/http.dart' as http;

class AiTestObjectiveController extends GetxController {
  final Rxn<AiTestHomeResponse> aiTestHomeResponse = Rxn<AiTestHomeResponse>();
  final RxBool isLoading = false.obs;

  Future<void> fetchObjectiveTestHomeData(TickerProvider ticker) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('authToken') ?? '';

      await callWebApiGet(
        ticker,
        ApiUrls.objectiveTestList, 
        token: token,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final body = jsonDecode(response.body);
          if (body['success'] == true) {
            aiTestHomeResponse.value = AiTestHomeResponse.fromJson(body);
          } else {
            Utils.showToast("API returned success: false");
          }
        },
        onError: () {
          Utils.showToast("Something went wrong while fetching data");
        },
      );
    } catch (e) {
      Utils.showToast("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
