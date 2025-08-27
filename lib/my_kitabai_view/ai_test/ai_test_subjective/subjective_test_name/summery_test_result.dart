import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:mains/model/subjective_summary.dart';

class SummeryTestResult extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  final String testId;
  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  Rx<SummarySubjective?> summaryData = Rx<SummarySubjective?>(null);
  SummeryTestResult(this.testId);

  @override
  void onInit() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    fetchSummaryData();
    super.onInit();
  }

  Future<void> fetchSummaryData() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    final url = '${ApiUrls.subjectiveTestList}/$testId';

    isLoading.value = true;
    error.value = '';

    await callWebApiGet(
      null,
      url,
      onResponse: (response) {
        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          summaryData.value = SummarySubjective.fromJson(jsonData);
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          SharedPreferences.getInstance().then((prefs) async {
            await prefs.clear();
            Get.offAll(() => User_Login_option());
          });
        } else {
          error.value = 'Failed to fetch summary (${response.statusCode})';
        }

        isLoading.value = false;
      },
      onError: () {
        error.value = 'Error occurred while fetching summary';
        isLoading.value = false;
      },
      token: authToken ?? '',
      showLoader: false,
      hideLoader: false,
    );
  }
}
