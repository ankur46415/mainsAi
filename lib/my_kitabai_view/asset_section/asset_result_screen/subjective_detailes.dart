import 'package:mains/model/asset_list.dart';
import '../../../app_imports.dart';

class SubjectiveSetDetailPage extends StatelessWidget {
  final String setName;
  final List<dynamic> questions;

  const SubjectiveSetDetailPage({
    super.key,
    required this.setName,
    required this.questions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Subjective"),

      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final q = questions[index];
            String questionText;
            String answerText;
            String keywords;
            if (q is Map &&
                q.containsKey('answer') &&
                !q.containsKey('answer') &&
                q.containsKey('keywords')) {
              // Subjective question
              questionText = q['question']?.toString() ?? " ";
              answerText = q['answer']?.toString() ?? " ";
              keywords = q['keywords']?.toString() ?? " ";
            } else if (q is Map && q.containsKey('answer')) {
              // Objective question
              questionText = q['question']?.toString() ?? " ";
              final answer = q['answer'];
              final correctAnswerStr = q['answer']?.toString();
              final correctIndex = int.tryParse(correctAnswerStr ?? '');
              if (q is Map) {
                answerText = q['answer']?.toString() ?? " ";
              } else {
                answerText = " ";
              }
              answerText = q['answer']?.toString() ?? " ";
            } else if (q is Questions) {
              // Object model
              questionText = q.question ?? " ";

              int? correctIndex = int.tryParse(
                q.correctAnswer?.toString() ?? '',
              );
              answerText =
                  q.correctAnswer != null && correctIndex != null
                      ? 'answer: ${q.correctAnswer.toString}\nCorrect: ${(correctIndex >= 0 && correctIndex < q.correctAnswer!.length) ? q.correctAnswer![correctIndex] : 'N/A'}'
                      : " ";
            } else {
              questionText = " ";
              answerText = " ";
            }

            return QuestionFoldingCard(
              question: questionText,
              answer: answerText,
              index: index,
              keywords: q['keywords']?.toString() ?? 'No keywords',
            );
          },
        ),
      ),
    );
  }
}
