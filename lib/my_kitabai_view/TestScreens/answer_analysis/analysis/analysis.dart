import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'analysis_controller.dart';
import '../main_analysis/main_analytics_controller.dart';

class Analysis extends StatefulWidget {
  final bool isExpertReview;

  const Analysis({super.key, this.isExpertReview = false});

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  late AnalysisController controller;
  String _selectedLanguage = 'english';

  final Map<String, Color> ratingColors = {
    "Excellent": Colors.green,
    "Good": Colors.lightGreen,
    "Average": Colors.orange,
    "Needs Improvement": Colors.red,
  };

  Map<String, Map<String, dynamic>> getEvaluationData() {
    final controller = Get.find<MainAnalyticsController>();
    final answer = controller.answerAnalysis.value?.data?.answer;
    final bool isHindi = _selectedLanguage == 'hindi';
    final Map<String, Map<String, dynamic>> evalData = {};

    if (!isHindi) {
      final evaluation = answer?.evaluation;
      final analysis = evaluation?.analysis;
      if (analysis != null) {
        if (analysis.introduction?.isNotEmpty ?? false) {
          evalData['introduction'] = {
            'rating': 'Excellent',
            'marks': 'Introduction',
            'comment': analysis.introduction!.join('\n'),
          };
        }
        if (analysis.body?.isNotEmpty ?? false) {
          evalData['body'] = {
            'rating': 'Excellent',
            'marks': 'Body',
            'comment': analysis.body!.join('\n'),
          };
        }
        if (analysis.conclusion?.isNotEmpty ?? false) {
          evalData['conclusion'] = {
            'rating': 'Excellent',
            'marks': 'Conclusion',
            'comment': analysis.conclusion!.join('\n'),
          };
        }
        if (analysis.strengths?.isNotEmpty ?? false) {
          evalData['Strengths'] = {
            'rating': 'Excellent',
            'marks': 'Strengths',
            'comment': analysis.strengths!.join('\n'),
          };
        }
        if (analysis.weaknesses?.isNotEmpty ?? false) {
          evalData['Areas for Improvement'] = {
            'rating': 'Needs Improvement',
            'marks': 'Weaknesses',
            'comment': analysis.weaknesses!.join('\n'),
          };
        }
        if (analysis.suggestions?.isNotEmpty ?? false) {
          evalData['Suggestions'] = {
            'rating': 'Good',
            'marks': 'Suggestions',
            'comment': analysis.suggestions!.join('\n'),
          };
        }
      }
    } else {
      final hindiEvaluation = answer?.hindiEvaluation;
      final analysis = hindiEvaluation?.analysis;
      if (analysis != null) {
        if (analysis.introduction?.isNotEmpty ?? false) {
          evalData['introduction'] = {
            'rating': 'Excellent',
            'marks': 'प्रस्तावना',
            'comment': analysis.introduction!.join('\n'),
          };
        }
        if (analysis.body?.isNotEmpty ?? false) {
          evalData['body'] = {
            'rating': 'Excellent',
            'marks': 'मुख्य भाग',
            'comment': analysis.body!.join('\n'),
          };
        }
        if (analysis.conclusion?.isNotEmpty ?? false) {
          evalData['conclusion'] = {
            'rating': 'Excellent',
            'marks': 'निष्कर्ष',
            'comment': analysis.conclusion!.join('\n'),
          };
        }
        if (analysis.strengths?.isNotEmpty ?? false) {
          evalData['Strengths'] = {
            'rating': 'Excellent',
            'marks': 'मजबूतियाँ',
            'comment': analysis.strengths!.join('\n'),
          };
        }
        if (analysis.weaknesses?.isNotEmpty ?? false) {
          evalData['Areas for Improvement'] = {
            'rating': 'Needs Improvement',
            'marks': 'कमज़ोरियाँ',
            'comment': analysis.weaknesses!.join('\n'),
          };
        }
        if (analysis.suggestions?.isNotEmpty ?? false) {
          evalData['Suggestions'] = {
            'rating': 'Good',
            'marks': 'सुझाव',
            'comment': analysis.suggestions!.join('\n'),
          };
        }
      }
    }

    return evalData;
  }

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
                              _buildReviewOption(
                                'Others',
                                selectedOption,
                                Icons.more_horiz,
                                Colors.teal,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              if (selectedOption == 'Others') ...[
                                const SizedBox(height: 16),
                                TextField(
                                  controller: otherController,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Please specify your reason',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
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

                                final String finalSelectedOption =
                                    selectedOption == 'Others'
                                        ? otherController.text.trim()
                                        : selectedOption!;

                                final success = await controller.postReviewData(
                                  selectedOption: finalSelectedOption,
                                  otherText: null,
                                );

                                if (success) Navigator.pop(context);
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

  void _showFeedbackBottomSheet() {
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
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
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
                        'Share Your Feedback',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Help us improve your experience',
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
                              _buildFeedbackOption(
                                'Very Satisfied',
                                selectedOption,
                                Icons.sentiment_very_satisfied,
                                Colors.green,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildFeedbackOption(
                                'Satisfied',
                                selectedOption,
                                Icons.sentiment_satisfied,
                                Colors.lightGreen,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildFeedbackOption(
                                'Neutral',
                                selectedOption,
                                Icons.sentiment_neutral,
                                Colors.amber,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildFeedbackOption(
                                'Needs Improvement',
                                selectedOption,
                                Icons.sentiment_dissatisfied,
                                Colors.orange,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              _buildFeedbackOption(
                                'Other (Please Specify)',
                                selectedOption,
                                Icons.more_horiz,
                                Colors.blueGrey,
                                (value) =>
                                    setState(() => selectedOption = value),
                              ),
                              if (selectedOption == 'Other (Please Specify)')
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    16,
                                  ),
                                  child: TextField(
                                    controller: otherController,
                                    decoration: InputDecoration(
                                      hintText: 'Tell us how we can improve...',
                                      hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      contentPadding: const EdgeInsets.all(16),
                                    ),
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(fontSize: 14),
                                  ),
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
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
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
                                    ),
                                  );
                                  return;
                                }

                                if (selectedOption ==
                                        'Other (Please Specify)' &&
                                    otherController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please specify your feedback',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
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
                                        'Unable to submit feedback. Please try again.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                controller.setAnswerId(answerId);

                                final success = await controller.submitFeedBack(
                                  selectedOption: selectedOption.toString(),
                                  otherText:
                                      selectedOption == 'Other (Please Specify)'
                                          ? otherController.text
                                          : null,
                                );

                                if (success) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Thank you for your feedback!',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
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
                              ),
                              child: Text(
                                'Submit',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
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

  Widget _buildFeedbackOption(
    String title,
    String? selectedOption,
    IconData icon,
    Color iconColor,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onChanged(title),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color:
                selectedOption == title
                    ? Colors.redAccent[50]
                    : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  selectedOption == title
                      ? Colors.redAccent
                      : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color:
                      selectedOption == title
                          ? iconColor.withOpacity(0.2)
                          : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Radio<String>(
                value: title,
                groupValue: selectedOption,
                onChanged: onChanged,
                activeColor: Colors.redAccent,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    controller = Get.put(AnalysisController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLanguageToggle(),
              const SizedBox(height: 12),
              _buildSummaryCard(),
              const SizedBox(height: 24),

              _buildAnalysisDetails(),
              const SizedBox(height: 12),
              Obx(() {
                final evalData = getEvaluationData();
                if (evalData.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No evaluation data available',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  children:
                      evalData.entries.map((entry) {
                        final key = entry.key;
                        final data = entry.value;

                        Color cardColor;
                        switch (key) {
                          case 'introduction':
                            cardColor = Colors.blue.shade50;
                            break;
                          case 'body':
                            cardColor = Colors.green.shade50;
                            break;
                          case 'conclusion':
                            cardColor = Colors.orange.shade50;
                            break;
                          case 'Strengths':
                            cardColor = Colors.lightGreen.shade50;
                            break;
                          case 'Areas for Improvement':
                            cardColor = Colors.red.shade50;
                            break;
                          case 'Suggestions':
                            cardColor = Colors.purple.shade50;
                            break;
                          default:
                            cardColor = Colors.grey.shade100;
                        }
                        return Container(
                          width: Get.width,
                          child: Card(
                            color: cardColor,
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 9,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['marks'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    data['comment'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                );
              }),
              Remark(),

              comment(),
              SizedBox(height: Get.width * 0.03),
              if (!widget.isExpertReview)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(() {
                      final reviewStatus =
                          Get.find<MainAnalyticsController>()
                              .answerAnalysis
                              .value
                              ?.data
                              ?.answer
                              ?.reviewStatus;

                      final bool shouldShowReview = reviewStatus == null;
                      print('reviewStatus: $reviewStatus');
                      return shouldShowReview
                          ? InkWell(
                            onTap: _showReviewBottomSheet,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/rating.png',
                                    height: Get.width * 0.06,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Review',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Review Submitted',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                    }),
                    InkWell(
                      onTap: _showFeedbackBottomSheet,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/feedback.png',
                              height: Get.width * 0.06,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Feedback',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          final controller = Get.find<MainAnalyticsController>();
          final answer = controller.answerAnalysis.value?.data?.answer;
          final bool isHindi = _selectedLanguage == 'hindi';
          final evaluation = isHindi ? null : answer?.evaluation;
          final hindiEvaluation = isHindi ? answer?.hindiEvaluation : null;

          final accuracy = isHindi ? 0 : (evaluation?.accuracy ?? 0);
          final score =
              isHindi
                  ? (hindiEvaluation?.score ?? 0)
                  : (evaluation?.score ?? 0);
          final relevency =
              isHindi
                  ? (hindiEvaluation?.relevancy ?? 0)
                  : (evaluation?.relevancy ?? 0);
          final maximumMarks =
              controller
                  .answerAnalysis
                  .value
                  ?.data
                  ?.answer
                  ?.question
                  ?.metadata
                  ?.maximumMarks ??
              0;
          final scoreNum =
              score is num ? score : num.tryParse(score.toString()) ?? 0;
          final maxMarksNum =
              maximumMarks is num
                  ? maximumMarks
                  : num.tryParse(maximumMarks.toString()) ?? 1;
          final progressValue = (scoreNum / maxMarksNum).clamp(0.0, 1.0);

          String getRatingText(int accuracy) {
            if (accuracy >= 90) return 'Excellent';
            if (accuracy >= 75) return 'Good';
            if (accuracy >= 60) return 'Average';
            return 'Needs Improvement';
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      _selectedLanguage == 'hindi'
                          ? 'आपका स्कोर'
                          : 'Your Score',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
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
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progressValue),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${scoreNum} / $maximumMarks ',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: _getProgressColor(progressValue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMetricItem(
                    Icons.trending_up,
                    // '$relevency%',
                    'N/A',
                    _selectedLanguage == 'hindi' ? 'आपकी रैंक' : 'Your Rank',
                    Colors.green,
                  ),
                  _buildMetricItem(
                    Icons.assessment,
                    // '${evaluation?.score ?? 0}',
                    'N/A',
                    _selectedLanguage == 'hindi'
                        ? 'औसत स्कोर'
                        : 'Average Score',
                    Colors.orange,
                  ),
                  _buildMetricItem(
                    Icons.star,
                    // getRatingText(relevency),
                    'N/A',
                    _selectedLanguage == 'हिन्दी' ? 'शीर्ष स्कोर' : 'Top Score',
                    _getProgressColor(progressValue),
                  ),
                ],
              ),
            ],
          );
        }),
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
    if (value >= 0.75) return Colors.green;
    if (value >= 0.5) return Colors.blue;
    if (value >= 0.25) return Colors.orange;
    return Colors.red;
  }

  Widget _buildBarChart() {
    return Obx(() {
      final controller = Get.find<MainAnalyticsController>();
      final answer = controller.answerAnalysis.value?.data?.answer;
      final bool isHindi = _selectedLanguage == 'hindi';
      final evaluation = isHindi ? null : answer?.evaluation;
      final hindiEvaluation = isHindi ? answer?.hindiEvaluation : null;

      // Create chart data from evaluation
      final List<MapEntry<String, Map<String, dynamic>>> chartData = [];

      if (!isHindi && evaluation != null) {
        final analysis = evaluation.analysis;
        if (analysis?.strengths?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('Strengths', {
              'rating': 'Excellent',
              'marks': '${analysis!.strengths!.length}/5',
              'comment': analysis.strengths!.join('\n'),
            }),
          );
        }
        if (analysis?.weaknesses?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('Weaknesses', {
              'rating': 'Needs Improvement',
              'marks': '${analysis!.weaknesses!.length}/5',
              'comment': analysis.weaknesses!.join('\n'),
            }),
          );
        }
        if (analysis?.suggestions?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('Suggestions', {
              'rating': 'Good',
              'marks': '${analysis!.suggestions!.length}/5',
              'comment': analysis.suggestions!.join('\n'),
            }),
          );
        }
      } else if (isHindi && hindiEvaluation != null) {
        final analysis = hindiEvaluation.analysis;
        if (analysis?.strengths?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('मजबूतियाँ', {
              'rating': 'Excellent',
              'marks': '${analysis!.strengths!.length}/5',
              'comment': analysis.strengths!.join('\n'),
            }),
          );
        }
        if (analysis?.weaknesses?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('कमज़ोरियाँ', {
              'rating': 'Needs Improvement',
              'marks': '${analysis!.weaknesses!.length}/5',
              'comment': analysis.weaknesses!.join('\n'),
            }),
          );
        }
        if (analysis?.suggestions?.isNotEmpty ?? false) {
          chartData.add(
            MapEntry('सुझाव', {
              'rating': 'Good',
              'marks': '${analysis!.suggestions!.length}/5',
              'comment': analysis.suggestions!.join('\n'),
            }),
          );
        }
      }

      if (chartData.isEmpty) {
        return SizedBox(
          height: 300,
          child: Center(
            child: Text(
              'No data available',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        );
      }

      return SizedBox(
        height: 300,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          tooltipBehavior: TooltipBehavior(
            enable: true,
            format:
                'point.x\nRating: point.y\nMarks: point.series.dataLabelMapper',
            header: '',
          ),
          primaryXAxis: CategoryAxis(
            labelPlacement: LabelPlacement.betweenTicks,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 8,
              color: Colors.grey[800],
            ),
            majorGridLines: MajorGridLines(width: 0),
          ),
          primaryYAxis: NumericAxis(
            minimum: 0,
            maximum: 5,
            interval: 1,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 8,
              color: Colors.black,
            ),
            axisLine: AxisLine(width: 0),
            majorTickLines: MajorTickLines(size: 0),
          ),
          series: <CartesianSeries>[
            ColumnSeries<MapEntry<String, dynamic>, String>(
              dataSource: chartData,
              dataLabelMapper: (entry, _) {
                final parts = (entry.value['marks'] as String).split('/');
                final obtained = double.tryParse(parts[0]) ?? 0;
                final total =
                    double.tryParse(parts.length > 1 ? parts[1] : '5') ?? 5;
                final percent = (obtained / total * 100).toStringAsFixed(0);
                return '$percent%';
              },
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
                labelPosition: ChartDataLabelPosition.outside,
                labelAlignment: ChartDataLabelAlignment.outer,
                textStyle: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              xValueMapper: (entry, _) => entry.key,
              yValueMapper: (entry, _) {
                final parts = (entry.value['marks'] as String).split('/');
                return double.tryParse(parts[0]) ?? 0;
              },
              pointColorMapper:
                  (entry, _) => ratingColors[entry.value['rating'] as String],
              width: 0.6,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      );
    });
  }

  Widget Remark() {
    final controller = Get.find<MainAnalyticsController>();
    final answer = controller.answerAnalysis.value?.data?.answer;
    final bool isHindi = _selectedLanguage == 'hindi';
    final remark =
        isHindi
            ? (answer?.hindiEvaluation?.remark ?? '')
            : (answer?.evaluation?.remark ?? '');

    return Card(
      elevation: 7,
      color: const Color.fromARGB(255, 230, 225, 245),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Remark',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '$remark',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget comment() {
    final controller = Get.find<MainAnalyticsController>();
    final answer = controller.answerAnalysis.value?.data?.answer;
    final bool isHindi = _selectedLanguage == 'hindi';
    final List<String> comments =
        isHindi
            ? (answer?.hindiEvaluation?.comments ?? [])
            : (answer?.evaluation?.comments ?? []);

    // Join comments with newlines
    final String commentText = comments.join('\n');

    return Card(
      elevation: 7,
      color: const Color.fromARGB(255, 243, 223, 224),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHindi ? 'टिप्पणियाँ' : 'Comments',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.red[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              commentText.isNotEmpty
                  ? commentText
                  : (isHindi
                      ? 'कोई टिप्पणी उपलब्ध नहीं'
                      : 'No comments available'),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,

            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildLanguageToggle() {
    final bool isHindi = _selectedLanguage == 'hindi';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: Text(
            'English',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          selected: !isHindi,
          onSelected: (v) {
            if (v) setState(() => _selectedLanguage = 'english');
          },
        ),
        const SizedBox(width: 12),
        ChoiceChip(
          label: Text(
            'हिन्दी',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          selected: isHindi,
          onSelected: (v) {
            if (v) setState(() => _selectedLanguage = 'hindi');
          },
        ),
      ],
    );
  }
}
