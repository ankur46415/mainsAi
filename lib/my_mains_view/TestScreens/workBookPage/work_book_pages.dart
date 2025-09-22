import 'package:mains/app_imports.dart';
import 'package:mains/models/getAllUploadedAnswers.dart';
import 'package:mains/my_mains_view/upload_images/controller.dart';

class WorkBookPagesForTest extends StatelessWidget {
  const WorkBookPagesForTest({super.key});

  Widget _buildUploadProgressCardWithImage(
    String? imageUrl,
    String? bookTitle,
    UploadAnswersController uploadController,
  ) {
    final isUploading = uploadController.isUploadingToServer.value;
    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child:
                imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                      imageUrl,
                      height: 120,
                      width: 100,
                      fit: BoxFit.fill,
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                    )
                    : Container(
                      height: 120,
                      width: 100,
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.image, color: Colors.grey),
                          SizedBox(height: 6),
                          Text(
                            'Title',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (bookTitle != null && bookTitle.trim().isNotEmpty)
                      ? bookTitle
                      : 'Title',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 6,
                  children: [
                    _buildInfoChip(
                      icon: Icons.cloud_upload,
                      text: '1 upload is in progress',
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                Lottie.asset(
                  'assets/lottie/image_uplaod_animations.json',
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                  repeat: true,
                  animate: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final String? imageUrl = args?['imageUrl'];
    final String? bookTitle = args?['bookTitle'];

    final MainTestScreenController controller = Get.put(
      MainTestScreenController(),
    );
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
                child: Text('WorkBook', style: TextStyle(color: Colors.white)),
              ),
              Tab(child: Text('Test', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              final uploadController =
                  Get.isRegistered<UploadAnswersController>()
                      ? Get.find<UploadAnswersController>()
                      : null;
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

              final bool shouldShowProgressCard =
                  uploadController != null &&
                  uploadController.isUploadingToServer.value;

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
                      return _buildUploadProgressCardWithImage(
                        imageUrl,
                        bookTitle,
                        uploadController,
                      );
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
