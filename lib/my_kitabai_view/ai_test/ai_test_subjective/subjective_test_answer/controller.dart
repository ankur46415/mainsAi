import 'dart:io';
import 'package:mains/app_imports.dart';
import 'sync_upload_answer/controller.dart';

class SubTestAnswerUploadController extends GetxController {
  final ImagePicker picker = ImagePicker();

  var questions = <Map<String, String>>[].obs;
  String? testId;
  var isSaving = false.obs;

  final answerImages = <String, RxList<Rx<File?>>>{}.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    print("🔍 Received arguments: $arguments");

    if (arguments != null && arguments is Map) {
      // New format with testId
      final questionsData = arguments['questions'] as List?;
      testId = arguments['testId'] as String?;

      if (questionsData != null) {
        questions.assignAll(questionsData.cast<Map<String, String>>());
        print("✅ Using passed questions data: ${questions.length} questions");
        print("🔍 TestId received: $testId");
        for (var question in questions) {
          print("📝 Question ID: ${question['id']}, Text: ${question['text']}");
        }
      } else {
        print("⚠️ No questions data received, using empty list");
        questions.assignAll([]);
      }
    } else if (arguments != null && arguments is List) {
      // Old format (backward compatibility)
      questions.assignAll(arguments.cast<Map<String, String>>());
      print(
        "✅ Using passed questions data (old format): ${questions.length} questions",
      );
      for (var question in questions) {
        print("📝 Question ID: ${question['id']}, Text: ${question['text']}");
      }
    } else {
      print("⚠️ No questions data received, using empty list");
      questions.assignAll([]);
    }

    for (var q in questions) {
      final id = q["id"]!;
      answerImages[id] = <Rx<File?>>[].obs;
      answerImages[id]!.add(Rx<File?>(null));
    }
  }

  void clearAllImages() {
    for (var questionId in answerImages.keys) {
      final imageList = answerImages[questionId]!;
      for (int i = 0; i < imageList.length; i++) {
        imageList[i].value = null;
      }
      while (imageList.length > 1) {
        imageList.removeLast();
      }
    }
    print("🧹 All images cleared from upload controller");
  }

  Future<void> pickImage(String questionId, int index) async {
    print('🖼️ pickImage called for questionId: $questionId, index: $index');

    await Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Text(
                'Choose Answers',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        await _pickFromGallery(questionId, index);
                      },
                      icon: const Icon(Icons.photo, color: Colors.white),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Get.back();
                        await _pickFromCamera(questionId, index);
                      },
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _pickFromGallery(String questionId, int index) async {
    try {
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final file = File(picked.path);
        answerImages[questionId]![index].value = file;

        if (index == answerImages[questionId]!.length - 1) {
          answerImages[questionId]!.add(Rx<File?>(null));
        }
      }
    } catch (e) {
      print('❌ Error picking from gallery: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image from gallery',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _pickFromCamera(String questionId, int index) async {
    print('📸 Starting camera pick for questionId: $questionId, index: $index');
    try {
      print('📸 Opening camera...');
      final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        final file = File(picked.path);
        answerImages[questionId]![index].value = file;

        if (index == answerImages[questionId]!.length - 1) {
          answerImages[questionId]!.add(Rx<File?>(null));
        }
      }
    } catch (e) {
      print('❌ Error picking from camera: $e');
      Get.snackbar(
        'Error',
        'Failed to take photo with camera',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
