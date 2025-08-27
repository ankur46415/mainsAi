import 'package:mains/app_imports.dart';

class ResultOfAitest extends StatelessWidget {
  final String? testId;
  const ResultOfAitest({super.key, this.testId});
  void _navigateToHome() {
    NavigationUtils.navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ResultOfAiTestController());
    final bottomNavController = Get.find<BottomNavController>();

    return WillPopScope(
      onWillPop: () async {
        NavigationUtils.navigateToHome();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomAppBar(title: "Result"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildAnimatedScoreCard(),
              _buildStatsSection(),
              _buildMarksSection(),
              _buildSolutionsSection(controller),
              SizedBox(height: Get.width * 0.2),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _navigateToHome,
          icon: Icon(Icons.home, color: Colors.red),
          label: Text(
            "Go Back Test",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildAnimatedScoreCard() {
    return Obx(() {
      final controller = Get.find<ResultOfAiTestController>();

      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            for (int i = 1; i <= 3; i++)
              AnimatedContainer(
                duration: Duration(milliseconds: 700 + i * 300),
                curve: Curves.easeInOutCubic,
                height: 200 - i * 30,
                width: 200 - i * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withOpacity(0.05 * (4 - i)),
                  border: Border.all(
                    color: Colors.redAccent.withOpacity(0.1 * (4 - i)),
                    width: 1.5,
                  ),
                ),
              ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF7E7E), Color(0xFFFFA07A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your Score",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${controller.totalScore}",
                    style: GoogleFonts.poppins(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Out of ${controller.maxScore}",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatsSection() {
    return Obx(() {
      final controller = Get.find<ResultOfAiTestController>();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              "Question Breakdown",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  "Correct",
                  "${controller.correctAnswers}",
                  Colors.green,
                ),
                _buildStatItem(
                  "Incorrect",
                  "${controller.incorrectAnswers}",
                  Colors.red,
                ),
                _buildStatItem(
                  "Unattempted",
                  "${controller.unattemptedAnswers}",
                  Colors.orange,
                ),
                _buildStatItem("Unseen", "0", Colors.grey),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatItem(String title, String value, Color color) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 2),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMarksSection() {
    return Obx(() {
      final controller = Get.find<ResultOfAiTestController>();

      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            _buildMarkRow(
              "Positive marks",
              "${controller.positiveMarks}",
              Icons.add_circle_outline,
              Colors.green,
            ),
            _buildMarkRow(
              "Negative marks",
              "${controller.negativeMarks}",
              Icons.remove_circle_outline,
              Colors.red,
            ),
            const Divider(height: 30, thickness: 1, indent: 20, endIndent: 20),
            _buildMarkRow(
              "Total marks",
              "${controller.totalMarks}",
              Icons.star_border,
              Colors.red,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMarkRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionsSection(ResultOfAiTestController controller) {
    return Obx(() {
      final visibleSolutions = controller.visibleSolutions;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question Solutions",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Review your attempted questions",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ...visibleSolutions.map(
              (item) => _buildSolutionItem(
                item['sn'],
                item['question'],
                item['result'],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: controller.toggleSolutions,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade100, Colors.red.shade200],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.primaryColor,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    controller.showAllSolutions.value
                        ? "SHOW LESS"
                        : "VIEW ALL SOLUTIONS",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: CustomColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildSolutionItem(int sn, String question, String resultSymbol) {
    Color resultColor;
    switch (resultSymbol) {
      case "✓":
        resultColor = Colors.green;
        break;
      case "✗":
        resultColor = Colors.red;
        break;
      default:
        resultColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        // Get the controller to access dynamic data
        final controller = Get.find<ResultOfAiTestController>();
        final testData = controller.testResult.value;

        if (testData != null) {
          // Find the question by index (sn - 1 since sn is 1-based)
          final questionIndex = sn - 1;
          if (questionIndex < testData.questions.length) {
            final questionData = testData.questions[questionIndex];
            // Get user answer from the latest attempt history
            final userAnswer =
                testData.attemptHistory.isNotEmpty
                    ? testData.attemptHistory.last.answers[questionData.id]
                    : null;

            // Get the selected answer text
            String selectedAnswerText = "Not attempted";
            if (userAnswer != null &&
                userAnswer < questionData.options.length) {
              selectedAnswerText = questionData.options[userAnswer];
            }

            // Get the correct answer text
            String correctAnswerText = "Unknown";
            if (questionData.correctAnswer < questionData.options.length) {
              correctAnswerText =
                  questionData.options[questionData.correctAnswer];
            }

            Get.to(
              () => BriefOfQuestion(
                question: questionData.question,
                selectedAnswer: selectedAnswerText,
                correctAnswer: correctAnswerText,
                options: questionData.options,
                explanation:
                    questionData.solution.text.isNotEmpty
                        ? questionData.solution.text
                        : null,
              ),
            );
          }
        }
      },

      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 3),
        child: ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              sn.toString(),
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            question,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Text(
            resultSymbol,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: resultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
