import 'package:mains/app_imports.dart';
import 'package:mains/model/objective_previous_attempt.dart';
import 'package:mains/common/api_services.dart';
import 'package:http/http.dart' as http;

class ResultAttemptController extends GetxController {
  final AttemptHistory attempt;
  final String testId;

  ResultAttemptController(this.attempt, this.testId);

  String get score => attempt.score.toString();
  int get correct => attempt.correctAnswers;
  int get incorrect => (attempt.totalQuestions - unattempted) - correct;
  int get unattempted => attempt.answers.values.where((v) => v == null).length;

  String get timeTaken => attempt.completionTime;
  String get submittedAt {
    final dt = DateTime.parse(attempt.submittedAt);
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  RxBool showAllSolutions = false.obs;
  RxBool isLoadingQuestions = true.obs;
  List<Map<String, dynamic>> questions = [];

  @override
  void onInit() {
    super.onInit();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      isLoadingQuestions.value = true;

      // ✅ Get auth token
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');

      final url = Uri.parse('${ApiUrls.objectiveTestQnsBase}$testId');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${authToken ?? ''}',
        },
      );

      print('📥 Raw response status: ${response.statusCode}');
      print('📥 Raw response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['questions'] != null) {
          final questionsData = data['questions'] as List;

          questions =
              questionsData
                  .map(
                    (q) => {
                      'id': q['_id'],
                      'question': q['question'],
                      'options': q['options'],
                      'correctAnswer': q['correctAnswer'],
                      'difficulty': q['difficulty'],
                    },
                  )
                  .toList();

          print('✅ Fetched ${questions.length} real questions');
          print('✅ First question: ${questions.first['question']}');
        } else {
          print('❌ API response missing questions or success false');
        }
      } else {
        print('❌ Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception while fetching questions: $e');
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  List<Map<String, dynamic>> get visibleSolutions =>
      showAllSolutions.value ? _allSolutions : _allSolutions.take(3).toList();

  List<Map<String, dynamic>> get _allSolutions {
    if (questions.isEmpty) {
      // Fallback to numbered questions if real questions not loaded
      return List.generate(attempt.totalQuestions, (i) {
        return {
          "sn": i + 1,
          "index": i,
          "question": "Question ${i + 1}",
          "result": i < attempt.correctAnswers ? "✓" : "✗",
        };
      });
    }

    // Use real questions
    return List.generate(questions.length, (i) {
      final question = questions[i];
      final questionId = question['id'];
      final userAnswer = attempt.answers[questionId];
      final correctAnswer = question['correctAnswer'];
      final isCorrect = userAnswer == correctAnswer;

      return {
        "sn": i + 1,
        "index": i,
        "question": question['question'],
        "result": isCorrect ? "✓" : "✗",
        "userAnswer": userAnswer,
        "correctAnswer": correctAnswer,
        "options": question['options'],
      };
    });
  }

  void toggleSolutions() {
    showAllSolutions.value = !showAllSolutions.value;
  }

  void goToQuestionDetail(int index) {
    if (index < questions.length) {
      final question = questions[index];
      final questionId = question['id'];
      final userAnswer = attempt.answers[questionId];
      final correctAnswer = question['correctAnswer'];

      Get.to(
        () => BriefOfQuestion(
          question: question['question'],
          selectedAnswer:
              userAnswer != null
                  ? question['options'][userAnswer]
                  : "Not attempted",
          correctAnswer: question['options'][correctAnswer],
          options: List<String>.from(question['options']), // 👈 Fix here
          explanation: "Detailed explanation here...",
        ),
      );
    }
  }
}
