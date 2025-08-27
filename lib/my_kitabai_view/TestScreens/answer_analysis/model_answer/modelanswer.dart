import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main_analysis/main_analytics_controller.dart';

class ModelAnswerPage extends StatefulWidget {
  const ModelAnswerPage({super.key});

  @override
  State<ModelAnswerPage> createState() => _ModelAnswerPageState();
}

class _ModelAnswerPageState extends State<ModelAnswerPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainAnalyticsController>();
    final modalAnswer =
        controller.answerAnalysis.value?.data?.answer?.question?.modalAnswer ??
        'No model answer available';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.article, color: Colors.blue[800]),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Model Answer',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      children: _buildFormattedText(modalAnswer),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Tips Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green[50]!, Colors.teal[50]!],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lightbulb, color: Colors.green[800]),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        'Pro Tip',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Compare your answer with the model answer to identify areas for improvement. Pay attention to the structure, key points, and supporting arguments.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.green[800],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildFormattedText(String text) {
    final List<TextSpan> spans = [];
    final lines = text.split('\n');

    for (var line in lines) {
      if (line.trim().startsWith('**') && line.trim().endsWith('**')) {
        // Bold heading text

        spans.add(
          TextSpan(
            text: line.trim().substring(2, line.trim().length - 2) + '\n',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        );
      } else if (line.trim().startsWith('- ')) {
        // Bullet point
        spans.add(
          const TextSpan(
            text: '   • ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
        spans.add(TextSpan(text: line.trim().substring(2) + '\n'));
      } else {
        // Normal text
        spans.add(TextSpan(text: line.trim() + '\n'));
      }
    }

    return spans;
  }
}
