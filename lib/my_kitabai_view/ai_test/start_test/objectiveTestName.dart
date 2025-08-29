import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/ai_test/start_test/attempts_result/attempts_results.dart';
import 'package:mains/my_kitabai_view/ai_test/start_test/objective_test_name.dart';

class ObjectiveTestName extends StatefulWidget {
  const ObjectiveTestName({super.key});

  @override
  State<ObjectiveTestName> createState() => _ObjectiveTestNameState();
}

class _ObjectiveTestNameState extends State<ObjectiveTestName> {
  final ScrollController _scrollController = ScrollController();
  late AiTestItem testData;

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;

    if (arguments != null && arguments is AiTestItem) {
      testData = arguments;
    } else {
}
  }

  @override
  void dispose() {
    if (Get.isRegistered<ObjectiveRestNameController>()) {
      try {
        Get.delete<ObjectiveRestNameController>(force: true);
      } catch (_) {}
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () async {
            if (Get.isRegistered<ObjectiveRestNameController>()) {
              await Get.find<ObjectiveRestNameController>().refreshData();
            }
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 280,
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset('assets/images/bg.jpg', fit: BoxFit.cover),
                      Container(color: Colors.black.withOpacity(0.3)),
                      Center(
                        child: Container(
                          width: 200,
                          height: 260,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildImageWidget(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testData.name,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        testData.category,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),

                      const SizedBox(height: 24),
                      GetBuilder<ObjectiveRestNameController>(
                        init: _initializeController(),
                        builder: (controller) {
                          // Check if controller is properly initialized
                          if (!Get.isRegistered<
                            ObjectiveRestNameController
                          >()) {
                            return Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "Loading...",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          final history =
                              controller.resultData.value?.attemptHistory ?? [];
                          final totalAttempts =
                              controller
                                  .resultData
                                  .value
                                  ?.attemptStats
                                  ?.totalAttempts ??
                              0;
                          final maxAttempts =
                              controller
                                  .resultData
                                  .value
                                  ?.attemptStats
                                  ?.maxAttempts ??
                              5;

                          if (controller.isLoading.value) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            children: [
                              if (totalAttempts < maxAttempts)
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => Get.toNamed(
                                          AppRoutes.onjTestDescription,
                                          arguments: testData,
                                        ),
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      "Let's Starts",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 14,
                                      ),
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 6,
                                    ),
                                  ),
                                ),

                              const SizedBox(height: 32),
                              Text(
                                "Previous Attempts",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Divider(color: Colors.grey),
                              if (history.isEmpty)
                                Text(
                                  "No attempts yet",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                )
                              else
                                Column(
                                  children: List.generate(history.length, (
                                    index,
                                  ) {
                                    final attempt = history[index];
                                    final dateTime =
                                        DateTime.tryParse(
                                          attempt.submittedAt ?? '',
                                        ) ??
                                        DateTime.now();
                                    final formattedDate =
                                        "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute}";

                                    return Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          Get.to(
                                            () => ResultOfAttemptTest(
                                              attempt: attempt,
                                              testId: testData.testId,
                                              maxMarks:
                                                  testData.testMaximumMarks
                                                      .toString(),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Attempt ${attempt.attemptNumber}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Colors.grey[600],
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Colors.grey[600],
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "Submitted at: $formattedDate",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.score,
                                                    color: Colors.grey[600],
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "Score: ${attempt.totalMarksEarned}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle_outline,
                                                    color: Colors.green,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "Correct: ${attempt.correctAnswers} / ${attempt.totalQuestions}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.timer_outlined,
                                                    color: Colors.blue,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    "Time: ${attempt.completionTime}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (testData.imageUrl.isEmpty || !testData.imageUrl.startsWith('http')) {
      return Image.asset('assets/images/bookb.png', fit: BoxFit.cover);
    }

    return CachedNetworkImage(
      imageUrl: testData.imageUrl,
      fit: BoxFit.cover,
      placeholder:
          (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget:
          (context, url, error) =>
              Image.asset('assets/images/bookb.png', fit: BoxFit.cover),
    );
  }

  ObjectiveRestNameController _initializeController() {
    if (Get.isRegistered<ObjectiveRestNameController>()) {
      return Get.find<ObjectiveRestNameController>();
    }
    return Get.put(ObjectiveRestNameController(), permanent: false);
  }
}
