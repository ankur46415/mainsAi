import 'package:http/http.dart' as http;
import '../../../../app_imports.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  Future<void> _exportAllImagesAsPdf(List<String> imageUrls) async {
    try {
      final urls = imageUrls.where((u) => u.isNotEmpty).toList();
      if (urls.isEmpty) {
        Get.snackbar(
          'Export',
          'No images to export',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final logoBytes = await rootBundle.load('assets/images/mains-logo.png');
      final pwLogo = pw.MemoryImage(logoBytes.buffer.asUint8List());
      final pdf = pw.Document();

      for (final url in urls) {
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode != 200) {
          continue;
        }
        final pwImage = pw.MemoryImage(resp.bodyBytes);

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(24),
            build: (context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Container(
                            width: 36,
                            height: 36,
                            child: pw.Image(pwLogo, fit: pw.BoxFit.contain),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Text(
                            'mAIns',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        'Assessment Image',
                        style: pw.TextStyle(
                          fontSize: 12,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Divider(color: PdfColors.grey400),
                  pw.SizedBox(height: 12),
                  pw.Expanded(
                    child: pw.Center(
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.grey300,
                            width: 1,
                          ),
                        ),
                        child: pw.FittedBox(
                          fit: pw.BoxFit.contain,
                          child: pw.Image(pwImage),
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Generated: ${DateTime.now().toLocal().toString().split('.')
                          ..removeLast()
                          ..join()}',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey600,
                        ),
                      ),
                      pw.Text(
                        'Powered by mAIns',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      }

      final dir = await getTemporaryDirectory();
      final file = File(
        '${dir.path}/mains_images_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
      await file.writeAsBytes(await pdf.save());

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'mAIns Assessment Images');
    } catch (e) {
      Get.snackbar(
        'Export',
        'Failed to export PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
                        Padding(
                          padding: EdgeInsets.only(
                            left: Get.width * 0.03,
                            right: Get.width * 0.03,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            color: Colors.white,
                            child: Obx(() {
                              final controller =
                                  Get.find<MainAnalyticsController>();

                              final mainAnnotated = controller.annotatedImages;
                              final expertReviewAnnotated =
                                  controller
                                      .answerAnalysis
                                      .value
                                      ?.data
                                      ?.answer
                                      ?.feedback
                                      ?.expertReview
                                      ?.annotatedImages;
                              final answerImages = controller.answerImagesList;

                              List<String> images;
                              if (expertReviewAnnotated != null &&
                                  expertReviewAnnotated.isNotEmpty) {
                                images =
                                    expertReviewAnnotated
                                        .map((a) => a.downloadUrl ?? '')
                                        .where((e) => e.isNotEmpty)
                                        .toList();
                              } else if (mainAnnotated.isNotEmpty) {
                                images =
                                    mainAnnotated
                                        .map((a) => a.downloadUrl ?? '')
                                        .where((e) => e.isNotEmpty)
                                        .toList();
                              } else {
                                images =
                                    answerImages
                                        .map((a) => a.imageUrl ?? '')
                                        .where((e) => e.isNotEmpty)
                                        .toList();
                              }

                              return Padding(
                                padding: const EdgeInsets.all(12),
                                child: AspectRatio(
                                  aspectRatio: 4 / 3,
                                  child: Stack(
                                    children: [
                                      // --- IMAGE SLIDER ---
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: PageView.builder(
                                          controller: controller.pageController,
                                          itemCount: images.length,
                                          onPageChanged:
                                              (i) =>
                                                  controller.currentPage.value =
                                                      i,
                                          itemBuilder: (context, index) {
                                            final url = images[index];
                                            return GestureDetector(
                                              onTap: () {
                                                showGeneralDialog(
                                                  context: context,
                                                  barrierLabel: 'Close',
                                                  barrierDismissible: true,
                                                  barrierColor: Colors.black87,
                                                  transitionDuration:
                                                      const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                  pageBuilder: (_, __, ___) {
                                                    bool isLandscape = false;
                                                    int currentIndex = index;
                                                    final popupController =
                                                        PageController(
                                                          initialPage: index,
                                                        );

                                                    return StatefulBuilder(
                                                      builder: (
                                                        context,
                                                        setStateDialog,
                                                      ) {
                                                        final screenSize =
                                                            MediaQuery.of(
                                                              context,
                                                            ).size;
                                                        return Scaffold(
                                                          backgroundColor:
                                                              Colors.black,
                                                          body: Stack(
                                                            children: [
                                                              PageView.builder(
                                                                controller:
                                                                    popupController,
                                                                itemCount:
                                                                    images
                                                                        .length,
                                                                onPageChanged: (
                                                                  newIndex,
                                                                ) {
                                                                  setStateDialog(() {
                                                                    currentIndex =
                                                                        newIndex;
                                                                  });
                                                                },
                                                                itemBuilder: (
                                                                  _,
                                                                  i,
                                                                ) {
                                                                  final popupUrl =
                                                                      images[i];
                                                                  return Center(
                                                                    child: AnimatedContainer(
                                                                      duration: const Duration(
                                                                        milliseconds:
                                                                            300,
                                                                      ),
                                                                      curve:
                                                                          Curves
                                                                              .easeInOut,
                                                                      width:
                                                                          isLandscape
                                                                              ? screenSize.width
                                                                              : screenSize.width *
                                                                                  0.9,
                                                                      height:
                                                                          isLandscape
                                                                              ? screenSize.height
                                                                              : screenSize.height *
                                                                                  0.6,
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                        child: InteractiveViewer(
                                                                          minScale:
                                                                              1.0,
                                                                          maxScale:
                                                                              5.0,
                                                                          panEnabled:
                                                                              true,
                                                                          scaleEnabled:
                                                                              true,
                                                                          child: Padding(
                                                                            padding: EdgeInsets.all(
                                                                              isLandscape
                                                                                  ? 16.0
                                                                                  : 0.0,
                                                                            ), // 👈 Padding in landscape mode
                                                                            child: RotatedBox(
                                                                              quarterTurns:
                                                                                  isLandscape
                                                                                      ? 1
                                                                                      : 0,
                                                                              child: Image.network(
                                                                                popupUrl,
                                                                                fit:
                                                                                    isLandscape
                                                                                        ? BoxFit
                                                                                            .fill // 👈 Fill in landscape
                                                                                        : BoxFit.contain, // 👈 Normal in portrait
                                                                                errorBuilder:
                                                                                    (
                                                                                      _,
                                                                                      __,
                                                                                      ___,
                                                                                    ) => const Icon(
                                                                                      Icons.broken_image,
                                                                                      color:
                                                                                          Colors.white,
                                                                                      size:
                                                                                          80,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),

                                                              // ---- TOP RIGHT ICONS ----
                                                              Positioned(
                                                                top: 40,
                                                                right: 20,
                                                                child: Row(
                                                                  children: [
                                                                    IconButton(
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .screen_rotation,
                                                                        color:
                                                                            Colors.red, // 👈 red icon
                                                                        size:
                                                                            30,
                                                                      ),
                                                                      onPressed: () {
                                                                        isLandscape =
                                                                            !isLandscape;
                                                                        setStateDialog(
                                                                          () {},
                                                                        );
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    IconButton(
                                                                      icon: const Icon(
                                                                        Icons
                                                                            .close,
                                                                        color:
                                                                            Colors.red,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                      onPressed:
                                                                          () => Navigator.pop(
                                                                            context,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),

                                                              // ---- BOTTOM DOT INDICATORS ----
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
                                                                    (dotIndex) {
                                                                      return AnimatedContainer(
                                                                        duration: const Duration(
                                                                          milliseconds:
                                                                              300,
                                                                        ),
                                                                        margin: const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              4,
                                                                        ),
                                                                        height:
                                                                            8,
                                                                        width:
                                                                            currentIndex ==
                                                                                    dotIndex
                                                                                ? 20
                                                                                : 8,
                                                                        decoration: BoxDecoration(
                                                                          color:
                                                                              currentIndex ==
                                                                                      dotIndex
                                                                                  ? Colors.white
                                                                                  : Colors.grey,
                                                                          borderRadius:
                                                                              BorderRadius.circular(
                                                                                4,
                                                                              ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              },

                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 4,
                                                    ),
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit.fill,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          const Icon(
                                                            Icons.broken_image,
                                                            color: Colors.grey,
                                                            size: 40,
                                                          ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // ---- LEFT ARROW ----
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              if (controller.currentPage.value >
                                                  0) {
                                                controller.currentPage.value--;
                                                controller.pageController
                                                    .animateToPage(
                                                      controller
                                                          .currentPage
                                                          .value,
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      curve: Curves.easeInOut,
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        bottom: 0,
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.black,
                                              size: 24,
                                            ),
                                            onPressed: () {
                                              if (controller.currentPage.value <
                                                  images.length - 1) {
                                                controller.currentPage.value++;
                                                controller.pageController
                                                    .animateToPage(
                                                      controller
                                                          .currentPage
                                                          .value,
                                                      duration: const Duration(
                                                        milliseconds: 300,
                                                      ),
                                                      curve: Curves.easeInOut,
                                                    );
                                              }
                                            },
                                          ),
                                        ),
                                      ),

                                      // ---- PAGE INDICATORS ----
                                      Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 64,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            images.length,
                                            (index) {
                                              return Obx(() {
                                                return AnimatedContainer(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 3,
                                                      ),
                                                  height: 6,
                                                  width:
                                                      controller
                                                                  .currentPage
                                                                  .value ==
                                                              index
                                                          ? 18
                                                          : 6,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        controller
                                                                    .currentPage
                                                                    .value ==
                                                                index
                                                            ? Colors.blue
                                                            : Colors.white70,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),

                                      // ---- PDF ICONS ----
                                      Obx(() {
                                        final controller =
                                            Get.find<MainAnalyticsController>();
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
                                        if (publishStatus?.trim() ==
                                                "not_published" ||
                                            reviewSatus?.trim() ==
                                                "review_pending" ||
                                            reviewSatus?.trim() ==
                                                "review_accepted") {
                                          return const SizedBox.shrink();
                                        }
                                        return Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Row(
                                            children: [
                                              const SizedBox(width: 6),
                                              _buildCircleIcon(
                                                icon: Icons.download,
                                                onTap:
                                                    () => _exportAllImagesAsPdf(
                                                      images,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 12),
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
                              isScrollable: _tabs.length > 3,
                              labelPadding:
                                  _tabs.length > 3
                                      ? EdgeInsets.symmetric(horizontal: 12)
                                      : EdgeInsets.zero,
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
                                fontSize: 12,
                                color: Colors.black,
                              ),
                              unselectedLabelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              tabAlignment:
                                  _tabs.length > 3 ? TabAlignment.start : null,
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
                    Text(
                      questionText,
                      maxLines:
                          isExpanded
                              ? null
                              : 3, // 👈 show only 3 lines initially
                      overflow:
                          isExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (questionText.trim().split(RegExp(r'\s+')).length > 18)
                      TextButton(
                        onPressed: () => controller.isSeeMoreExpanded.toggle(),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isExpanded ? 'See Less' : 'See More',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
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

Widget _buildCircleIcon({required IconData icon, required VoidCallback onTap}) {
  return Container(
    padding: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.15),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: IconButton(
      icon: Icon(icon, color: Colors.red, size: 22),
      onPressed: onTap,
    ),
  );
}
