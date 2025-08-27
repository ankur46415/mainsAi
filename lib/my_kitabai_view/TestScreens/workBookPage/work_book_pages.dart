import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/upload_images/controller.dart';

class WorkBookPagesForTest extends StatelessWidget {
  const WorkBookPagesForTest({super.key});
  Widget _buildUploadProgressCard(UploadAnswersController uploadController) {
    final status = uploadController.uploadStatus.value.toLowerCase();
    final isUploading = uploadController.isUploadingToServer.value;
    final isSuccess =
        status.contains('success') || status.contains('completed');
    final isFailed =
        status.contains('fail') ||
        status.contains('error') ||
        status.contains('invalid');
    Color cardColor = Colors.redAccent;
    IconData icon = Icons.cloud_upload;
    String title = 'Uploading Images...';
    if (!isUploading) {
      if (isSuccess) {
        cardColor = Colors.green;
        icon = Icons.check_circle_outline_rounded;
        title = 'Upload Successful!';
      } else if (isFailed) {
        cardColor = Colors.red;
        icon = Icons.error_outline_rounded;
        title = 'Upload Failed!';
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: cardColor.withOpacity(0.15)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: cardColor, size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: cardColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final progress = uploadController.uploadProgress.value;
            final status = uploadController.uploadStatus.value;

            final isWaitingForServer =
                progress == 100 && status.contains("Uploading Your Answers");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0),
                  child:
                      isWaitingForServer
                          ? LinearProgressIndicator(
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          )
                          : LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.red,
                            ),
                          ),
                ),
                const SizedBox(height: 8),
                Text(
                  status,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                if (!isWaitingForServer)
                  Text(
                    '$progress%',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.red,
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    try {
      // Use Get.find instead of Get.put to avoid multiple instances
      MainTestScreenController controller;
      try {
        controller = Get.find<MainTestScreenController>();
      } catch (e) {
        controller = Get.put(MainTestScreenController(), permanent: true);
      }

      // Ensure data is loaded when the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.testAnswersList.isEmpty && !controller.isLoading.value) {
          controller.getAllSubmittedAnswers();
        }
      });

      final Color primaryRed = Colors.red[700]!;

      return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            title: Text(
              'Result',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.white,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  child: Text(
                    'WorkBook',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Tab(child: Text('Test', style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: primaryRed),
                        const SizedBox(height: 16),
                        Text(
                          'Loading WorkBooks...',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.workBookList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No WorkBooks Found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You haven\'t added any workbooks yet.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            print(
                              '🔄 WorkBookPagesForTest: Retry loading data',
                            );
                            controller.getAllSubmittedAnswers();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: controller.workBookList.length,
                  itemBuilder: (context, index) {
                    final workbook = controller.workBookList[index];
                    final questionCount =
                        controller.testAnswersList
                            .where(
                              (answer) =>
                                  answer.bookWorkbookInfo?.workbook?.sId ==
                                      workbook.sId &&
                                  answer.submissionType == "workbook",
                            )
                            .length;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap:
                          () => Get.to(
                            () => MainTestScreen(workBookId: workbook.sId),
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Cover Image
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:
                                  workbook.coverImageUrl != null &&
                                          workbook.coverImageUrl!.isNotEmpty
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: workbook.coverImageUrl!,
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) => Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: primaryRed,
                                                    ),
                                              ),
                                          errorWidget:
                                              (context, url, error) => Icon(
                                                Icons.book,
                                                color: Colors.grey[400],
                                                size: 30,
                                              ),
                                        ),
                                      )
                                      : Icon(
                                        Icons.book,
                                        color: Colors.grey[400],
                                        size: 30,
                                      ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workbook.title ?? 'Untitled',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    workbook.author ?? 'Unknown Author',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.question_answer,
                                        size: 16,
                                        color: primaryRed,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$questionCount questions answered',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
              // Second Tab: Test
              Obx(() {
                print('🔄 WorkBookPagesForTest: Building Test tab');
                // ✅ Deduplicate subjective tests by test ID
                final Map<String, dynamic> filteredTestsMap = {};

                for (var answer in controller.testAnswersList) {
                  if (answer.submissionType == "subjective_test" &&
                      answer.testInfo != null) {
                    final test = answer.testInfo!;
                    filteredTestsMap[test.id.toString()] =
                        test; // Keeps only one entry per test ID
                  }
                }

                final filteredTests = filteredTestsMap.values.toList();

                print(
                  'Filtered Subjective Tests (Unique): ${filteredTests.length}',
                );

                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: primaryRed),
                        const SizedBox(height: 16),
                        Text(
                          'Loading Tests...',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (filteredTests.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Tests Found',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'You haven\'t taken any tests yet.',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            print(
                              '🔄 WorkBookPagesForTest: Retry loading data',
                            );
                            controller.getAllSubmittedAnswers();
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: filteredTests.length,
                  itemBuilder: (context, index) {
                    final test = filteredTests[index];
                    final questionCount =
                        controller.testAnswersList
                            .where(
                              (answer) =>
                                  answer.testInfo?.id == test.id &&
                                  answer.submissionType == "subjective_test",
                            )
                            .length;

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap:
                          () => Get.to(() => MainTestScreen(testId: test.id)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Test Icon
                            Container(
                              width: 60,
                              height: 80,
                              decoration: BoxDecoration(
                                color: primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.quiz,
                                color: primaryRed,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    test.name ?? 'Untitled Test',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    test.category ?? 'Unknown Category',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.question_answer,
                                        size: 16,
                                        color: primaryRed,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '$questionCount questions answered',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      );
    } catch (e) {
      print('❌ WorkBookPagesForTest: Error building widget: $e');
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Result',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: CustomColors.primaryColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please try again',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  print('🔄 WorkBookPagesForTest: Retry after error');
                  Get.forceAppUpdate();
                },
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
