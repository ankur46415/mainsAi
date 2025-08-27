import '../../model/getAllUploadedAnswers.dart';
import '../upload_images/controller.dart';
import '../../app_imports.dart';


class MainTestScreen extends StatefulWidget {
  final int? initialTabIndex;
  final String? workBookId;
  final String? testId;

  const MainTestScreen({
    super.key,
    this.initialTabIndex,
    this.workBookId,
    this.testId,
  });

  @override
  State<MainTestScreen> createState() => _MainTestScreenState();
}

class _MainTestScreenState extends State<MainTestScreen>
    with SingleTickerProviderStateMixin {
  late MainTestScreenController controller;
  late TabController _tabController;
  final Map<String, bool> _expandedStates = {};

  @override
  void initState() {
    controller = Get.put(MainTestScreenController());

    controller.getAllSubmittedAnswers();
    Get.put(UploadAnswersController());
    int tabLength = 3;
    int initialTabIndex = 0;
    controller.currentTabIndex.value = 0;
    _tabController = TabController(
      length: tabLength,
      vsync: this,
      initialIndex: 0,
    );
    _tabController.addListener(() {
      if (_tabController.index != controller.currentTabIndex.value) {
        controller.currentTabIndex.value = _tabController.index;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await controller.getAllSubmittedAnswers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(96),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(width: 24),
                    ),
                    Text(
                      "Result",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: Get.width * 0.14,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCustomTab(0, 'Submission'),
                      _buildCustomTab(1, 'Popular'),
                      _buildCustomTab(2, 'Review'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,
        children: [
          Obx(
            () => RefreshIndicator(
              onRefresh: _handleRefresh,
              child:
                  controller.isLoading.value
                      ? const LoadingWidget()
                      : controller.testAnswersList.isEmpty
                      ? Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.note_alt_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.testId != null &&
                                        widget.testId!.isNotEmpty
                                    ? "No test submissions found for this test."
                                    : widget.workBookId != null &&
                                        widget.workBookId!.isNotEmpty
                                    ? "No test submissions found for this workbook."
                                    : "No test submissions found.",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.testId != null &&
                                        widget.testId!.isNotEmpty
                                    ? "Students' test responses for this test will appear here once submitted."
                                    : widget.workBookId != null &&
                                        widget.workBookId!.isNotEmpty
                                    ? "Students' test responses for this workbook will appear here once submitted."
                                    : "Students' test responses will appear here once submitted.",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                      : _buildSubmissionList(),
            ),
          ),
          Obx(
            () => RefreshIndicator(
              onRefresh: _handleRefresh,
              child:
                  controller.isLoading.value
                      ? const LoadingWidget()
                      : _buildPopularList(),
            ),
          ),
          Obx(
            () => RefreshIndicator(
              onRefresh: _handleRefresh,
              child:
                  controller.isLoading.value
                      ? const LoadingWidget()
                      : _buildReviewList(),
            ),
          ),
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
    );
  }

  Widget _buildCustomTab(int index, String title) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _tabController.animateTo(index);
          controller.currentTabIndex.value = index;
        },
        child: Obx(
          () => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color:
                  controller.currentTabIndex.value == index
                      ? Colors.white
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight:
                      controller.currentTabIndex.value == index
                          ? FontWeight.w600
                          : FontWeight.w500,
                  color:
                      controller.currentTabIndex.value == index
                          ? CustomColors.primaryColor
                          : Colors.white70,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;

    return input
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }

  Widget _buildAnswerCardForSubmissions(Answers answer, int index) {
    final annotationUrl =
        (answer.annotations != null &&
                answer.annotations!.isNotEmpty &&
                (answer.annotations![0].downloadUrl?.isNotEmpty ?? false))
            ? answer.annotations![0].downloadUrl
            : null;

    final imageUrl =
        annotationUrl ??
        ((answer.images != null &&
                answer.images!.isNotEmpty &&
                (answer.images![0].imageUrl?.isNotEmpty ?? false))
            ? answer.images![0].imageUrl
            : null);
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(
            () => MainAnalytics(
              questionId: answer.sId,
              attemptNumber: answer.attemptNumber,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'answer-image-$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      imageUrl != null
                          ? Image.network(
                            imageUrl,
                            width: 80,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    const Icon(Icons.broken_image, size: 80),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return SizedBox(
                                width: 80,
                                height: 110,
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/mains-logo.png",
                                  ),
                                ),
                              );
                            },
                          )
                          : Container(
                            width: 80,
                            height: 110,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 40,
                              color: Colors.grey,
                            ),
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question  : ${answer.question?.text ?? 'No question text'}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                          maxLines:
                              _expandedStates[answer.sId ?? ''] == true
                                  ? null
                                  : 3,
                          overflow:
                              _expandedStates[answer.sId ?? ''] == true
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        if ((answer.question?.text ?? '').length > 100)
                          TextButton(
                            onPressed: () => _toggleExpanded(answer.sId ?? ''),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              _expandedStates[answer.sId ?? ''] == true
                                  ? 'See Less'
                                  : 'See More',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      'Submitted: ${controller.formatDate(answer.submittedAt)} at ${controller.formatTime(answer.submittedAt)}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (answer.evaluatedAt != null)
                      Text(
                        'Evaluated: ${controller.formatDate(answer.evaluatedAt)} at ${controller.formatTime(answer.evaluatedAt)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              (answer.publishStatus?.toLowerCase() ==
                                          'not_published' &&
                                      (answer.submissionStatus?.toLowerCase() ==
                                              'evaluated' ||
                                          answer.submissionStatus
                                                  ?.toLowerCase() ==
                                              'accepted'))
                                  ? 'submitted'
                                  : (answer.submissionStatus
                                          ?.trim()
                                          .toLowerCase() ??
                                      ''),
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _capitalizeFirstLetter(
                              (answer.publishStatus?.toLowerCase() ==
                                          'not_published' &&
                                      (answer.submissionStatus?.toLowerCase() ==
                                              'evaluated' ||
                                          answer.submissionStatus
                                                  ?.toLowerCase() ==
                                              'accepted'))
                                  ? 'submitted'
                                  : (answer.submissionStatus ??
                                      'Status unknown'),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _popularSubmissions(Answers answer, int index) {
    final annotationUrl =
        (answer.annotations != null &&
                answer.annotations!.isNotEmpty &&
                (answer.annotations![0].downloadUrl?.isNotEmpty ?? false))
            ? answer.annotations![0].downloadUrl
            : null;

    final imageUrl =
        annotationUrl ??
        ((answer.images != null &&
                answer.images!.isNotEmpty &&
                (answer.images![0].imageUrl?.isNotEmpty ?? false))
            ? answer.images![0].imageUrl
            : null);

    return Stack(
      children: [
        Material(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Get.to(
                () => MainAnalytics(
                  questionId: answer.sId,
                  attemptNumber: answer.attemptNumber,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'answer-image-$index',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          imageUrl != null
                              ? Image.network(
                                imageUrl,
                                width: 80,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => const Icon(
                                      Icons.broken_image,
                                      size: 80,
                                    ),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return SizedBox(
                                    width: 80,
                                    height: 110,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/mains-logo.png",
                                      ),
                                    ),
                                  );
                                },
                              )
                              : Container(
                                width: 80,
                                height: 110,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Question  : ${answer.question?.text ?? 'No question text'}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey[800],
                              ),
                              maxLines:
                                  _expandedStates[answer.sId ?? ''] == true
                                      ? null
                                      : 3,
                              overflow:
                                  _expandedStates[answer.sId ?? ''] == true
                                      ? TextOverflow.visible
                                      : TextOverflow.ellipsis,
                            ),
                            if ((answer.question?.text ?? '').length > 100)
                              TextButton(
                                onPressed:
                                    () => _toggleExpanded(answer.sId ?? ''),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size(50, 30),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  _expandedStates[answer.sId ?? ''] == true
                                      ? 'See Less'
                                      : 'See More',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          'Submitted: ${controller.formatDate(answer.submittedAt)} at ${controller.formatTime(answer.submittedAt)}',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (answer.evaluatedAt != null)
                          Text(
                            'Evaluated: ${controller.formatDate(answer.evaluatedAt)} at ${controller.formatTime(answer.evaluatedAt)}',
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// ❤️ Heart Icon on Top Right
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
              ],
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.favorite, color: Colors.redAccent, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildAnswerCard(Answers answer, int index) {
    final annotatedImages = controller.annotatedImagesMap[answer.sId] ?? [];
    final hasAnnotatedImage = annotatedImages.isNotEmpty;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(
            () => MainAnalytics(
              isExpertReview: true,
              questionId: answer.sId,
              attemptNumber: answer.attemptNumber,
              reviewStatus: answer.reviewStatus,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'answer-image-$index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      hasAnnotatedImage
                          ? Image.network(
                            annotatedImages[0],
                            width: 80,
                            height: 110,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
                                    Icon(Icons.broken_image, size: 80),
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return SizedBox(
                                width: 80,
                                height: 110,
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/mains-logo.png",
                                  ),
                                ),
                              );
                            },
                          )
                          : (answer.images != null && answer.images!.isNotEmpty
                              ? Image.network(
                                answer.images![0].imageUrl ?? '',
                                width: 80,
                                height: 110,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) =>
                                        Icon(Icons.broken_image, size: 80),
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return SizedBox(
                                    width: 80,
                                    height: 110,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/mains-logo.png",
                                      ),
                                    ),
                                  );
                                },
                              )
                              : Container(
                                width: 80,
                                height: 110,
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              )),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question  : ${answer.question?.text ?? 'No question text'}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[800],
                          ),
                          maxLines:
                              _expandedStates[answer.sId ?? ''] == true
                                  ? null
                                  : 3,
                          overflow:
                              _expandedStates[answer.sId ?? ''] == true
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                        ),
                        if ((answer.question?.text ?? '').length > 100)
                          TextButton(
                            onPressed: () => _toggleExpanded(answer.sId ?? ''),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              _expandedStates[answer.sId ?? ''] == true
                                  ? 'See Less'
                                  : 'See More',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (answer.reviewRequested != null)
                      Text(
                        'Requested : ${controller.formatDate(answer.reviewRequested)} at ${controller.formatTime(answer.reviewRequested)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    if (answer.reviewCompleted != null)
                      Text(
                        'Completed : ${controller.formatDate(answer.reviewCompleted)} at ${controller.formatTime(answer.reviewCompleted)}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              answer.reviewStatus?.trim().toLowerCase() ?? '',
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            _capitalizeFirstLetter(
                              (answer.reviewStatus?.toLowerCase() ==
                                          'not_published' &&
                                      answer.reviewStatus?.toLowerCase() ==
                                          'evaluated')
                                  ? 'submitted'
                                  : (answer.reviewStatus ?? 'Status unknown'),
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return Colors.orange;
      case 'evaluated':
        return Colors.green;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'review_completed':
        return Colors.lightBlue;
      case 'review_accepted':
        return Colors.pink;
      case 'review_pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReviewList() {
    // Filter review answers based on workBookId or testId if provided
    List<Answers> reviewList;
    if (widget.testId != null && widget.testId!.isNotEmpty) {
      // Filter by testId - show only review submissions for this specific test
      reviewList =
          controller.testAnswersList
              .where(
                (answer) =>
                    (answer.reviewStatus == "review_pending" ||
                        answer.reviewStatus == "review_accepted" ||
                        answer.reviewStatus == "review_completed") &&
                    answer.testInfo?.id.toString() == widget.testId,
              )
              .toList();
    } else if (widget.workBookId != null && widget.workBookId!.isNotEmpty) {
      // Filter by workBookId - show only review submissions for this specific workbook
      reviewList =
          controller.testAnswersList
              .where(
                (answer) =>
                    (answer.reviewStatus == "review_pending" ||
                        answer.reviewStatus == "review_accepted" ||
                        answer.reviewStatus == "review_completed") &&
                    answer.bookWorkbookInfo?.workbook?.sId == widget.workBookId,
              )
              .toList();
    } else {
      // Show all review submissions if no specific filter is provided
      reviewList =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.reviewStatus == "review_pending" ||
                    answer.reviewStatus == "review_accepted" ||
                    answer.reviewStatus == "review_completed",
              )
              .toList();
    }

    if (reviewList.isEmpty) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.rate_review_outlined, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                widget.testId != null && widget.testId!.isNotEmpty
                    ? "No review submissions for this test yet."
                    : widget.workBookId != null && widget.workBookId!.isNotEmpty
                    ? "No review submissions for this workbook yet."
                    : "No review submissions yet.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.testId != null && widget.testId!.isNotEmpty
                    ? "Once students submit answers for review from this test, they'll appear here."
                    : widget.workBookId != null && widget.workBookId!.isNotEmpty
                    ? "Once students submit answers for review from this workbook, they'll appear here."
                    : "Once students submit answers for review, they'll appear here.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Get.width * 0.1),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reviewList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = reviewList[index];
          return _buildAnswerCard(item, index);
        },
      ),
    );
  }

  Widget _buildPopularList() {
    // Filter popular answers based on workBookId or testId if provided
    List<Answers> popularAnswers;
    if (widget.testId != null && widget.testId!.isNotEmpty) {
      // Filter by testId - show only popular submissions for this specific test
      popularAnswers =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.popularityStatus == "popular" &&
                    answer.testInfo?.id.toString() == widget.testId,
              )
              .toList();
    } else if (widget.workBookId != null && widget.workBookId!.isNotEmpty) {
      // Filter by workBookId - show only popular submissions for this specific workbook
      popularAnswers =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.popularityStatus == "popular" &&
                    answer.bookWorkbookInfo?.workbook?.sId == widget.workBookId,
              )
              .toList();
    } else {
      // Show all popular submissions if no specific filter is provided
      popularAnswers =
          controller.testAnswersList
              .where((answer) => answer.popularityStatus == "popular")
              .toList();
    }

    if (popularAnswers.isEmpty) {
      return Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, size: 48, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                widget.testId != null && widget.testId!.isNotEmpty
                    ? "No popular test submissions for this test yet."
                    : widget.workBookId != null && widget.workBookId!.isNotEmpty
                    ? "No popular test submissions for this workbook yet."
                    : "No popular test submissions yet.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.testId != null && widget.testId!.isNotEmpty
                    ? "Once students engage more with this test, top submissions will appear here."
                    : widget.workBookId != null && widget.workBookId!.isNotEmpty
                    ? "Once students engage more with this workbook, top submissions will appear here."
                    : "Once students engage more, top submissions will appear here.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Get.width * 0.1),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: popularAnswers.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = popularAnswers[index];
          return _popularSubmissions(item, index);
        },
      ),
    );
  }

  Widget _buildSubmissionList() {
    final uploadController = Get.find<UploadAnswersController>();

    List<Answers> submissions;
    if (widget.testId != null && widget.testId!.isNotEmpty) {
      submissions =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.reviewStatus != "review_pending" &&
                    answer.reviewStatus != "review_accepted" &&
                    answer.reviewStatus != "review_completed" &&
                    answer.testInfo?.id.toString() == widget.testId,
              )
              .toList();
    } else if (widget.workBookId != null && widget.workBookId!.isNotEmpty) {
      submissions =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.reviewStatus != "review_pending" &&
                    answer.reviewStatus != "review_accepted" &&
                    answer.reviewStatus != "review_completed" &&
                    answer.bookWorkbookInfo?.workbook?.sId == widget.workBookId,
              )
              .toList();
    } else {
      submissions =
          controller.testAnswersList
              .where(
                (answer) =>
                    answer.reviewStatus != "review_pending" &&
                    answer.reviewStatus != "review_accepted" &&
                    answer.reviewStatus != "review_completed",
              )
              .toList();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: Get.width * 0.1),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount:
            submissions.length +
            (uploadController.isUploadingToServer.value ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (uploadController.isUploadingToServer.value && index == 0) {
            return _buildUploadProgressCard(uploadController);
          }
          final realIndex =
              uploadController.isUploadingToServer.value ? index - 1 : index;
          final item = submissions[realIndex];
          return _buildAnswerCardForSubmissions(item, realIndex);
        },
      ),
    );
  }

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

  void _toggleExpanded(String answerId) {
    setState(() {
      _expandedStates[answerId] = !(_expandedStates[answerId] ?? false);
    });
  }
}
