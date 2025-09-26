import 'package:mains/app_imports.dart';

class OnjTestDescription extends StatefulWidget {
  const OnjTestDescription({super.key});

  @override
  State<OnjTestDescription> createState() => _OnjTestDescriptionState();
}

class _OnjTestDescriptionState extends State<OnjTestDescription> {
  late SubjectiveTestDescriptionController controller;
  late AiTestItem testData;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    controller = Get.put(SubjectiveTestDescriptionController());
    super.initState();
    _initializeTestData();
  }

  void _initializeTestData() {
    try {
      final arguments = Get.arguments;

      if (arguments == null) {
        _handleError('No test data provided');
        return;
      }

      if (arguments is AiTestItem) {
        testData = arguments;

        controller.setTestData(
          testData.testId,
          testData.name,
          testData.description,
          testData.estimatedTime,
          "1",
          "250",
        );
      } else {
        _handleError('Invalid test data format');
        return;
      }

      if (testData.testId.isEmpty) {
        _handleError('Test ID is missing');
        return;
      }

      if (testData.name.isEmpty) {
        _handleError('Test name is missing');
        return;
      }
    } catch (e) {
      _handleError('Error initializing test data: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      hasError = true;
      errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(title: 'Test Details'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error Loading Test',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: 'Test Details'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [CustomColors.primaryColor, Colors.redAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.shade200,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            testData.name,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetaTile(
                                "Time",
                                "${testData.estimatedTime} min",
                              ),
                              _buildMetaTile(
                                "Questions",
                                testData.totalQuestions.toString(),
                              ),
                              _buildMetaTile(
                                "Marks",
                                testData.testMaximumMarks.toString(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (testData.description.isNotEmpty) ...[
                      Text(
                        "Test Description",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          testData.description,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],

                    Text(
                      "Test Instructions",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        testData.instructions.isNotEmpty
                            ? testData.instructions
                            : "No instructions available",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    const SizedBox(
                      height: 100,
                    ), // Extra space so FAB doesn't overlap
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GestureDetector(
          onTap: () {
            if (testData.totalQuestions == 0) {
              return;
            }

            try {
              final testIdFromController = controller.getTestId();
              final testIdToUse =
                  testIdFromController.isNotEmpty
                      ? testIdFromController
                      : testData.testId;

              Get.toNamed(
                AppRoutes.mainTestForAiTest,
                arguments: {'testId': testIdToUse, 'testData': testData},
              );
            } catch (e) {
              Get.snackbar(
                'Error',
                'Failed to start test: $e',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color:
                  testData.totalQuestions == 0
                      ? Colors
                          .grey // agar 0 questions ho to grey
                      : CustomColors.primaryColor, // warna normal color
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: (testData.totalQuestions == 0
                          ? Colors.grey
                          : CustomColors.primaryColor)
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              testData.totalQuestions == 0 ? "No Questions" : "Start Test Now",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaTile(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
