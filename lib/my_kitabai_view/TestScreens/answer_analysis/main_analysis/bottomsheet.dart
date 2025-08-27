import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_analytics_controller.dart';

void showFeedbackBottomSheet({required bool isReview}) {
  final controller = Get.put(MainAnalyticsController());
  String? selectedOption;
  final TextEditingController otherController = TextEditingController();

  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (context) => StatefulBuilder(
          builder: (context, setState) {
            return DraggableScrollableSheet(
              expand: false,
              maxChildSize: 0.85,
              initialChildSize: 0.65,
              builder:
                  (_, scrollController) => Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: ListView(
                      controller: scrollController,
                      shrinkWrap: true,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Text(
                          isReview ? 'Review Options' : 'Feedback',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ..._getOptions(isReview).map((option) {
                          return ListTile(
                            title: Text(option),
                            leading: Radio<String>(
                              value: option,
                              groupValue: selectedOption,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => selectedOption = value);
                                }
                              },
                            ),
                            onTap: () {
                              setState(() => selectedOption = option);
                            },
                          );
                        }),
                        if (selectedOption == 'Others' ||
                            selectedOption == 'Other (Please Specify)')
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: TextField(
                              controller: otherController,
                              decoration: const InputDecoration(
                                hintText: 'Please specify...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedOption != null) {
                                  if ((selectedOption == 'Others' ||
                                          selectedOption ==
                                              'Other (Please Specify)') &&
                                      otherController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please specify your reason',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Navigator.pop(context);
                                  // TODO: Handle submission result
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Please select an option'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                              ),
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            );
          },
        ),
  );
}

List<String> _getOptions(bool isReview) {
  return isReview
      ? [
        'Review answer',
        'Not satisfied',
        'Need manual check',
        'Need better analysis',
        'Incomplete answer',
        'Add sources',
        'Not a valid question',
        'Irrelevant answer',
        'Others',
      ]
      : [
        'Very Satisfied',
        'Satisfied',
        'Neutral',
        'Needs Improvement',
        'Other (Please Specify)',
      ];
}
