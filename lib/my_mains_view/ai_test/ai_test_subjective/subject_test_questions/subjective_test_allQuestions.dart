import 'package:mains/app_imports.dart';

class SubjectiveTestAllquestions extends StatefulWidget {
  const SubjectiveTestAllquestions({super.key});

  @override
  State<SubjectiveTestAllquestions> createState() =>
      _SubjectiveTestAllquestionsState();
}

class _SubjectiveTestAllquestionsState
    extends State<SubjectiveTestAllquestions> {
  late SubjectiveQuestionsController controller;
  late String testId;

  @override
  void initState() {
    super.initState();
    testId = Get.arguments;
    controller = Get.put(SubjectiveQuestionsController());

    controller.fetchQuestions(testId);
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFC107), // Yellow
                Color.fromARGB(255, 236, 87, 87), // Soft Red
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        title: Text(
          "All Questions",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              controller.resetTimer();
            },
            child: Icon(Icons.reset_tv, color: Colors.white),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                if (controller.questions.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFC107),
                        Color.fromARGB(255, 236, 87, 87),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade100,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Time Remaining",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatDuration(controller.remainingTime.value),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "End Test?",
                              titleStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.red.shade700,
                              ),
                              content: Text(
                                "Are you sure you want to submit and end the test?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                              radius: 10,
                              confirm: ElevatedButton.icon(
                                onPressed: () async {
                                  Get.back();
                                  await controller.endTest();
                                  final questionsData =
                                      controller.questions
                                          .map(
                                            (question) => {
                                              "id": question.sId ?? "",
                                              "text": question.question ?? "",
                                            },
                                          )
                                          .toList();

                                  final arguments = {
                                    "questions": questionsData,
                                    "testId": testId,
                                  };

                                  Get.toNamed(
                                    AppRoutes.subTestAnswrUpload,
                                    arguments: arguments,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.check,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  "Yes, End",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              cancel: TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            );
                          },
                          label: Text(
                            "End Test",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red.shade700,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 100),
                      child: Lottie.asset(
                        'assets/lottie/book_loading.json',
                        height: 200,
                        width: 200,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(['**'], value: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (controller.questions.isEmpty) {
                  return Center(
                    child: Text(
                      "No Questions",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.questions.length,
                  itemBuilder: (context, index) {
                    final question = controller.questions[index];

                    return _buildQuestionCard(
                      id: question.sId ?? "",
                      text: question.question ?? "",
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({required String id, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade50,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question : $text",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
