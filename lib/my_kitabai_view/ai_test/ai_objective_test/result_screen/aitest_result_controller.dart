// ✅ CONTROLLER FILE
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mains/common/shred_pref.dart';
import 'package:mains/model/objective_result.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ResultOfAiTestController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;
  final showAllSolutions = false.obs;
  final isLoading = true.obs;
  final testId = ''.obs;

  Rx<ObjectiveTestResultCurrent?> testResult = Rx<ObjectiveTestResultCurrent?>(null);

  List<Map<String, dynamic>> get visibleSolutions =>
      showAllSolutions.value ? _formattedSolutions : _formattedSolutions.take(3).toList();

  final _formattedSolutions = <Map<String, dynamic>>[].obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    _initializeData();
  }

  void _initializeData() {
    try {
      final arguments = Get.arguments;
      if (arguments != null && arguments is Map<String, dynamic>) {
        testId.value = arguments['testId'] ?? '';
      }
      if (testId.value.isNotEmpty) {
        fetchResult(testId.value);
      }
    } catch (e) {
      print('Error initializing result data: $e');
    }
  }

  Future<void> fetchResult(String testId) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString(Constants.authToken);

      final url =
          'https://aipbbackend-c5ed.onrender.com/api/objectivetests/$testId/results';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final resultData = data['data'];
        final parsed = ObjectiveTestResultCurrent.fromJson(resultData);

        testResult.value = parsed;

        _formattedSolutions.clear();
        for (int i = 0; i < parsed.questions.length; i++) {
          final question = parsed.questions[i];
          final result = parsed.attemptHistory.last.answers[question.id];
          String symbol = '–';
          if (result != null) {
            if (result == question.correctAnswer) {
              symbol = '✓';
            } else {
              symbol = '✗';
            }
          }
          _formattedSolutions.add({
            'sn': i + 1,
            'question': question.question,
            'result': symbol,
          });
        }
      } else {
        print('Failed to fetch result data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching result: $e");
    } finally {
      isLoading.value = false;
    }
  }

  int get totalScore => testResult.value?.attemptStats.latestScore ?? 0;
  int get maxScore => testResult.value?.questions.length ?? 100;
  int get correctAnswers => testResult.value?.attemptHistory.last.correctAnswers ?? 0;
  int get incorrectAnswers =>
      (testResult.value?.attemptHistory.last.totalQuestions ?? 0) -
      (testResult.value?.attemptHistory.last.correctAnswers ?? 0);
  int get unattemptedAnswers =>
      (testResult.value?.questions.length ?? 0) -
      (testResult.value?.attemptHistory.last.answers.length ?? 0);
  int get positiveMarks => correctAnswers * 2;
  int get negativeMarks => incorrectAnswers * 1;
  int get totalMarks => totalScore;

  void toggleSolutions() {
    showAllSolutions.toggle();
  }
}
