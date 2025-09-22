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
if (arguments != null && arguments is Map) {
      final questionsData = arguments['questions'] as List?;
      testId = arguments['testId'] as String?;

      if (questionsData != null) {
        questions.assignAll(questionsData.cast<Map<String, String>>());
for (var question in questions) {
}
      } else {
questions.assignAll([]);
      }
    } else if (arguments != null && arguments is List) {
      questions.assignAll(arguments.cast<Map<String, String>>());
      
      for (var question in questions) {
}
    } else {
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
}

  Future<void> pickImage(String questionId, int index) async {
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
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Choose Answers',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
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
try {
final picked = await picker.pickImage(source: ImageSource.camera);
      if (picked != null) {
        final file = File(picked.path);
        answerImages[questionId]![index].value = file;

        if (index == answerImages[questionId]!.length - 1) {
          answerImages[questionId]!.add(Rx<File?>(null));
        }
      }
    } catch (e) {
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
