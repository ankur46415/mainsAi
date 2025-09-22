import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/models/GetAnswerAnalysis.dart';
import 'package:mains/my_mains_view/TestScreens/answer_analysis/analysis/analysis_controller.dart';
import 'package:mains/my_mains_view/TestScreens/answer_analysis/main_analysis/main_analytics_controller.dart';

class ExpertReviews extends StatefulWidget {
  final ExpertReview expertReview;
  final String? reviewStatus;
  const ExpertReviews({
    super.key,
    required this.expertReview,
    this.reviewStatus,
  });

  @override
  State<ExpertReviews> createState() => _ExpertReviewsState();
}

class _ExpertReviewsState extends State<ExpertReviews> {
  void _showReviewBottomSheet() {
    String? selectedOption;
    final TextEditingController otherController = TextEditingController();
    final controller = Get.find<AnalysisController>();
    final mainController = Get.find<MainAnalyticsController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setState) => Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 24,
                        spreadRadius: 0,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 48,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        'Help Us Improve',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Colors.grey[900],
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select the reason for your review',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildReviewOption(
                                'Not satisfied',
                                selectedOption,
                                Icons.sentiment_dissatisfied_rounded,
                                Colors.orange,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),

                              _buildReviewOption(
                                'Need better analysis',
                                selectedOption,
                                Icons.analytics_rounded,
                                Colors.indigo,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildReviewOption(
                                'Incomplete Review',
                                selectedOption,
                                Icons.hourglass_bottom_rounded,
                                Colors.amber,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildReviewOption(
                                'Irrelevant answer',
                                selectedOption,
                                Icons.not_interested_rounded,
                                Colors.grey,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                side: BorderSide(
                                  color: Colors.grey[300]!,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                if (selectedOption == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select an option'),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.red[400],
                                    ),
                                  );
                                  return;
                                }

                                if (selectedOption == 'Others' &&
                                    otherController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please specify your reason',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.red[400],
                                    ),
                                  );
                                  return;
                                }

                                final answerId =
                                    mainController
                                        .answerAnalysis
                                        .value
                                        ?.data
                                        ?.answer
                                        ?.sId;
                                if (answerId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Unable to submit review. Please try again.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.red[400],
                                    ),
                                  );
                                  return;
                                }
                                controller.setAnswerId(answerId);
                                final success = await controller.postReviewData(
                                  selectedOption: selectedOption.toString(),
                                  otherText:
                                      selectedOption == 'Others'
                                          ? otherController.text
                                          : null,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                shadowColor: Colors.transparent,
                              ),
                              child: Text(
                                'Submit Review',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.width * 0.1),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildReviewOption(
    String title,
    String? selectedOption,
    IconData icon,
    Color color,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onChanged(title),
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  selectedOption == title
                      ? color.withOpacity(0.08)
                      : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    selectedOption == title
                        ? color.withOpacity(0.5)
                        : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color:
                        selectedOption == title
                            ? color.withOpacity(0.2)
                            : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color:
                        selectedOption == title
                            ? color
                            : color.withOpacity(0.8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight:
                          selectedOption == title
                              ? FontWeight.w600
                              : FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          selectedOption == title ? color : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: selectedOption == title ? color : Colors.transparent,
                  ),
                  child:
                      selectedOption == title
                          ? Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Remark() {
    return Card(
      elevation: 7,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.expertReview.remarks.toString(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget comment() {
    return Card(
      elevation: 7,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.expertReview.result.toString(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Color _getProgressColor(double value) {
    if (value >= 0.9) return Colors.green;
    if (value >= 0.75) return Colors.green;
    if (value >= 0.5) return Colors.green;
    if (value >= 0.25) return Colors.red;
    return Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final review = widget.expertReview;
    final isReviewCompleted = widget.reviewStatus == 'review_completed';

    // Get maximumMarks from MainAnalyticsController
    final mainController = Get.find<MainAnalyticsController>();
    final maximumMarks =
        mainController
            .answerAnalysis
            .value
            ?.data
            ?.answer
            ?.question
            ?.metadata
            ?.maximumMarks ??
        0;
    final score = review.score ?? 0;
    final progressValue = (maximumMarks > 0) ? (score / maximumMarks) : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              isReviewCompleted
                  ? ListView(
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Review Score',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: CircularProgressIndicator(
                                      value: progressValue,
                                      strokeWidth: 12,
                                      backgroundColor: Colors.grey[200],
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        _getProgressColor(progressValue),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$score / $maximumMarks',
                                        style: GoogleFonts.poppins(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w800,
                                          color: _getProgressColor(
                                            progressValue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildMetricItem(
                                    Icons.trending_up,
                                    'N/A',
                                    'Your Rank',
                                    Colors.green,
                                  ),
                                  _buildMetricItem(
                                    Icons.assessment,
                                    'N/A',
                                    'Average Score',
                                    Colors.orange,
                                  ),
                                  _buildMetricItem(
                                    Icons.star,
                                    'N/A',
                                    'Top Score',
                                    Colors.redAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Get.width * 0.06),
                      Text(
                        'Remark',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,

                          fontSize: 15,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: Get.width * 0.02),
                      Remark(),
                      SizedBox(height: Get.width * 0.02),
                      Text(
                        'Comment',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,

                          fontSize: 15,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: Get.width * 0.02),

                      comment(),
                      SizedBox(height: Get.width * 0.06),

                      SizedBox(height: Get.width * 0.04),
                    ],
                  )
                  : Center(
                    child: Text(
                      'Result will be published soon.',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
