import 'package:mains/app_imports.dart';
import 'package:mains/models/Specific_Plan.dart';

class SpecificCourseController extends GetxController {
  late SharedPreferences prefs;
  SpecificCourseController({this.planId});

  String? authToken;
  final String? planId;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<PlanData> plan = Rxn<PlanData>();
  final RxBool _isRequestInFlight = false.obs;
  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    fetchPlan();
  }

  Future<void> fetchPlan() async {
    if (_isRequestInFlight.value) {
      return;
    }
    if (planId == null || planId!.isEmpty) {
      print('❌ fetchPlan: planId is null or empty');
      return;
    }
    if (authToken == null || authToken!.isEmpty) {
      // Ensure token is loaded before making the request
      try {
        prefs = await SharedPreferences.getInstance();
        authToken = prefs.getString(Constants.authToken);
      } catch (_) {}
      if (authToken == null || authToken!.isEmpty) {
        print('⏸️ fetchPlan: authToken not available yet, skipping request');
        return;
      }
    }

    print('📡 fetchPlan: Starting fetch for planId = $planId');
    isLoading.value = true;
    errorMessage.value = '';
    _isRequestInFlight.value = true;

    try {
      final String url = ApiUrls.creditPlanBase + planId!;
      print('🌐 Request URI: $url');
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          print('📥 Response Status: ${response.statusCode}');
          print('📦 Response Body: ${response.body}');
          if (response.statusCode == 200) {
            final Map<String, dynamic> body =
                json.decode(response.body) as Map<String, dynamic>;
            final PlanResponse parsed = PlanResponse.fromJson(body);
            plan.value = parsed.data;
            print('✅ Plan data fetched successfully: $body');
          } else if (response.statusCode == 401) {
            errorMessage.value = 'Unauthorized. Please log in again.';
            print('⚠️ Unauthorized (401)');
          } else {
            errorMessage.value =
                'Request failed: ${response.statusCode} ${response.reasonPhrase ?? ''}'
                    .trim();
            print('⚠️ Request failed: ${errorMessage.value}');
          }
        },
        onError: () {
          errorMessage.value = 'Failed to fetch plan';
        },
      );
    } catch (e) {
      errorMessage.value = e.toString();
      print('❗ Exception caught: $e');
    } finally {
      isLoading.value = false;
      _isRequestInFlight.value = false;
      print('🏁 fetchPlan: Finished');
    }
  }
}
