// quiz_controller.dart
import 'package:get/get.dart';

class QrResultController extends GetxController {
  var currentIndex = 0.obs;
  var selectedAnswerIndex = (-1).obs;
  var isAnswered = false.obs;
  var correctAnswersCount = 0.obs;

  final List<Question> questions = [
    Question(
      question: "What is the capital of France?",
      answers: ["Berlin", "Madrid", "Paris", "Rome"],
      correctIndex: 2,
    ),
    Question(
      question: "Which planet is known as the Red Planet?",
      answers: ["Earth", "Mars", "Jupiter", "Saturn"],
      correctIndex: 1,
    ),
    // Add more questions here
  ];

  void selectAnswer(int index) {
    if (!isAnswered.value) {
      selectedAnswerIndex.value = index;
      isAnswered.value = true;

      if (index == questions[currentIndex.value].correctIndex) {
        correctAnswersCount.value++;
      }
    }
  }

  void nextQuestion() {
    if (currentIndex.value < questions.length - 1) {
      currentIndex.value++;
      resetAnswer();
    }
  }

  void prevQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      resetAnswer();
    }
  }

  void resetAnswer() {
    selectedAnswerIndex.value = -1;
    isAnswered.value = false;
  }

  bool isLastQuestion() => currentIndex.value == questions.length - 1;
}

class QrResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(QrResultController());
  }
}

class Question {
  final String question;
  final List<String> answers;
  final int correctIndex;

  Question({
    required this.question,
    required this.answers,
    required this.correctIndex,
  });
}
