import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:mains/models/objective_previous_attempt.dart';

class ObjectiveRestNameController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;

  late String testId;

  final resultData = Rxn<ObjectiveTestResult>();
  final isLoading = true.obs;
  final hasError = false.obs;
  bool _isDisposing = false;

  @override
  void onInit() async {
    try {
      prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString(Constants.authToken);
      super.onInit();

      final arguments = Get.arguments;

      if (arguments is Map<String, dynamic>) {
        testId = arguments['testId'] ?? '';
      } else if (arguments is AiTestItem) {
        testId = arguments.testId;
      } else {
        testId = '';
      }

      if (testId.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 200));
        fetchResult();
      } else {
        if (!_isDisposing) hasError.value = true;
        if (!_isDisposing) isLoading.value = false;
        if (!isClosed) update();
      }
    } catch (e) {
      if (!_isDisposing) hasError.value = true;
      if (!_isDisposing) isLoading.value = false;
      if (!isClosed) update();
    }
  }

  @override
  void onClose() {
    _isDisposing = true;
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> fetchResult() async {
    try {
      if (_isDisposing) return;
      if (!_isDisposing) isLoading.value = true;
      if (!_isDisposing) hasError.value = false;
      if (!isClosed) update();

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString(Constants.authToken);

      if (authToken == null) {
        if (!_isDisposing) hasError.value = true;
        if (!_isDisposing) isLoading.value = false;
        if (!isClosed) update();
        return;
      }

      final url = Uri.parse(
        'https://test.ailisher.com/api/objectivetest/clients/CLI147189HIGB/$testId/results',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      // FULL RAW RESPONSE

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);

        // FULL DECODED JSON MAP

        if (jsonMap['success'] == true) {
          try {
            if (_isDisposing) return;
            resultData.value = ObjectiveTestResult.fromJson(jsonMap['data']);
            if (!isClosed) update();
          } catch (e, stackTrace) {
            if (!_isDisposing) hasError.value = true;
            if (!isClosed) update();
          }
        } else {
          if (!_isDisposing) hasError.value = true;
          if (!isClosed) update();
        }
      } else {
        if (!_isDisposing) hasError.value = true;
        if (!isClosed) update();
      }
    } catch (e) {
      if (!_isDisposing) hasError.value = true;
      if (!isClosed) update();
    } finally {
      if (!_isDisposing) isLoading.value = false;
      if (!isClosed) update();
    }
  }

  // Method to refresh data
  Future<void> refreshData() async {
    if (testId.isNotEmpty) {
      await fetchResult();
    }
  }
}
