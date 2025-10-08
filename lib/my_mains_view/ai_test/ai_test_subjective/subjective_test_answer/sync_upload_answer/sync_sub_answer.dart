import 'dart:async';
import 'dart:io';
import 'package:mains/app_imports.dart';
import 'controller.dart';
import '../../subject_test_questions/controller.dart';

class SyncSubAnswer extends StatefulWidget {
  const SyncSubAnswer({super.key});

  @override
  State<SyncSubAnswer> createState() => _SyncSubAnswerState();
}

class _SyncSubAnswerState extends State<SyncSubAnswer> {
  final controller = Get.put(SyncUploadAnswerController());
  final uploadController = Get.find<SubTestAnswerUploadController>();
  late SubjectiveQuestionsController questionsController;
  // Remove page-level timer to prevent double ticking

  @override
  void initState() {
    super.initState();
    // Get the existing questions controller to access timer
    questionsController = Get.find<SubjectiveQuestionsController>();
    
    // Check for time extension when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      questionsController.checkAndShowTimeExtension();
    });
  }

  @override
  void dispose() {
    // No page-level timer to cancel
    super.dispose();
  }

  String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final hours = duration.inHours.toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  void _showImagePreview(String imagePath) {
    final file = File(imagePath);
    if (!file.existsSync()) return;
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 9 / 16,
              child: InteractiveViewer(
                maxScale: 5,
                minScale: 1,
                child: Image.file(file, fit: BoxFit.contain),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black87,
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    final questionId = question['id'] as String;
    final questionText = question['text'] as String;
    final List<String> images = List<String>.from(question['images'] ?? []);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.red.shade100),
        borderRadius: BorderRadius.circular(12),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Q: $questionText",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (images.isNotEmpty) ...[
            Text(
              "Uploaded Images (${images.length})",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  final imagePath = images[index];
                  return GestureDetector(
                    onTap: () => _showImagePreview(imagePath),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else ...[
            Text(
              "No images uploaded yet",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => _deleteQuestion(questionId),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _deleteQuestion(String questionId) async {
    Get.defaultDialog(
      title: "Delete Question",
      titleStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.red.shade700,
      ),
      content: Text(
        "Are you sure you want to delete this question and all its images?",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      radius: 10,
      confirm: ElevatedButton.icon(
        onPressed: () async {
          Get.back();
          await controller.deleteQuestion(questionId);
          Get.snackbar(
            "Success",
            "Question deleted",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.delete, size: 18, color: Colors.white),
        label: const Text("Delete", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Future<void> _clearAllData() async {
    Get.defaultDialog(
      title: "Clear All Data",
      titleStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: Colors.red.shade700,
      ),
      content: Text(
        "Are you sure you want to delete all questions and images? This action cannot be undone.",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(fontSize: 14),
      ),
      radius: 10,
      confirm: ElevatedButton.icon(
        onPressed: () async {
          Get.back();
          await controller.clearAllData();
          Get.snackbar(
            "Success",
            "All data cleared",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: const Icon(Icons.clear_all, size: 18, color: Colors.white),
        label: const Text("Clear All", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  Future<void> _uploadAllQuestions(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false, // outside tap se close na ho
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: Icon(
                      Icons.cloud_upload,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    "Confirm Upload",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "⚠️ Please ensure every answer has a relevant image attached before uploading.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(color: Colors.white),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Get.snackbar(
                            "Uploading...",
                            "Answers are being uploaded in the background.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.blue,
                            colorText: Colors.white,
                          );
                          controller
                              .uploadAllQuestionsToAPI(
                                testId: uploadController.testId,
                              )
                              .catchError((error) {});
                          Get.offAllNamed(
                            AppRoutes.mainNav,
                            arguments: {'tabIndex': 2},
                          );
                        },
                        icon: const Icon(
                          Icons.cloud_upload,
                          size: 20,
                          color: Colors.redAccent,
                        ),
                        label: Text(
                          "Upload All",
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        controller.refreshQuestionsFromDatabase();
      });
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Summary', 
        showBackButton: true,
        showTimer: true,
        timerWidget: Obx(() => Text(
          formatDuration(questionsController.remainingTime.value),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.white,
          ),
        )),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.dashboard_sharp, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No questions in database",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Questions will appear here after they are saved",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            // Refresh data from database
            await controller.refreshQuestionsFromDatabase();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFFC107),
                      Color.fromARGB(255, 236, 87, 87),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.dashboard_sharp,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question Summary",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "${controller.questions.length} questions stored",
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...controller.questions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final question = entry.value as Map<String, dynamic>;
                      final List<String> images = List<String>.from(
                        question['images'] ?? [],
                      );
                      final imageCount = images.length;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(
                            255,
                            224,
                            191,
                            2,
                          ).withOpacity(0.2),
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              209,
                              3,
                              3,
                            ).withOpacity(0.08),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Question ${index + 1} = ' +
                                    imageCount.toString() +
                                    ' image' +
                                    (imageCount == 1 ? '' : 's'),
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    imageCount > 0
                                        ? Colors.green.withOpacity(0.8)
                                        : Colors.orange.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                imageCount > 0 ? '✓' : '!',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...controller.questions.map(_buildQuestionCard).toList(),
              SizedBox(height: Get.width * 0.25),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (controller.questions.isEmpty) return const SizedBox();

        return Padding(
          padding: EdgeInsets.only(
            left: Get.width * 0.03,
            right: Get.width * 0.03,
          ),
          child: Container(
            width: Get.width,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: FloatingActionButton.extended(
              onPressed: () {
                _uploadAllQuestions(context);
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              icon: const Icon(Icons.cloud_upload, color: Colors.white),
              label: Text(
                "Submit Test",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
