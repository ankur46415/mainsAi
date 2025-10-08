import 'dart:async';
import 'package:mains/app_imports.dart';
import 'sync_upload_answer/controller.dart';
import '../subject_test_questions/controller.dart';
import 'dart:io';

class SubjectiveTestAnswerUpload extends StatefulWidget {
  const SubjectiveTestAnswerUpload({super.key});

  @override
  State<SubjectiveTestAnswerUpload> createState() =>
      _SubjectiveTestAnswerUploadState();
}

class _SubjectiveTestAnswerUploadState
    extends State<SubjectiveTestAnswerUpload> {
  final controller = Get.put(SubTestAnswerUploadController());
  late SubjectiveQuestionsController questionsController;
  // Remove page-level timer to prevent double ticking

  @override
  void initState() {
    super.initState();
    questionsController = Get.find<SubjectiveQuestionsController>();

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

  void _showImagePreview(String questionId, int index, File file) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        backgroundColor: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.8,
                  minHeight: 100,
                ),
                child: AspectRatio(
                  aspectRatio: 9 / 16,
                  child: InteractiveViewer(
                    maxScale: 5,
                    minScale: 1,
                    child: Image.file(file, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: Get.width * 0.1,
                  runSpacing: 8,
                  children: [
                    // Delete (small outlined red)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () async {
                        controller.answerImages[questionId]![index].value =
                            null;
                        Get.back();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),

                    // Close (small outlined)
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade400),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ),

                    // Replace (small filled)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () async {
                        Get.back();
                        await controller.pickImage(questionId, index);
                      },
                      child: const Text('Replace'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black87,
    );
  }

  Widget _buildImageBox(String questionId, int index) {
    return Obx(() {
      final file = controller.answerImages[questionId]![index].value;

      return GestureDetector(
        onTap: () {
          if (file != null) {
            _showImagePreview(questionId, index, file);
          } else {
            controller.pickImage(questionId, index);
          }
        },
        child: Container(
          width: Get.width * 0.3,
          height: Get.width * 0.4,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child:
              file != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(file, fit: BoxFit.cover),
                  )
                  : Icon(
                    Icons.add_a_photo,
                    size: 28,
                    color: Colors.red.shade300,
                  ),
        ),
      );
    });
  }

  Widget _buildQuestionCard(Map<String, String> question) {
    final questionId = question["id"]!;

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
                  "Q: ${question["text"]}",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Upload your answer",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          Obx(() {
            final imageList = controller.answerImages[questionId]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      imageList.length,
                      (index) => _buildImageBox(questionId, index),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
              ],
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Upload Answer',
        showBackButton: true,
        showTimer: true,
        timerWidget: Obx(
          () => Text(
            formatDuration(questionsController.remainingTime.value),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16),
          children: controller.questions.map(_buildQuestionCard).toList(),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          onPressed:
              controller.isSaving.value
                  ? null
                  : () async {
                    try {
                      // No validation required - user can proceed without images

                      controller.isSaving.value = true;
                      final syncController = Get.put(
                        SyncUploadAnswerController(),
                      );

                      await syncController.saveQuestionsWithImages(
                        controller.questions,
                        controller.answerImages,
                      );

                      controller.clearAllImages();

                      Get.snackbar(
                        "Success!",
                        "Your answers have been saved successfully",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 2),
                      );

                      await Future.delayed(const Duration(milliseconds: 1000));
                      Get.toNamed(AppRoutes.syncSubAnswer);
                    } catch (e) {
                      Get.snackbar(
                        "Error",
                        "Failed to save to database: $e",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    } finally {
                      controller.isSaving.value = false;
                    }
                  },

          backgroundColor: CustomColors.primaryColor,
          icon: const Icon(Icons.check, color: Colors.white),
          label: Text(
            "Summary",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
