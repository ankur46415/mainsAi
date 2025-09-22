import 'package:mains/app_imports.dart';
import 'package:mains/models/asset_list.dart';

class QuestionViewPage extends StatelessWidget {
  final List<Questions> questions;
  final String title;

  const QuestionViewPage({
    super.key,
    required this.questions,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QuestionController(questions));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length + 1,
              itemBuilder: (context, index) {
                if (index == questions.length) {
                  final correct = controller.correctCount;
                  final total = questions.length;

                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.emoji_events_rounded,
                                size: 80,
                                color: Colors.orangeAccent,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "Quiz Completed!",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                "You scored",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "$correct / $total",
                                style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: () => Get.back(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Back to Set",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final q = questions[index];

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.black.withOpacity(0.15),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Question ${index + 1}",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.blueGrey.shade200,
                                  ),
                                ),
                                child: Text(
                                  "Difficulty: ${q.difficulty ?? "N/A"}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            q.question ?? "No Question",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // ✅ Only Obx() around options!
                          Obx(() {
                            final selected = controller.selectedAnswers[index];
                            return Column(
                              children:
                                  q.options!.asMap().entries.map((entry) {
                                    final optionIndex = entry.key;
                                    final optionText = entry.value;
                                    final isCorrect =
                                        optionIndex ==
                                        q.correctedAnswerForOptions;
                                    final isSelected = selected == optionIndex;

                                    Color tileColor = Colors.grey.shade100;
                                    IconData? icon;
                                    Color iconColor = Colors.transparent;

                                    if (selected != null) {
                                      if (isSelected && isCorrect) {
                                        tileColor = Colors.green.shade100;
                                        icon = Icons.check_circle;
                                        iconColor = Colors.green;
                                      } else if (isSelected && !isCorrect) {
                                        tileColor = Colors.red.shade100;
                                        icon = Icons.cancel;
                                        iconColor = Colors.red;
                                      } else if (!isSelected && isCorrect) {
                                        tileColor = Colors.green.shade100;
                                        icon = Icons.check_circle;
                                        iconColor = Colors.green;
                                      } else {
                                        tileColor = Colors.grey.shade200;
                                      }
                                    }

                                    return GestureDetector(
                                      onTap:
                                          selected == null
                                              ? () => controller.selectAnswer(
                                                index,
                                                optionIndex,
                                              )
                                              : null,
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 14,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: tileColor,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? Colors.redAccent
                                                    : Colors.grey.shade300,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${String.fromCharCode(65 + optionIndex)}. ",
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Expanded(
                                              child: Text(
                                                optionText,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            if (icon != null)
                                              Icon(
                                                icon,
                                                color: iconColor,
                                                size: 20,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            );
                          }),

                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      index == 0
                                          ? null
                                          : () => controller.pageController
                                              .previousPage(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.easeInOut,
                                              ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.arrow_back_ios,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Previous",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Obx(() {
                                  final selected =
                                      controller.selectedAnswers[index];
                                  return ElevatedButton(
                                    onPressed:
                                        (selected == null &&
                                                index != questions.length)
                                            ? null
                                            : () => controller.pageController
                                                .nextPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          index == questions.length - 1
                                              ? "Finish"
                                              : "Next",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
