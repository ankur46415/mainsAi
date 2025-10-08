import 'package:mains/app_imports.dart';
import 'package:mains/my_mains_view/ai_test/ai_test_subjective/subjective_test_name/summery_test_result.dart';

class TestAnalyticsCard extends StatefulWidget {
  final String? testId;
  const TestAnalyticsCard({super.key, this.testId});

  @override
  State<TestAnalyticsCard> createState() => _TestAnalyticsCardState();
}

class _TestAnalyticsCardState extends State<TestAnalyticsCard> {
  late SummeryTestResult controller;

  @override
  void initState() {
    controller = Get.put(SummeryTestResult(widget.testId ?? ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error.isNotEmpty) {
        return Center(child: Text(controller.error.value));
      }

      final summary = controller.summaryData.value;
      final submission = summary?.testSubmissionSummary;

      final totalQuestions = submission?.totalQuestions ?? 0;

      final attemptedQuestions = submission?.attemptedQuestions ?? 0;
      final notAttempted = submission?.notAttemptedQuestions ?? 0;

      if (submission?.attemptedQuestionsDetails != null) {
        for (var q in submission!.attemptedQuestionsDetails!) {}
      }

      return Card(
        color: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test Analytics',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Get.width * 0.05),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBoxItem(
                    title: 'Attempted\nQuestions',
                    value: '$attemptedQuestions',
                    color: const Color.fromARGB(
                      255,
                      176,
                      216,
                      178,
                    ), // lighter green
                  ),
                  _buildBoxItem(
                    title: 'Unattempted\nQuestions',
                    value: '$notAttempted',
                    color: const Color.fromARGB(255, 241, 177, 177),
                  ),
                  _buildBoxItem(
                    title: 'Total\nQuestions',
                    value: '$totalQuestions',
                    color: const Color.fromARGB(255, 160, 208, 248),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildBoxItem(
                    title: 'Max\nMarks',
                    value: '${summary?.testMaximumMarks ?? 0}',
                    color: const Color.fromARGB(
                      255,
                      221,
                      233,
                      193,
                    ), // lighter purple
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBoxItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color, // lighter box color
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black, // contrast
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.black,
                height: 1.2,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
