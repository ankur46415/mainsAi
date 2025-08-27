import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/common/app_bar.dart';
import 'package:mains/my_kitabai_view/upload_images/Upload_answers.dart';
import 'package:mains/my_kitabai_view/workBook/allBooksOfSets/controller.dart';
import 'package:lottie/lottie.dart';

class AllWorkbookquestions extends StatefulWidget {
  const AllWorkbookquestions({super.key});

  @override
  State<AllWorkbookquestions> createState() => _AllWorkbookquestionsState();
}

class _AllWorkbookquestionsState extends State<AllWorkbookquestions> {
  late SetsOfQuestions controller;
  late String sid;
  String? bookId;
  var expandedMap = <int, RxBool>{};

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    sid = args?['sid'] ?? '';
    bookId = args?['bookId'] ?? '';
    controller = Get.put(SetsOfQuestions());
    controller.initialize(sid: sid, bookId: bookId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'All Questions'),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/lottie/book_loading.json',
                  fit: BoxFit.contain,
                  delegates: LottieDelegates(
                    values: [
                      ValueDelegate.color(const ['**'], value: Colors.red),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            final q = controller.questions[index];
            final metadata = q.metadata;
            final RxBool isExpanded = expandedMap.putIfAbsent(
              index,
              () => false.obs,
            );

            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.95 + (value * 0.05),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: InkWell(
                onTap: () {
                  Get.to(
                    UploadAnswers(
                      questionId: q.sId ?? '',
                      questionsText: q.question ?? '',
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blue.shade50.withOpacity(0.8),
                        Colors.white,
                        Colors.blue.shade50.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'QUESTION',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade600,
                            ),
                          ),
                          Text(
                            'MM: ${metadata?.maximumMarks ?? 0}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '${metadata?.estimatedTime ?? 0} mins',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            metadata?.difficultyLevel ?? '',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showMetaDialog(context, metadata),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'i',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Obx(() {
                        final qText = q.question ?? 'No question text';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight:
                                    isExpanded.value ? double.infinity : 60,
                              ),
                              child: SingleChildScrollView(
                                child: Text(
                                  qText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => isExpanded.toggle(),
                              child: Text(
                                isExpanded.value ? 'See less' : 'See more',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showMetaDialog(BuildContext context, metadata) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(
              "Question Details",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Difficulty: ${metadata?.difficultyLevel ?? 'N/A'}',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Word Limit: ${metadata?.wordLimit ?? 'N/A'}',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Time: ${metadata?.estimatedTime ?? 'N/A'} min',
                  style: GoogleFonts.poppins(),
                ),
                Text(
                  'Marks: ${metadata?.maximumMarks ?? 'N/A'}',
                  style: GoogleFonts.poppins(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Close',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
