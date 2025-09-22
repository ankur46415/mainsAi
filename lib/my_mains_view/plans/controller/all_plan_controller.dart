import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';
import '../../../models/course_plans.dart';
import '../../../common/shred_pref.dart';

class AllPlanController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  
  RxList<Data> plans = <Data>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    if (authToken != null) {
      fetchPlans();
    } else {
      hasError.value = true;
      errorMessage.value = 'Authentication token not found';
    }
  }

  Future<void> fetchPlans() async {
    if (authToken == null) return;
    
    try {
      isLoading.value = true;
      hasError.value = false;
      await callWebApiGet(
        null,
        ApiUrls.creditPlans,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          if (response.statusCode == 200) {
            final Map<String, dynamic> jsonData = json.decode(response.body);
            final CoursePlansData coursePlansData = CoursePlansData.fromJson(jsonData);
            if (coursePlansData.success == true && coursePlansData.data != null) {
              plans.value = coursePlansData.data!;
            } else {
              hasError.value = true;
              errorMessage.value = 'Failed to load plans';
            }
          } else {
            hasError.value = true;
            errorMessage.value = 'Server error: ${response.statusCode}';
          }
        },
        onError: () {
          hasError.value = true;
          errorMessage.value = 'Network error: Failed to fetch plans';
        },
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Network error: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPlans() async {
    await fetchPlans();
  }
}
