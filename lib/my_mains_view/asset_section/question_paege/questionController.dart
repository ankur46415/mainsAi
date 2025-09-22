import 'package:mains/app_imports.dart';
import 'package:mains/models/asset_list.dart';

class QuestionController extends GetxController {
  final List<Questions> questions;
  final RxMap<int, int> selectedAnswers = <int, int>{}.obs;
  final PageController pageController = PageController();

  QuestionController(this.questions);

  int get correctCount {
    int correct = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i].correctedAnswerForOptions) {
        correct++;
      }
    }
    return correct;
  }

  void selectAnswer(int index, int optionIndex) {
    if (!selectedAnswers.containsKey(index)) {
      selectedAnswers[index] = optionIndex;
    }
  }
}
 