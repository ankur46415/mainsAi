import 'package:mains/app_imports.dart';
import 'package:mains/model/getAllUploadedAnswers.dart';
import 'package:mains/my_kitabai_view/TestScreens/workBookPage/user_questions/user_questions_page.dart';
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
    final MainTestScreenController controller = Get.put(
      MainTestScreenController(),
    );
    final Color primaryRed = Colors.red[700]!;

    return DefaultTabController(
      length: 3,
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
                child: Text('WorkBook', style: TextStyle(color: Colors.white)),
              ),
              Tab(child: Text('Test', style: TextStyle(color: Colors.white))),
              Tab(
                child: Text('Question', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              final uploadController = Get.find<UploadAnswersController>();
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryRed),
                );
              }

              if (controller.workBookList.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.getAllSubmittedAnswers();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Text(
                            'No Workbooks Found',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final uniqueWorkbooks =
                  controller.workBookList
                      .fold<Map<String, Workbook>>({}, (map, workbook) {
                        map[workbook.sId ?? ''] = workbook;
                        return map;
                      })
                      .values
                      .toList();

              final shouldShowProgressCard =
                  uploadController.isUploadingToServer.value ||
                  (uploadController.uploadStatus.value.isNotEmpty &&
                      (uploadController.uploadStatus.value
                              .toLowerCase()
                              .contains('success') ||
                          uploadController.uploadStatus.value
                              .toLowerCase()
                              .contains('fail') ||
                          uploadController.uploadStatus.value
                              .toLowerCase()
                              .contains('error')));

              final totalCount =
                  uniqueWorkbooks.length + (shouldShowProgressCard ? 1 : 0);

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.getAllSubmittedAnswers();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: totalCount,
                  itemBuilder: (context, index) {
                    if (shouldShowProgressCard && index == 0) {
                      return _buildUploadProgressCard(uploadController);
                    }

                    final realIndex =
                        shouldShowProgressCard ? index - 1 : index;
                    final workbook = uniqueWorkbooks[realIndex];

                    final questionCount =
                        controller.testAnswersList
                            .where(
                              (answer) =>
                                  answer.bookWorkbookInfo?.workbook?.sId ==
                                  workbook.sId,
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
                            Hero(
                              tag: workbook.sId ?? 'book-$realIndex',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: workbook.coverImageUrl ?? '',
                                  height: 120,
                                  width: 100,
                                  fit: BoxFit.fill,
                                  placeholder:
                                      (_, __) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryRed,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.book,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    workbook.title ?? 'Untitled',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    workbook.description ??
                                        'No description available.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 6,
                                    children: [
                                      _buildInfoChip(
                                        icon: Icons.assignment_outlined,
                                        text: '$questionCount Submissions',
                                        color: primaryRed,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: primaryRed),
                );
              }

              final Map<String, dynamic> filteredTestsMap = {};

              for (var answer in controller.testAnswersList) {
                if (answer.submissionType == "subjective_test" &&
                    answer.testInfo != null) {
                  final test = answer.testInfo!;
                  filteredTestsMap[test.id.toString()] = test;
                }
              }

              final filteredTests = filteredTestsMap.values.toList();

              if (filteredTests.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await controller.getAllSubmittedAnswers();
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Text(
                            'No Subjective Tests Available',
                            style: GoogleFonts.poppins(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await controller.getAllSubmittedAnswers();
                },
                child: ListView.separated(
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
                            Hero(
                              tag: test.id ?? 'test-$index',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: test.imageUrl ?? '',
                                  height: 120,
                                  width: 100,
                                  fit: BoxFit.fill,
                                  placeholder:
                                      (_, __) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: primaryRed,
                                          ),
                                        ),
                                      ),
                                  errorWidget:
                                      (_, __, ___) => Container(
                                        color: Colors.grey[200],
                                        child: Icon(
                                          Icons.book,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    test.name ?? 'Untitled Test',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    test.description ??
                                        'No description available.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 6,
                                    children: [
                                      _buildInfoChip(
                                        icon: Icons.person_outline,
                                        text: test.category ?? 'Unknown',
                                        color: primaryRed,
                                      ),
                                      _buildInfoChip(
                                        icon: Icons.assignment_outlined,
                                        text: '$questionCount Submissions',
                                        color: primaryRed,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),

            UserQuestionsPage(),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: CustomColors.primaryColor, width: 2),
          ),
          child: ClipOval(
            child: FloatingActionButton(
              onPressed: () {
                Get.toNamed(AppRoutes.mainScanner);
              },
              backgroundColor: Colors.white,
              elevation: 0,
              child: Icon(Icons.qr_code_scanner_outlined),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
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
