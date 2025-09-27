import 'package:mains/app_imports.dart';
import 'package:mains/models/objective_previous_attempt.dart';

class ResultAttemptController extends GetxController {
  final AttemptHistory attempt;
  final String testId;

  ResultAttemptController(this.attempt, this.testId);

  double get totalMarksEarned =>
      (attempt.totalMarksEarned as num?)?.toDouble() ?? 0.0;

  String get score => finalMarksWithNegative.toStringAsFixed(2);
  int get correct => attempt.correctAnswers;
  int get incorrect => (attempt.totalQuestions - unattempted) - correct;
  int get unattempted => attempt.answers.values.where((v) => v == null).length;

  double get totalPossibleMarks {
    if (questions.isEmpty) {
      return attempt.totalQuestions.toDouble();
    }
    return questions.fold<double>(0.0, (sum, q) {
      final pm = (q['positiveMarks'] as num?)?.toDouble() ?? 1.0;
      return sum + pm;
    });
  }

  double get totalNegativeMarks {
    if (questions.isEmpty) return 0.0;
    double total = 0.0;
    for (final q in questions) {
      final qid = q['id'];
      final userAns = attempt.answers[qid];
      final correctAns = q['correctAnswer'];
      if (userAns != null && userAns != correctAns) {
        total += (q['negativeMarks'] as num?)?.toDouble() ?? 0.0;
      }
    }
    return total;
  }

  double get finalMarksWithNegative {
    if (questions.isEmpty) {
      return totalMarksEarned;
    }
    double total = 0.0;
    for (final q in questions) {
      final qid = q['id'];
      final userAns = attempt.answers[qid];
      final correctAns = q['correctAnswer'];
      final pos = (q['positiveMarks'] as num?)?.toDouble() ?? 1.0;
      final neg = (q['negativeMarks'] as num?)?.toDouble() ?? 0.0;
      if (userAns == null) continue;
      if (userAns == correctAns) {
        total += pos;
      } else {
        total -= neg;
      }
    }
    return total;
  }

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

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken');
      final String url = '${ApiUrls.objectiveTestQnsBase}$testId';
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          final data = jsonDecode(response.body);
          if (data['success'] == true && data['questions'] != null) {
            final questionsData = data['questions'] as List;
            questions =
                questionsData.map((q) {
                  return {
                    'id': q['_id'],
                    'question': q['question'],
                    'options': q['options'],
                    'correctAnswer': q['correctAnswer'],
                    'difficulty': q['difficulty'],
                    'positiveMarks': q['positiveMarks'],
                    'negativeMarks': q['negativeMarks'],
                  };
                }).toList();
          } else {}
        },
        onError: () {},
      );
    } catch (e) {
    } finally {
      isLoadingQuestions.value = false;
    }
  }

  List<Map<String, dynamic>> get visibleSolutions =>
      showAllSolutions.value ? _allSolutions : _allSolutions.take(3).toList();

  List<Map<String, dynamic>> get _allSolutions {
    if (questions.isEmpty) {
      return List.generate(attempt.totalQuestions, (i) {
        return {
          "sn": i + 1,
          "index": i,
          "question": "Question ${i + 1}",
          "result": "-",
        };
      });
    }

    return List.generate(questions.length, (i) {
      final question = questions[i];
      final questionId = question['id'];
      final userAnswer = attempt.answers[questionId];
      final correctAnswer = question['correctAnswer'];

      String result;
      if (userAnswer == null) {
        result = "-";
      } else if (userAnswer == correctAnswer) {
        result = "✓"; // correct
      } else {
        result = "✗"; // wrong
      }

      return {
        "sn": i + 1,
        "index": i,
        "question": question['question'],
        "result": result,
        "userAnswer": userAnswer,
        "correctAnswer": correctAnswer,
        "options": question['options'],
      };
    });
  }

  void toggleSolutions() => showAllSolutions.value = !showAllSolutions.value;

  void goToQuestionDetail(int index) {
    if (index >= questions.length) return;

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
        options: List<String>.from(question['options']),
        explanation: "Detailed explanation here...",
      ),
    );
  }

  int? getCorrectAnswer(String questionId) {
    final q = questions.firstWhereOrNull((q) => q['id'] == questionId);
    if (q != null) return q['correctAnswer'];
    return null;
  }
}
