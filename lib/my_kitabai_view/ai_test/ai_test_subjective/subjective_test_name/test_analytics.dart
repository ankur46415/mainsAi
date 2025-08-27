import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/subjective_test_name/summery_test_result.dart';

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
      final unattemptedPercent =
          totalQuestions == 0
              ? 0
              : ((notAttempted / totalQuestions) * 100).round();

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
                  _buildTopItem(
                    'Attempted \nQuestion',
                    '$attemptedQuestions',
                    highlight: true,
                  ),
                  _buildTopItem(
                    'Unattempted \nQuestion(%)',
                    '$unattemptedPercent%',
                  ),
                  _buildTopItem('Total \nQuestion', '$totalQuestions'),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBottomItem(
                    'Score',
                    submission?.attemptedQuestionsDetails
                            ?.fold<int>(
                              0,
                              (sum, q) => sum + (q.evaluation?.score ?? 0),
                            )
                            .toString() ??
                        '0',
                    submission?.attemptedQuestionsDetails?.length.toString() ??
                        '0',
                  ),
                  _buildBottomItem(
                    'Max Marks',
                    submission?.attemptedQuestionsDetails
                            ?.fold<int>(
                              0,
                              (sum, q) => sum + (q.maximumMarks ?? 0),
                            )
                            .toString() ??
                        '0',
                    submission?.attemptedQuestionsDetails?.length.toString() ??
                        '0',
                  ),
                  _buildBottomItem(
                    'Relevancy',
                    submission?.attemptedQuestionsDetails
                            ?.fold<int>(
                              0,
                              (sum, q) => sum + (q.evaluation?.relevancy ?? 0),
                            )
                            .toString() ??
                        '0',
                    submission?.attemptedQuestionsDetails?.length.toString() ??
                        '0',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildTopItem(String title, String value, {bool highlight = false}) {
    return Column(
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: highlight ? Colors.teal : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomItem(String label, String correct, String total) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '$correct',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: '/$total',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
