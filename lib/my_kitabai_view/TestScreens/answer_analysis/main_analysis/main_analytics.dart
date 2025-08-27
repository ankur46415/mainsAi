import '../../../../app_imports.dart';
import 'main_analytics_controller.dart';

class MainAnalytics extends StatefulWidget {
  final String? questionId;
  final int? attemptNumber;
  final bool? isExpertReview;
  final String? reviewStatus;
  const MainAnalytics({
    super.key,
    this.questionId,
    this.attemptNumber,
    this.isExpertReview,
    this.reviewStatus,
  });

  @override
  State<MainAnalytics> createState() => _MainAnalyticsState();
}

class _MainAnalyticsState extends State<MainAnalytics>
    with SingleTickerProviderStateMixin {
  late MainAnalyticsController controller;
  late TabController _tabController;
  late List<String> _tabs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      MainAnalyticsController(
        questionId: widget.questionId.toString(),
        attemptNumber: widget.attemptNumber,
      ),
    );

    final isExpertReview = widget.isExpertReview == true;
    _tabs =
        isExpertReview
            ? MainAnalyticsController.topTabs
            : MainAnalyticsController.topTabs.sublist(1);
    _tabController = TabController(length: _tabs.length, vsync: this);

    controller.fetchEvaluations();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: LoadingWidget()));
      }

      return Scaffold(
        backgroundColor: controller.currentColor.value,
        appBar: CustomAppBar(
          title: widget.isExpertReview == true ? "Expert Review" : "Assessment",
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Obx(() {
                                  final controller =
                                      Get.find<MainAnalyticsController>();
                                  final mainAnnotated =
                                      controller.annotatedImages;
                                  final expertReviewAnnotated =
                                      controller
                                          .answerAnalysis
                                          .value
                                          ?.data
                                          ?.answer
                                          ?.feedback
                                          ?.expertReview
                                          ?.annotatedImages;
                                  final answerImages =
                                      controller.answerImagesList;
                                  List<String> images;
                                  if (expertReviewAnnotated != null &&
                                      expertReviewAnnotated.isNotEmpty) {
                                    images =
                                        expertReviewAnnotated
                                            .map((a) => a.downloadUrl ?? '')
                                            .where((url) => url.isNotEmpty)
                                            .toList();
                                  } else if (mainAnnotated.isNotEmpty) {
                                    images =
                                        mainAnnotated
                                            .map((a) => a.downloadUrl ?? '')
                                            .where((url) => url.isNotEmpty)
                                            .toList();
                                  } else {
                                    images =
                                        answerImages
                                            .map((a) => a.imageUrl ?? '')
                                            .where((url) => url.isNotEmpty)
                                            .toList();
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () {
                                          if (controller.currentPage.value >
                                              0) {
                                            controller.currentPage.value--;
                                            controller.pageController
                                                .animateToPage(
                                                  controller.currentPage.value,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: Get.width * 0.6,
                                        width: Get.width * 0.6,
                                        child: PageView.builder(
                                          controller: controller.pageController,
                                          itemCount: images.length,
                                          onPageChanged:
                                              (index) =>
                                                  controller.currentPage.value =
                                                      index,
                                          itemBuilder: (context, index) {
                                            final imageUrl = images[index];
                                            return GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog(
                                                      backgroundColor:
                                                          Colors.black87,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      child: StatefulBuilder(
                                                        builder: (
                                                          context,
                                                          setStateDialog,
                                                        ) {
                                                          int popupPageIndex =
                                                              index;
                                                          final popupPageController =
                                                              PageController(
                                                                initialPage:
                                                                    index,
                                                              );
                                                          return Stack(
                                                            children: [
                                                              PageView.builder(
                                                                controller:
                                                                    popupPageController,
                                                                itemCount:
                                                                    images
                                                                        .length,
                                                                onPageChanged: (
                                                                  newIndex,
                                                                ) {
                                                                  setStateDialog(() {
                                                                    popupPageIndex =
                                                                        newIndex;
                                                                  });
                                                                },
                                                                itemBuilder: (
                                                                  context,
                                                                  popupIndex,
                                                                ) {
                                                                  final popupImageUrl =
                                                                      images[popupIndex];
                                                                  return InteractiveViewer(
                                                                    panEnabled:
                                                                        true,
                                                                    minScale: 1,
                                                                    maxScale: 4,
                                                                    child: Center(
                                                                      child: Image.network(
                                                                        popupImageUrl,
                                                                        fit:
                                                                            BoxFit.contain,
                                                                        errorBuilder: (
                                                                          context,
                                                                          error,
                                                                          stackTrace,
                                                                        ) {
                                                                          return Icon(
                                                                            Icons.broken_image,
                                                                            size:
                                                                                80,
                                                                            color:
                                                                                Colors.white,
                                                                          );
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                              // Close button
                                                              Positioned(
                                                                top: 40,
                                                                right: 20,
                                                                child: IconButton(
                                                                  icon: const Icon(
                                                                    Icons.close,
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    size: 30,
                                                                  ),
                                                                  onPressed:
                                                                      () =>
                                                                          Navigator.of(
                                                                            context,
                                                                          ).pop(),
                                                                ),
                                                              ),
                                                              // Page indicator
                                                              Positioned(
                                                                bottom: 30,
                                                                left: 0,
                                                                right: 0,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: List.generate(
                                                                    images
                                                                        .length,
                                                                    (
                                                                      dotIndex,
                                                                    ) => AnimatedContainer(
                                                                      duration: const Duration(
                                                                        milliseconds:
                                                                            300,
                                                                      ),
                                                                      margin: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            4,
                                                                      ),
                                                                      height: 8,
                                                                      width:
                                                                          popupPageIndex ==
                                                                                  dotIndex
                                                                              ? 20
                                                                              : 8,
                                                                      decoration: BoxDecoration(
                                                                        color:
                                                                            popupPageIndex ==
                                                                                    dotIndex
                                                                                ? Colors.white
                                                                                : Colors.grey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              4,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                    ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.grey[300],
                                                ),
                                                child:
                                                    imageUrl.isNotEmpty
                                                        ? ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: Image.network(
                                                            imageUrl,
                                                            fit: BoxFit.cover,
                                                            errorBuilder: (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) {
                                                              return Container(
                                                                color:
                                                                    Colors
                                                                        .grey[300],
                                                                child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  size: 40,
                                                                  color:
                                                                      Colors
                                                                          .grey,
                                                                ),
                                                              );
                                                            },
                                                            loadingBuilder: (
                                                              context,
                                                              child,
                                                              loadingProgress,
                                                            ) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Container(
                                                                color:
                                                                    Colors
                                                                        .grey[300],
                                                                child: Center(
                                                                  child: CircularProgressIndicator(
                                                                    value:
                                                                        loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        )
                                                        : Container(
                                                          color:
                                                              Colors.grey[300],
                                                          child: Icon(
                                                            Icons.image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      // Right arrow
                                      IconButton(
                                        icon: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.black54,
                                        ),
                                        onPressed: () {
                                          if (controller.currentPage.value <
                                              images.length - 1) {
                                            controller.currentPage.value++;
                                            controller.pageController
                                                .animateToPage(
                                                  controller.currentPage.value,
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.easeInOut,
                                                );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                }),

                                const SizedBox(height: 16),

                                // Dots Indicator
                                Obx(() {
                                  final controller =
                                      Get.find<MainAnalyticsController>();
                                  final mainAnnotated =
                                      controller.annotatedImages;
                                  final expertReviewAnnotated =
                                      controller
                                          .answerAnalysis
                                          .value
                                          ?.data
                                          ?.answer
                                          ?.feedback
                                          ?.expertReview
                                          ?.annotatedImages;
                                  final answerImages =
                                      controller.answerImagesList;
                                  List<String> images;
                                  if (mainAnnotated.isNotEmpty) {
                                    images =
                                        mainAnnotated
                                            .map((a) => a.downloadUrl ?? '')
                                            .toList();
                                  } else if (expertReviewAnnotated != null &&
                                      expertReviewAnnotated.isNotEmpty) {
                                    images =
                                        expertReviewAnnotated
                                            .map((a) => a.downloadUrl ?? '')
                                            .toList();
                                  } else {
                                    images =
                                        answerImages
                                            .map((a) => a.imageUrl ?? '')
                                            .toList();
                                  }
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(images.length, (
                                      index,
                                    ) {
                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        height: 8,
                                        width:
                                            controller.currentPage.value ==
                                                    index
                                                ? 20
                                                : 8,
                                        decoration: BoxDecoration(
                                          color:
                                              controller.currentPage.value ==
                                                      index
                                                  ? Colors.blue
                                                  : Colors.grey,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                        _buildQuestionBox(),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: _SliverAppBarDelegate(
                      minHeight: 48,
                      maxHeight: 48,
                      child: Obx(() {
                        final controller = Get.find<MainAnalyticsController>();
                        final publishStatus =
                            controller
                                .answerAnalysis
                                .value
                                ?.data
                                ?.answer
                                ?.publishStatus;
                        final reviewSatus =
                            controller
                                .answerAnalysis
                                .value
                                ?.data
                                ?.answer
                                ?.reviewStatus;
                        if (publishStatus?.trim() == "not_published" ||
                            reviewSatus?.trim() == "review_pending" ||
                            reviewSatus?.trim() == "review_accepted") {
                          return Container();
                        }
                        final isExpertReview = widget.isExpertReview == true;
                        return Container(
                          decoration: BoxDecoration(
                            color: controller.currentColor.value,
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              isScrollable: true,
                              labelPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              indicatorColor: Colors.transparent,
                              controller: _tabController,
                              indicator: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.red,
                                    width: 5,
                                  ),
                                ),
                              ),
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey.shade600,
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
                            ),
                          ),
                        );
                      }),
                    ),
                    pinned: true,
                  ),
                ];
              },
              body: Obx(() {
                final controller = Get.find<MainAnalyticsController>();
                final publishStatus =
                    controller
                        .answerAnalysis
                        .value
                        ?.data
                        ?.answer
                        ?.publishStatus;
                final reviewSatus =
                    controller.answerAnalysis.value?.data?.answer?.reviewStatus;

                if (publishStatus?.trim() == "not_published" ||
                    reviewSatus?.trim() == "review_pending" ||
                    reviewSatus?.trim() == "review_accepted") {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: Get.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 238, 91, 91),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              "Analysis will be available after evaluation",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                final isExpertReview = widget.isExpertReview == true;
                final List<Widget> tabViews =
                    isExpertReview
                        ? [
                          Builder(
                            builder: (context) {
                              final expertReview =
                                  controller
                                      .answerAnalysis
                                      .value
                                      ?.data
                                      ?.answer
                                      ?.feedback
                                      ?.expertReview;
                              if (expertReview != null) {
                                return ExpertReviews(
                                  expertReview: expertReview,
                                  reviewStatus: widget.reviewStatus,
                                );
                              } else {
                                return Center(
                                  child: Text('No Expert Review available'),
                                );
                              }
                            },
                          ),
                          Analysis(
                            isExpertReview: widget.isExpertReview ?? false,
                          ),
                          const ModelAnswerPage(),
                          Obx(() {
                            final question =
                                controller
                                    .answerAnalysis
                                    .value
                                    ?.data
                                    ?.answer
                                    ?.question;
                            return VideoAnswer(question: question);
                          }),
                        ]
                        : [
                          Analysis(
                            isExpertReview: widget.isExpertReview ?? false,
                          ),
                          const ModelAnswerPage(),
                          Obx(() {
                            final question =
                                controller
                                    .answerAnalysis
                                    .value
                                    ?.data
                                    ?.answer
                                    ?.question;
                            return VideoAnswer(question: question);
                          }),
                        ];

                return TabBarView(
                  controller: _tabController,
                  children: tabViews,
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

Widget _buildQuestionBox() {
  final controller = Get.find<MainAnalyticsController>();
  return TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 300),
    tween: Tween(begin: 0.0, end: 1.0),
    builder: (context, value, child) {
      return Transform.scale(
        scale: 0.95 + (value * 0.05),
        child: Opacity(opacity: value, child: child),
      );
    },
    child: Obx(() {
      final answer = controller.answerAnalysis.value?.data?.answer;
      if (answer == null) {
        return Center(child: Text(""));
      }

      final question = answer.question;
      final metadata = question?.metadata;

      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50.withOpacity(0.8),
                Colors.white,
                Colors.blue.shade50.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QUESTION',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  Text(
                    'MM : ${metadata?.maximumMarks ?? 10}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.01),
                  Text(
                    '${metadata?.estimatedTime} : Mins',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.green,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        metadata?.difficultyLevel ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(width: Get.width * 0.02),
                      SizedBox(width: Get.width * 0.02),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: Get.context!,
                            builder:
                                (BuildContext dialogContext) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  title: Text(
                                    'Question Details',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Difficulty: ${metadata?.difficultyLevel ?? 'N/A'}',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Text(
                                          'Word Limit: ${metadata?.wordLimit ?? 'N/A'}',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Text(
                                          'Time: ${metadata?.estimatedTime ?? 'N/A'} minutes',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        Text(
                                          'Marks: ${metadata?.maximumMarks ?? 'N/A'}',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        if (metadata?.keywords?.isNotEmpty ??
                                            false) ...[
                                          const SizedBox(height: 12),
                                          Text(
                                            'Keywords:',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Wrap(
                                            spacing: 6,
                                            children:
                                                metadata!.keywords!
                                                    .map(
                                                      (keyword) => Chip(
                                                        label: Text(
                                                          keyword,
                                                          style:
                                                              GoogleFonts.poppins(),
                                                        ),
                                                      ),
                                                    )
                                                    .toList(),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(dialogContext),
                                      child: Text(
                                        'Close',
                                        style: GoogleFonts.poppins(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.withOpacity(0.1),
                                  border: Border.all(color: Colors.red),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'i',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Obx(() {
                final isExpanded = controller.isSeeMoreExpanded.value;
                final questionText =
                    question?.text ?? 'No question text available';

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: isExpanded ? double.infinity : 60,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          questionText,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => controller.isSeeMoreExpanded.toggle(),
                          child: Text(
                            isExpanded ? 'See Less' : 'See more',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      );
    }),
  );
}
