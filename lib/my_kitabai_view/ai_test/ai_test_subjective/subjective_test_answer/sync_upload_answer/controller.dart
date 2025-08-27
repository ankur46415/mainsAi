import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/common/shred_pref.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mains/common/api_urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mains/app_routes.dart';

class SyncUploadAnswerController extends GetxController {
  String? authToken;
  late SharedPreferences prefs;
  Database? _database;
  var questions = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString(Constants.authToken);
    await _initDatabase();
  }

  Future<void> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'questions.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE questions (
            id TEXT PRIMARY KEY,
            question_text TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE question_images (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            question_id TEXT NOT NULL,
            image_path TEXT NOT NULL,
            created_at TEXT NOT NULL,
            FOREIGN KEY (question_id) REFERENCES questions (id)
          )
        ''');
      },
    );

    await _loadQuestionsFromDatabase();
  }

  Future<void> _loadQuestionsFromDatabase() async {
    if (_database == null) {
      print("❌ Database is null, cannot load questions");
      // Try to initialize database if it's null
      await _initDatabase();
      if (_database == null) {
        print("❌ Database initialization failed");
        return;
      }
    }

    try {
      print("🔄 Loading questions from database...");
      final List<Map<String, dynamic>> questionMaps = await _database!.rawQuery(
        '''
        SELECT 
          q.id,
          q.question_text,
          GROUP_CONCAT(qi.image_path) as images
        FROM questions q
        LEFT JOIN question_images qi ON q.id = qi.question_id
        GROUP BY q.id, q.question_text
        ORDER BY q.created_at DESC
      ''',
      );

      questions.clear();
      for (var map in questionMaps) {
        final images =
            map['images'] != null
                ? map['images'].toString().split(',')
                : <String>[];

        questions.add({
          'id': map['id'],
          'text': map['question_text'],
          'images': images,
        });
      }

      print("📦 Loaded ${questions.length} questions from database:");
      for (var question in questions) {
        print(
          "  ➤ ID: ${question['id']} | Text: ${question['text']} | Images: ${question['images']}",
        );
      }
    } catch (e) {
      print("❌ Error loading questions: $e");
    }
  }

  // Public method to refresh data from database
  Future<void> refreshQuestionsFromDatabase() async {
    print("🔄 Manually refreshing questions from database...");
    // Ensure database is initialized
    if (_database == null) {
      print("🔄 Database is null, initializing...");
      await _initDatabase();
    }
    await _loadQuestionsFromDatabase();
  }

  @override
  void onReady() {
    super.onReady();
    print("🔄 SyncUploadAnswerController: onReady called");
    // Wait a bit for database to be initialized, then refresh data
    Future.delayed(const Duration(milliseconds: 500), () {
      refreshQuestionsFromDatabase();
    });
  }

  Future<void> saveQuestion(String id, String questionText) async {
    if (_database == null) return;

    try {
      await _database!.insert('questions', {
        'id': id,
        'question_text': questionText,
        'created_at': DateTime.now().toIso8601String(),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      print("✅ Question saved to database.");
    } catch (e) {
      print("❌ Error saving question: $e");
    }
  }

  Future<void> saveQuestionImage(String questionId, String imagePath) async {
    if (_database == null) return;

    try {
      await _database!.insert('question_images', {
        'question_id': questionId,
        'image_path': imagePath,
        'created_at': DateTime.now().toIso8601String(),
      });
      print("✅ Image saved for question.");
    } catch (e) {
      print("❌ Error saving image: $e");
    }
  }

  Future<void> addImageToQuestion(String questionId, File imageFile) async {
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final savedPath = join(documentsDirectory.path, fileName);

      await imageFile.copy(savedPath);
      print("📥 Copied image to: $savedPath");

      await saveQuestionImage(questionId, savedPath);
      await _loadQuestionsFromDatabase();
    } catch (e) {
      print("❌ Error adding image: $e");
    }
  }

  Future<void> deleteQuestion(String questionId) async {
    if (_database == null) return;

    try {
      // 🔍 1. Get all image paths for this question
      final List<Map<String, dynamic>> imageRecords = await _database!.query(
        'question_images',
        where: 'question_id = ?',
        whereArgs: [questionId],
      );

      // 🗑️ 2. Delete actual image files
      for (var record in imageRecords) {
        final path = record['image_path'] as String;
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          print("🗑️ Deleted image from file system: $path");
        } else {
          print("⚠️ File does not exist: $path");
        }
      }

      // 🗑️ 3. Delete DB records
      await _database!.delete(
        'question_images',
        where: 'question_id = ?',
        whereArgs: [questionId],
      );

      await _database!.delete(
        'questions',
        where: 'id = ?',
        whereArgs: [questionId],
      );

      await _loadQuestionsFromDatabase();
      print("✅ Question and its image records deleted");
    } catch (e) {
      print("❌ Error deleting question: $e");
    }
  }

  Future<void> clearAllData() async {
    if (_database == null) return;

    try {
      await _database!.delete('question_images');
      await _database!.delete('questions');
      await _loadQuestionsFromDatabase();
    } catch (e) {
      print("❌ Error clearing data: $e");
    }
  }

    Future<void> saveQuestionsWithImages(
    List<Map<String, String>> questionsData,
    Map<String, RxList<Rx<File?>>> answerImages,
  ) async {
    print("💾 Saving ${questionsData.length} questions with images:");
    
    // Ensure database is initialized
    if (_database == null) {
      print("🔄 Database is null, initializing before saving...");
      await _initDatabase();
    }
    
    try {
      // Save all questions first
      for (var question in questionsData) {
        print("📝 Saving question:");
        print("  ID: ${question['id']}");
        print("  Text: ${question['text']}");

        await saveQuestion(question['id']!, question['text']!);
      }

      // Save all images
      for (var question in questionsData) {
        final imageList = answerImages[question['id']];
        if (imageList != null) {
          print("📷 Processing images for question: ${question['id']}");

          for (var imageRx in imageList) {
            final imageFile = imageRx.value;
            if (imageFile != null) {
              try {
                final documentsDirectory =
                    await getApplicationDocumentsDirectory();
                final fileName =
                    '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
                final savedPath = join(documentsDirectory.path, fileName);

                await imageFile.copy(savedPath);
                print("📥 Copied image to: $savedPath");

                print("📷 Saving image to database:");
                print("  For Question ID: ${question['id']}");
                print("  Image Path: $savedPath");

                await saveQuestionImage(question['id']!, savedPath);
                print("✅ Image saved to database successfully");
              } catch (e) {
                print("❌ Error saving image: $e");
                throw e; // Re-throw to stop the process
              }
            }
          }
        }
      }

      // Reload database once at the end
      print("🔄 Reloading database after all operations...");
      await _loadQuestionsFromDatabase();
      print("✅ All questions and images saved successfully!");
    } catch (e) {
      print("❌ Error in saveQuestionsWithImages: $e");
      throw e; // Re-throw to handle in the calling method
    }
  }

  Future<Map<String, dynamic>> uploadQuestionToAPI(
    String questionId,
    List<String> imagePaths, {
    String? testId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    if (authToken == null || authToken.isEmpty) {
      print("❌ No auth token found");
      return {"success": false, "message": "No authentication token found"};
    }

    try {
      final dynamicTestId = testId ?? "";

      final url =
          'https://aipbbackend-c5ed.onrender.com/api/clients/CLI147189HIGB/mobile/userAnswers/subjective-tests/$dynamicTestId/questions/$questionId/answers';

      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll({
        'Authorization': 'Bearer $authToken',
        'User-Agent': 'Kitabai-App',
      });

      for (int i = 0; i < imagePaths.length; i++) {
        final path = imagePaths[i];
        final file = File(path);
        if (!await file.exists()) {
          continue;
        }

        final mimeType = lookupMimeType(path) ?? 'image/jpeg';
        final multipartFile = await http.MultipartFile.fromPath(
          'images',
          path,
          contentType: MediaType.parse(mimeType),
        );

        request.files.add(multipartFile);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "message": "Upload successful"};
      } else {
        try {
          final responseData = json.decode(responseBody);
          final errorMessage = responseData['message'] ?? "Upload failed";
          return {"success": false, "message": errorMessage};
        } catch (e) {
          return {"success": false, "message": "Upload failed"};
        }
      }
    } catch (e) {
      return {"success": false, "message": "Network error: $e"};
    }
  }

  Future<void> uploadAllQuestionsToAPI({String? testId}) async {
    isLoading.value = true;
    bool anyFailures = false;

    try {
      print("🚀 Starting upload of ${questions.length} questions to API...");
      int processedCount = 0;
      
      for (var question in questions) {
        final questionId = question['id'] as String;
        final List<String> images = List<String>.from(question['images'] ?? []);

        if (images.isNotEmpty) {
          processedCount++;
          print("📤 Processing question $processedCount/${questions.length}: $questionId with ${images.length} images");
          
          try {
            final result = await uploadQuestionToAPI(
              questionId,
              images,
              testId: testId,
            );

            if (result['success'] == true) {
              print("✅ Question uploaded successfully: $questionId");
            } else {
              anyFailures = true;
              final errorMessage =
                  result['message'] ?? "Failed to upload question";

              print("❌ Failed to upload question: $questionId => $errorMessage");
              
              Get.snackbar(
                'Upload Failed',
                errorMessage,
                backgroundColor: Colors.red[50],
                colorText: Colors.red[900],
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 3),
              );
            }
          } catch (e) {
            anyFailures = true;
            print("🔥 Exception uploading question $questionId: $e");
            Get.snackbar(
              'Upload Error',
              'Failed to upload question: $e',
              backgroundColor: Colors.red[50],
              colorText: Colors.red[900],
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 3),
            );
          }
        } else {}
      }

      print("🎉 All questions upload process completed");

      // Delete all questions from database after all uploads are done
      print("🗑️ Deleting all questions from database...");
      final List<String> questionIdsToDelete = [];
      for (var question in questions) {
        final questionId = question['id'] as String;
        questionIdsToDelete.add(questionId);
      }
      
      // Delete questions after collecting all IDs
      for (String questionId in questionIdsToDelete) {
        await deleteQuestion(questionId);
      }
      print("✅ All questions deleted from database");

      if (testId != null && testId.isNotEmpty) {
        await submitSubjectiveTest(testId);
      } else {
        print("⚠️ testId is null or empty, cannot submit test.");
      }

      if (!anyFailures) {
        Get.snackbar(
          'Upload Successful',
          'All questions uploaded and test submitted.',
          backgroundColor: Colors.green[50],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM,
        );
        
        // Navigate back to bottom navigation bar at tab 3 (AI Test)
        await Future.delayed(const Duration(seconds: 2));
        Get.offAllNamed(AppRoutes.home, arguments: {'initialTab': 2});
      } else {
        // Even if there are failures, stay on the current page
        Get.snackbar(
          'Upload Completed with Errors',
          'Some questions failed to upload. Please try again.',
          backgroundColor: Colors.orange[50],
          colorText: Colors.orange[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("🔥 Exception during upload: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitSubjectiveTest(String testId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken') ?? '';

    final url =
        'https://aipbbackend-c5ed.onrender.com/api/subjectivetest/clients/CLI147189HIGB/tests/$testId/submit';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      print('📤 Request sent to: $url');
      print('📦 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Test submitted successfully: $data');
        // You can handle navigation or success message here
      } else {
        print('❌ Failed to submit test. Code: ${response.statusCode}');
      }
    } catch (e) {
      print('❗ Exception while submitting test: $e');
    }
  }
}
