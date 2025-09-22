import 'package:mains/app_imports.dart';
import 'package:mains/models/objective_question_test.dart';

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
  }

  Future<void> _initializeController() async {
    try {
      isLoading.value = true;
      prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString(Constants.authToken);

      await _initializeTestId();
    } catch (e) {
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

      if (arguments == null) {
        isLoading.value = false;
        return;
      }

      if (arguments is String) {
        testId = arguments;
      } else if (arguments is AiTestItem) {
        testId = arguments.testId;
        testData = arguments;
      } else if (arguments is Map<String, dynamic>) {
        if (arguments.containsKey('testId')) {
          testId = arguments['testId'] as String;
        }

        if (arguments.containsKey('testData')) {
          final testDataArg = arguments['testData'] as AiTestItem;
          testData = testDataArg;
        }

        if (!arguments.containsKey('testId') &&
            !arguments.containsKey('testData')) {
          isLoading.value = false;
          return;
        }
      } else {
        isLoading.value = false;
        return;
      }

      if (testId != null && testId!.isNotEmpty) {
        await getObjectiveQuestions(testId!);
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  Timer? _countdownTimer;

  void _startTestApi(String testId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';

    final String url = '${ApiUrls.objectiveTestStartBase}$testId/start';

    try {
      await callWebApi(
        null,
        url,
        {},
        token: token,
        showLoader: false,
        onResponse: (_) {},
        onError: () {},
      );
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
        final stats = getAnswerStats();
        final attemptedCount = stats['Attempted'] ?? 0;
        final unattemptedCount = stats['Not_attempted'] ?? 0;
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attempted',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.green[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$attemptedCount',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.green[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.orange, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unattempted',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$unattemptedCount',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.orange[900],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                          await submitAnswersToApi();
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

    submitAnswersToApi();

    Get.snackbar(
      "⏰ Time's Up!",
      "Test submitted automatically due to time expiration.",
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 3),
    );

    Future.delayed(Duration(seconds: 2), () {
      try {
        Get.until((route) => route.settings.name == AppRoutes.starttestpage);
      } catch (e) {
        Get.offAllNamed(AppRoutes.starttestpage, arguments: testData);
      }
    });
  }

  Future<void> submitAnswersToApi() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken') ?? '';
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

      final url = '${ApiUrls.objectiveTestSubmitBase}$testId/submit';

      await callWebApi(
        null,
        url,
        requestBody,
        token: token,
        showLoader: false,
        onResponse: (_) {},
        onError: () {},
      );
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

  Future<GetObjectQuestinTest?> getObjectiveQuestions(
    String testId, {
    int retryCount = 0,
  }) async {
    final String url = '${ApiUrls.objectiveTestQnsBase}$testId';

    try {
      await callWebApiGet(
        null,
        url,
        token: authToken ?? '',
        showLoader: false,
        onResponse: (response) async {
          final data = json.decode(response.body);
          await _updateQuestionsFromApi(data);
          return GetObjectQuestinTest.fromJson(data);
        },
        onError: () async {
          if (retryCount < 2) {
            await Future.delayed(Duration(seconds: 2));
            await getObjectiveQuestions(testId, retryCount: retryCount + 1);
            return;
          }
          isLoading.value = false;
        },
      );
    } catch (e) {
      if (retryCount < 2) {
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
        final List<Map<String, dynamic>> convertedQuestions =
            apiQuestions.map((q) {
              return {
                'question': q['question'] ?? '',
                'options': List<String>.from(q['options'] ?? []),
                'correctAnswer': q['correctAnswer'] ?? 0,
                'difficulty': q['difficulty'] ?? '',
                'estimatedTime': q['estimatedTime'] ?? 1,
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
        if (questionStatuses.isNotEmpty) {
          questionStatuses[0] = 'Not_attempted';
          questionStatuses.refresh();
        }

        if (data['test'] != null && data['test']['totalTime'] != null) {
          final totalTimeStr = data['test']['totalTime'] as String;
          final totalMinutes =
              int.tryParse(totalTimeStr.split(' ').first) ??
              convertedQuestions.length;
          timeRemaining.value = totalMinutes * 60;
        } else {
          timeRemaining.value = convertedQuestions.length * 60;
        }

        isLoading.value = false;
        startTimer(testId.toString());
      } else {
        isLoading.value = false;
      }
    } catch (e) {
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
