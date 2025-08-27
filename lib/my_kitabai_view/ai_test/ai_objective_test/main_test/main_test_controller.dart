import 'package:http/http.dart' as http;
import 'package:mains/app_imports.dart';
import 'package:mains/model/objective_question_test.dart';

class MainTestForAiTestController extends GetxController {
  late SharedPreferences prefs;
  String? authToken;
  String? testId;
  AiTestItem? testData;
  RxInt currentQuestionIndex = 0.obs;
  RxInt timeRemaining = 0.obs;
  RxList<int?> selectedAnswers = <int?>[].obs;
  RxList<String> questionStatuses = <String>[].obs;
  RxList<Map<String, dynamic>> questions = <Map<String, dynamic>>[].obs;
  RxBool isLoading = true.obs;
  RxBool isTestSubmitted = false.obs;

  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  @override
  void onReady() {
    super.onReady();
    // Additional initialization if needed after the widget is ready
    print('🔄 MainTestForAiTestController: onReady called');
  }

  Future<void> _initializeController() async {
    try {
      isLoading.value = true;
      prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString(Constants.authToken);
      
      print('🔑 Auth token retrieved: ${authToken != null ? "Yes" : "No"}');
      
      await _initializeTestId();
    } catch (e) {
      print('❌ Error initializing controller: $e');
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    isTestSubmitted.value = true;
    _countdownTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeTestId() async {
    try {
      final arguments = Get.arguments;
      print('📥 Received arguments: $arguments');
      print('📥 Arguments type: ${arguments.runtimeType}');

      if (arguments == null) {
        print('❌ No arguments provided');
        isLoading.value = false;
        return;
      }

      if (arguments is String) {
        testId = arguments;
        print('✅ Extracted testId as string: $testId');
      } else if (arguments is AiTestItem) {
        testId = arguments.testId;
        testData = arguments;
        print('✅ Extracted testId from AiTestItem: $testId');
      } else if (arguments is Map<String, dynamic>) {
        if (arguments.containsKey('testId')) {
          testId = arguments['testId'] as String;
          print('✅ Extracted testId from Map: $testId');
        }

        if (arguments.containsKey('testData')) {
          final testDataArg = arguments['testData'] as AiTestItem;
          testData = testDataArg;
          print('✅ Extracted testData from Map: ${testDataArg.name}');
        }

        if (!arguments.containsKey('testId') &&
            !arguments.containsKey('testData')) {
          print('❌ Map does not contain testId or testData');
          isLoading.value = false;
          return;
        }
      } else {
        print('❌ Unexpected argument type: ${arguments.runtimeType}');
        isLoading.value = false;
        return;
      }

      if (testId != null && testId!.isNotEmpty && authToken != null) {
        print('🔄 Loading questions for testId: $testId');
        await getObjectiveQuestions(testId!);
      } else {
        print('❌ TestId is null/empty or authToken is null');
        print('❌ TestId: $testId, AuthToken: ${authToken != null ? "Present" : "Missing"}');
        isLoading.value = false;
      }
    } catch (e) {
      print('❌ Error extracting testId: $e');
      isLoading.value = false;
    }
  }

  Timer? _countdownTimer;

  void _startTestApi(String testId) async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');

    final String url = '${ApiUrls.objectiveTestStartBase}$testId/start';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  void startTimer(String testId) {
    _startTestApi(testId);
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isTestSubmitted.value) {
        timer.cancel();
        return;
      }

      if (timeRemaining.value > 0) {
        timeRemaining.value--;

        if (timeRemaining.value == 300) {
          Get.snackbar(
            "⚠️ Time Warning",
            "Only 5 minutes remaining!",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }

        if (timeRemaining.value == 60) {
          Get.snackbar(
            "🚨 Final Warning",
            "Only 1 minute remaining!",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      } else {
        timer.cancel();
        _autoSubmit();
      }
    });
  }

  String getFormattedTime() {
    if (timeRemaining.value <= 0) {
      return '00:00';
    }

    final minutes = (timeRemaining.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (timeRemaining.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool isTimerExpired() {
    return timeRemaining.value <= 0;
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevQuestion() {
    if (currentQuestionIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void submitTest(BuildContext context) {
    isTestSubmitted.value = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 24.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  "Submit Test?",
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Are you sure you want to submit your test?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          isTestSubmitted.value = false;
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          // Submit answers to API
                          await _submitAnswersToApi();

                          Get.snackbar(
                            "Submitted",
                            "Your test has been submitted.",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(12),
                            borderRadius: 12,
                            duration: const Duration(seconds: 2),
                          );

                          try {
                            Get.until(
                              (route) =>
                                  route.settings.name ==
                                  AppRoutes.starttestpage,
                            );
                          } catch (e) {
                            Get.offAllNamed(
                              AppRoutes.starttestpage,
                              arguments: testData,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _autoSubmit() {
    if (questions.isEmpty) {
      return;
    }

    isTestSubmitted.value = true;

    _submitAnswersToApi();

    Get.snackbar(
      "⏰ Time's Up!",
      "Test submitted automatically due to time expiration.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
    );

    Future.delayed(Duration(seconds: 2), () {
      // Use a more reliable navigation approach
      try {
        // First try to navigate back to the test page
        Get.until((route) => route.settings.name == AppRoutes.starttestpage);
      } catch (e) {
        // If that fails, use offAllNamed but with better error handling
        Get.offAllNamed(AppRoutes.starttestpage, arguments: testData);
      }
    });
  }

  Future<void> _submitAnswersToApi() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('authToken');
    if (testId == null || testId!.isEmpty) {
      return;
    }

    try {
      Map<String, int?> answers = {};
      int answeredQuestions = 0;

      for (int i = 0; i < questions.length; i++) {
        String questionId = questions[i]['_id'] ?? '';
        int? selectedAnswer = selectedAnswers[i];

        int? answerValue;
        if (selectedAnswer != null) {
          answerValue = selectedAnswer;
        } else {
          answerValue = null;
        }
        answers[questionId] = answerValue;

        if (selectedAnswer != null) {
          answeredQuestions++;
        }
      }

      Map<String, dynamic> requestBody = {
        'answers': answers,
        'totalQuestions': questions.length,
        'answeredQuestions': answeredQuestions,
      };

      String jsonBody = jsonEncode(requestBody);

      final url = '${ApiUrls.objectiveTestSubmitBase}$testId/submit';

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
      } else {}
    } catch (e) {}
  }

  void markSeen(int index) {
    if (questionStatuses[index] == 'Unseen') {
      questionStatuses[index] = 'Not_attempted';
      questionStatuses.refresh();
    }
  }

  void jumpToQuestion(int index) {
    currentQuestionIndex.value = index;
    pageController.jumpToPage(index);
  }

  String getQuestionStatus(int index) {
    final answer = selectedAnswers[index];
    final status = questionStatuses[index];

    if (answer != null) return 'Attempted';
    return status;
  }

  Map<String, int> getAnswerStats() {
    int attempted = 0;
    int notAttempted = 0;
    int review = 0;
    int unseen = 0;

    for (int i = 0; i < questions.length; i++) {
      final ans = selectedAnswers[i];
      final status = questionStatuses[i];

      if (ans != null) {
        attempted++;
      } else if (status == 'Review') {
        review++;
      } else if (status == 'Unseen') {
        unseen++;
      } else {
        notAttempted++;
      }
    }

    return {
      'Attempted': attempted,
      'Not_attempted': notAttempted,
      'Review': review,
      'Unseen': unseen,
    };
  }

  void markForReview(int index) {
    questionStatuses[index] = 'Review';
    questionStatuses.refresh();
  }

  Future<GetObjectQuestinTest?> getObjectiveQuestions(String testId, {int retryCount = 0}) async {
    final String url = '${ApiUrls.objectiveTestQnsBase}$testId';

    try {
      print('🌐 Making API call to: $url');
      print('🔐 Using auth token: ${authToken != null ? "Present" : "Missing"}');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (authToken != null && authToken!.isNotEmpty)
            'Authorization': 'Bearer $authToken',
        },
      ).timeout(Duration(seconds: 30));

      print('📡 Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Successfully received questions data');

        await _updateQuestionsFromApi(data);
        return GetObjectQuestinTest.fromJson(data);
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Invalid auth token');
        isLoading.value = false;
      } else if (response.statusCode == 404) {
        print('❌ Test not found - Invalid test ID');
        isLoading.value = false;
      } else {
        print('❌ API error: ${response.statusCode} - ${response.body}');
        // Retry logic for server errors
        if (retryCount < 2 && (response.statusCode >= 500 || response.statusCode == 408)) {
          print('🔄 Retrying API call (attempt ${retryCount + 1}/3)');
          await Future.delayed(Duration(seconds: 2));
          return await getObjectiveQuestions(testId, retryCount: retryCount + 1);
        }
        isLoading.value = false;
      }
    } catch (e) {
      print('❌ Network error: $e');
      // Retry logic for network errors
      if (retryCount < 2) {
        print('🔄 Retrying due to network error (attempt ${retryCount + 1}/3)');
        await Future.delayed(Duration(seconds: 3));
        return await getObjectiveQuestions(testId, retryCount: retryCount + 1);
      }
      isLoading.value = false;
    }

    return null;
  }

  Future<void> _updateQuestionsFromApi(Map<String, dynamic> data) async {
    try {
      if (data['success'] == true && data['questions'] != null) {
        final List<dynamic> apiQuestions = data['questions'];

        int totalEstimatedTimeMinutes = 0;
        int validQuestions = 0;

        final List<Map<String, dynamic>> convertedQuestions =
            apiQuestions.map((q) {
              int questionEstimatedTime = q['estimatedTime'] ?? 1;

              if (questionEstimatedTime > 0) {
                totalEstimatedTimeMinutes += questionEstimatedTime;
                validQuestions++;
              } else {
                questionEstimatedTime = 1;
                totalEstimatedTimeMinutes += questionEstimatedTime;
                validQuestions++;
              }

              return {
                'question': q['question'] ?? '',
                'options': List<String>.from(q['options'] ?? []),
                'correctAnswer': q['correctAnswer'] ?? 0,
                'difficulty': q['difficulty'] ?? '',
                'estimatedTime': questionEstimatedTime,
                'positiveMarks': q['positiveMarks'] ?? 1,
                'negativeMarks': q['negativeMarks'] ?? 0,
                'solution': q['solution'] ?? {},
                '_id': q['_id'] ?? '',
              };
            }).toList();

        questions.value = convertedQuestions;
        selectedAnswers.value = List<int?>.filled(
          convertedQuestions.length,
          null,
        );
        questionStatuses.value = List<String>.filled(
          convertedQuestions.length,
          'Unseen',
        );

        if (totalEstimatedTimeMinutes <= 0 || validQuestions == 0) {
          totalEstimatedTimeMinutes = convertedQuestions.length * 1;
        }

        timeRemaining.value = totalEstimatedTimeMinutes * 60;

        isLoading.value = false;

        startTimer(testId.toString());
        print('✅ Questions loaded successfully. Count: ${convertedQuestions.length}');
      } else {
        print('❌ Invalid API response structure');
        isLoading.value = false;
      }
    } catch (e) {
      print('❌ Error updating questions from API: $e');
      isLoading.value = false;
    }
  }
}

class MainTestForAiTestBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainTestForAiTestController());
  }
}
