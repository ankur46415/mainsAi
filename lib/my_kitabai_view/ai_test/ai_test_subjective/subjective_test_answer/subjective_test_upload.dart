import 'package:mains/app_imports.dart';
import 'sync_upload_answer/controller.dart';

class SubjectiveTestAnswerUpload extends StatelessWidget {
  SubjectiveTestAnswerUpload({super.key});

  final controller = Get.put(SubTestAnswerUploadController());

  Widget _buildImageBox(String questionId, int index) {
    return Obx(() {
      final file = controller.answerImages[questionId]![index].value;

      return GestureDetector(
        onTap: () => controller.pickImage(questionId, index),
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

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  imageList.length,
                  (index) => _buildImageBox(questionId, index),
                ),
              ),
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
      appBar: CustomAppBar(title: 'Upload Answer', showBackButton: true),
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
