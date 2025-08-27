import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:mains/model/objective_previous_attempt.dart';

class ObjectiveRestNameController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;

  late String testId;

  final resultData = Rxn<ObjectiveTestResult>();
  final isLoading = true.obs;
  final hasError = false.obs;

  @override
  void onInit() async {
    try {
      prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString(Constants.authToken);
      super.onInit();

      // Get arguments and handle both Map and AiTestItem cases
      final arguments = Get.arguments;
      print(
        '🔍 ObjectiveRestNameController: Received arguments type: ${arguments.runtimeType}',
      );
      print('🔍 ObjectiveRestNameController: Arguments: $arguments');

      if (arguments is Map<String, dynamic>) {
        testId = arguments['testId'] ?? '';
        print(
          '📥 ObjectiveRestNameController: Extracted testId from Map: $testId',
        );
      } else if (arguments is AiTestItem) {
        testId = arguments.testId;
        print(
          '📥 ObjectiveRestNameController: Extracted testId from AiTestItem: $testId',
        );
      } else {
        testId = '';
        print('⚠️ Warning: Unexpected arguments type: ${arguments.runtimeType}');
      }

      print('📥 ObjectiveRestNameController: Final Test ID: $testId');
      
      if (testId.isNotEmpty) {
        // Add a small delay to ensure proper initialization
        await Future.delayed(const Duration(milliseconds: 200));
        fetchResult();
      } else {
        print('❌ Test ID is empty, cannot fetch results');
        hasError.value = true;
        isLoading.value = false;
      }
    } catch (e) {
      print('❌ Error in onInit: $e');
      hasError.value = true;
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    print('🔄 ObjectiveRestNameController: onClose called');
    super.onClose();
  }

  @override
  void onReady() {
    print('🔄 ObjectiveRestNameController: onReady called');
    super.onReady();
  }

  Future<void> fetchResult() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      update(); // Trigger rebuild

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString(Constants.authToken);
      
      if (authToken == null) {
        print('❌ No auth token available');
        hasError.value = true;
        isLoading.value = false;
        update(); // Trigger rebuild
        return;
      }

      final url = Uri.parse(
        'https://aipbbackend-c5ed.onrender.com/api/objectivetest/clients/CLI147189HIGB/$testId/results',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      print('📡 Request sent to: $url');
      print('🔐 Auth Token: $authToken');

      print('📥 Raw Response Body:\n${response.body}'); // FULL RAW RESPONSE

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);

        print('✅ Decoded JSON:\n$jsonMap'); // FULL DECODED JSON MAP

        if (jsonMap['success'] == true) {
          try {
            print('🔄 Attempting to parse ObjectiveTestResult...');
            print('🔄 Data structure: ${jsonMap['data']}');
            print('🔄 TestInfo: ${jsonMap['data']['testInfo']}');
            print('🔄 AttemptStats: ${jsonMap['data']['attemptStats']}');
            print('🔄 AttemptHistory count: ${(jsonMap['data']['attemptHistory'] as List).length}');
            
            resultData.value = ObjectiveTestResult.fromJson(jsonMap['data']);
            print('✅ Successfully parsed ObjectiveTestResult');
            update(); // Trigger rebuild
          } catch (e, stackTrace) {
            print('❌ Error parsing ObjectiveTestResult: $e');
            print('❌ Stack trace: $stackTrace');
            print('❌ Data structure: ${jsonMap['data']}');
            hasError.value = true;
            update(); // Trigger rebuild
          }
        } else {
          print('⚠️ API success=false: $jsonMap');
          hasError.value = true;
          update(); // Trigger rebuild
        }
      } else {
        print('❌ API failed: ${response.statusCode} - ${response.body}');
        hasError.value = true;
        update(); // Trigger rebuild
      }
    } catch (e) {
      print('❌ Error fetching result: $e');
      hasError.value = true;
      update(); // Trigger rebuild
    } finally {
      isLoading.value = false;
      update(); // Trigger rebuild
    }
  }

  // Method to refresh data
  Future<void> refreshData() async {
    if (testId.isNotEmpty) {
      await fetchResult();
    }
  }
}
