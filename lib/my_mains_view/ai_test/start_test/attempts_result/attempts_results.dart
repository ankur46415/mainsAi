import 'package:mains/app_imports.dart';
import 'package:mains/models/objective_previous_attempt.dart';
import 'package:mains/my_mains_view/ai_test/start_test/attempts_result/controller.dart';

class ResultOfAttemptTest extends StatefulWidget {
  final AttemptHistory attempt;
  final String testId;
  final String maxMarks;

  const ResultOfAttemptTest({
    super.key,
    required this.attempt,
    required this.testId,
    required this.maxMarks,
  });

  @override
  State<ResultOfAttemptTest> createState() => _ResultOfAttemptTestState();
}

class _ResultOfAttemptTestState extends State<ResultOfAttemptTest> {
  @override
  Widget build(BuildContext context) {
    // Read max marks from navigation arguments
    final args = Get.arguments;

    final controller = Get.put(
      ResultAttemptController(widget.attempt, widget.testId),
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(title: "Attempt ${widget.attempt.attemptNumber}"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildScoreCard(controller),
            _buildStatsSection(controller),
            _buildMarksSection(controller),
            _buildSolutionsSection(controller),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Simple navigation back
          Get.back();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.red),
        label: Text(
          "Go Back",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildScoreCard(ResultAttemptController controller) {
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
                Text("Score", style: _labelStyle),
                const SizedBox(height: 6),
                Text("${controller.score}", style: _scoreStyle),
                const SizedBox(height: 6),
                Text("Out of ${widget.maxMarks}", style: _subLabelStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(ResultAttemptController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          Text("Breakdown", style: _sectionTitle),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Correct", "${controller.correct}", Colors.green),
              _buildStatItem("Wrong", "${controller.incorrect}", Colors.red),
              _buildStatItem(
                "Unattempted",
                "${controller.unattempted}",
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.poppins(fontSize: 11, color: color)),
      ],
    );
  }

  Widget _buildMarksSection(ResultAttemptController controller) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          _buildMarkRow("Time Taken", controller.timeTaken, Icons.timer),
          _buildMarkRow(
            "Submitted On",
            controller.submittedAt,
            Icons.calendar_today,
          ),
          //const Divider(height: 24),
          // // New rows for marking with negatives
          // _buildMarkRow(
          //   "Total Negative Marks",
          //   controller.totalNegativeMarks.toStringAsFixed(2),
          //   Icons.remove_circle_outline,
          // ),
          // _buildMarkRow(
          //   "Final Marks (with negatives)",
          //   controller.finalMarksWithNegative.toStringAsFixed(2),
          //   Icons.score,
          // ),
          // _buildMarkRow(
          //   "Total Possible (with negatives)",
          //   controller.totalPossibleMarks.toStringAsFixed(2),
          //   Icons.star_border,
          // ),
        ],
      ),
    );
  }

  Widget _buildMarkRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: _rowTitleStyle)),
          Text(value, style: _rowValueStyle),
        ],
      ),
    );
  }

  Widget _buildSolutionsSection(ResultAttemptController controller) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Solutions",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(
                () =>
                    controller.isLoadingQuestions.value
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoadingQuestions.value) {
              return Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Loading questions...",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                ...controller.visibleSolutions.map(
                  (solution) => _buildSolutionTile(solution, controller),
                ),
                if (controller.visibleSolutions.length <
                    controller.questions.length)
                  TextButton(
                    onPressed: controller.toggleSolutions,
                    child: Text(
                      controller.showAllSolutions.value
                          ? "Show Less"
                          : "Show More",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSolutionTile(
    Map<String, dynamic> q,
    ResultAttemptController controller,
  ) {
    // Use "-" if result is null (unattempted)
    final resultValue = q["result"] ?? "-";

    // Determine color based on result
    final color =
        resultValue == "✓"
            ? Colors.green
            : resultValue == "✗"
            ? Colors.red
            : Colors.orange; 

    // Determine display text: show numeric if result is a number, else the symbol or "-"
    final resultText =
        num.tryParse(resultValue.toString()) != null
            ? resultValue.toString()
            : resultValue;

    return ListTile(
      onTap: () => controller.goToQuestionDetail(q["index"]),
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
         backgroundColor: color, 
        child: Text("${q['sn'] ?? '-'}", style: _solutionNumber),
      ),
      title: Text(
        q["question"] ?? "",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _solutionTitle,
      ),
      trailing: Text(
        resultText,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // === Styles & Decorations ===
  TextStyle get _labelStyle =>
      GoogleFonts.poppins(color: Colors.white70, fontSize: 14);

  TextStyle get _scoreStyle => GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  TextStyle get _subLabelStyle =>
      GoogleFonts.poppins(color: Colors.white60, fontSize: 12);

  TextStyle get _sectionTitle =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  TextStyle get _rowTitleStyle =>
      GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500);

  TextStyle get _rowValueStyle =>
      GoogleFonts.poppins(fontWeight: FontWeight.bold);

  TextStyle get _solutionNumber =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold);

  TextStyle get _solutionTitle =>
      GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600);

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
  );
}
