import 'package:mains/app_imports.dart';
import 'package:mains/model/ai_test_subjective.dart';

class AiTestSubjectiveController extends GetxController {
  var isLoading = false.obs;
  var aiTestSubjective = Rxn<AiTestSubjective>();
  var errorMessage = ''.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    errorMessage.value = '';
    hasError.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchAiTestSubjective(TickerProvider ticker) async {
    try {
      hasError.value = false;
      errorMessage.value = '';
      isLoading.value = true;

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      if (authToken == null || authToken.isEmpty) {
        throw Exception('Authentication token not found');
      }

      await callWebApiGet(
        ticker,
        ApiUrls.subjectiveTestList,
        token: authToken,
        showLoader: false, // ✅ Disable internal loader
        hideLoader: false,
        onResponse: (response) {
          try {
            if (response.statusCode == 200) {
              final Map<String, dynamic> body = jsonDecode(response.body);

              if (body['success'] == true) {
                aiTestSubjective.value = AiTestSubjective.fromJson(body);
                hasError.value = false;
                errorMessage.value = '';

                final data = aiTestSubjective.value?.data;
                if (data?.categories == null || data!.categories!.isEmpty) {
                  errorMessage.value = 'No test categories available';
                  hasError.value = true;
                }
              } else {
                final errorMsg =
                    body['message'] ?? 'API returned success: false';
                errorMessage.value = errorMsg;
                hasError.value = true;
              }
            } else if (response.statusCode == 401) {
              errorMessage.value = 'Authentication failed. Please login again.';
              hasError.value = true;
              Get.offAllNamed('/login');
            } else if (response.statusCode == 403) {
              errorMessage.value =
                  'Access denied. Please check your permissions.';
              hasError.value = true;
            } else {
              errorMessage.value = 'Server error (${response.statusCode})';
              hasError.value = true;
            }
          } catch (e) {
            errorMessage.value = 'Failed to parse response: $e';
            hasError.value = true;
          }
        },
        onError: () {
          errorMessage.value = 'Network error. Please check your connection.';
          hasError.value = true;
        },
      );
    } catch (e) {
      errorMessage.value = 'Unexpected error: $e';
      hasError.value = true;
    } finally {
      isLoading.value = false; // ✅ You control loading in your UI
    }
  }

  void clearData() {
    aiTestSubjective.value = null;
    errorMessage.value = '';
    hasError.value = false;
  }

  bool get hasData {
    return aiTestSubjective.value?.data?.categories != null &&
        aiTestSubjective.value!.data!.categories!.isNotEmpty;
  }

  int get totalTestCount {
    final data = aiTestSubjective.value?.data;
    if (data?.categories == null) return 0;

    int total = 0;
    for (final category in data!.categories!) {
      if (category.subcategories != null) {
        for (final subcategory in category.subcategories!) {
          if (subcategory.tests != null) {
            total += subcategory.tests!.length;
          }
        }
      }
    }
    return total;
  }
}
