import 'dart:io';
import 'package:intl/intl.dart';
import '../../app_imports.dart';
import '../../model/ReviewPendingList.dart';
import '../../model/getAllUploadedAnswers.dart' as uploaded;
import 'annotations/anotations_page.dart';
import 'controller.dart';
import 'full_images.dart';

class ListOfSubmissions extends StatefulWidget {
  ListOfSubmissions({super.key});

  @override
  State<ListOfSubmissions> createState() => _ListOfSubmissionsState();
}

class _ListOfSubmissionsState extends State<ListOfSubmissions> {
  late ListOfSubmissionsController controller;
  final Map<String, bool> _expandedStates = {};
  Future<void> _handleRefresh() async {
    await controller.getAllSubmittedAnswers();
  }

  String _capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1).toLowerCase();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(ListOfSubmissionsController());
    controller.getAllSubmittedAnswers();
    controller.getAllReviewRequest();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          title: Text(
            "Expert Review",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: CustomColors.primaryColor,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.white,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white,
            ),
            tabs: const [
              Tab(text: "Pending"),
              Tab(text: "Accepted"),
              Tab(text: "Completed"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() {
              return RefreshIndicator(
                onRefresh: _handleRefresh,
                child:
                    controller.isLoading.value
                        ? Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Lottie.asset(
                              'assets/lottie/book_loading.json',
                              fit: BoxFit.contain,
                              delegates: LottieDelegates(
                                values: [
                                  ValueDelegate.color(const [
                                    '**',
                                  ], value: Colors.red),
                                ],
                              ),
                            ),
                          ),
                        )
                        : controller.answersList.isEmpty
                        ? SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.rate_review_outlined,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      "No submissions yet.",
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Once students submit answers, they'll appear here.",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.grey[500],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        : ListView.separated(
                          padding: const EdgeInsets.all(
                            16,
                          ).copyWith(bottom: Get.width * 0.1),
                          itemCount: controller.answersList.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = controller.answersList[index];
                            return _buildAnswerCard(item, index);
                          },
                        ),
              );
            }),

            Obx(
              () => RefreshIndicator(
                onRefresh: _handleRefresh,
                child:
                    controller.isLoading.value
                        ? const LoadingWidget()
                        : _buildReviewList(),
              ),
            ),

            Obx(
              () => RefreshIndicator(
                onRefresh: _handleRefresh,
                child:
                    controller.isLoading.value
                        ? const LoadingWidget()
                        : _buildCompletedList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerCard(Requests answer, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      answer.answerId?.answerImages?.isNotEmpty == true &&
                              answer.answerId?.answerImages?.first.imageUrl !=
                                  null
                          ? Image.network(
                            answer.answerId!.answerImages![0].imageUrl ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                              );
                            },
                          )
                          : Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "ID: ${answer.questionId?.sId ?? ''}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      answer.createdAt != null
                          ? DateFormat(
                            'hh:mm a',
                          ).format(DateTime.parse(answer.createdAt!))
                          : "Time unknown",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!controller.isAccepted.value)
                          ElevatedButton(
                            onPressed: () {
                              controller.sendReviewRequest(answer.sId ?? "");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Accept",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
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

  Future<int> _getImageOrientation(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final exifData = await readExifFromBytes(bytes);

      if (exifData.isEmpty) return 0;

      final orientation = exifData['Image Orientation'];
      if (orientation != null) {
        return int.tryParse(orientation.printable) ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error reading EXIF data: $e');
      return 0;
    }
  }

  Widget _buildOrientedImage(String imagePath) {
    return FutureBuilder<int>(
      future: _getImageOrientation(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.grey[300],
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final orientation = snapshot.data ?? 0;
        return Transform.rotate(
          angle: _getRotationAngle(orientation),
          child: Image.file(
            File(imagePath),
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.grey[600],
                    size: 32,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  double _getRotationAngle(int orientation) {
    switch (orientation) {
      case 3:
        return pi;
      case 6:
        return pi / 2;
      case 8:
        return -pi / 2;
      default:
        return 0;
    }
  }

  Widget _buildAnnotationCard(Annotation annotation) {
    return FutureBuilder<AnnotatedList?>(
      future: AnnotationsDatabase.instance.getAnnotatedListByQuestionId(
        annotation.questionId,
      ),
      builder: (context, snapshot) {
        final annotatedList = snapshot.data;
        final isPartOfList =
            annotatedList != null &&
            annotatedList.annotatedImagePaths.contains(annotation.imagePath);

        return Card(
          elevation: 2,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final db = await AnnotationsDatabase.instance;
              final allAnnotations = await db.getAnnotationsByQuestionId(
                annotation.questionId,
              );
              final initialIndex = allAnnotations.indexWhere(
                (a) => a.imagePath == annotation.imagePath,
              );
              final currentIndexNotifier = ValueNotifier<int>(initialIndex);
              final pageController = PageController(initialPage: initialIndex);

              Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      PageView.builder(
                        controller: pageController,
                        itemCount: allAnnotations.length,
                        itemBuilder: (context, index) {
                          final currentAnnotation = allAnnotations[index];
                          return FutureBuilder<int>(
                            future: _getImageOrientation(
                              currentAnnotation.imagePath,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final orientation = snapshot.data ?? 0;
                              return Transform.rotate(
                                angle: _getRotationAngle(orientation),
                                child: InteractiveViewer(
                                  minScale: 0.5,
                                  maxScale: 4.0,
                                  child: Image.file(
                                    File(currentAnnotation.imagePath),
                                    fit: BoxFit.contain,
                                    width:
                                        MediaQuery.of(Get.context!).size.width,
                                    height:
                                        MediaQuery.of(Get.context!).size.height,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        onPageChanged: (index) {
                          currentIndexNotifier.value = index;
                        },
                      ),
                      Positioned(
                        top: 40,
                        right: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () => Get.back(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.black.withOpacity(0.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  if (currentIndexNotifier.value > 0) {
                                    pageController.previousPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                              ValueListenableBuilder<int>(
                                valueListenable: currentIndexNotifier,
                                builder: (context, index, child) {
                                  return Text(
                                    '${index + 1} / ${allAnnotations.length}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  if (currentIndexNotifier.value <
                                      allAnnotations.length - 1) {
                                    pageController.nextPage(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                barrierColor: Colors.black.withOpacity(0.9),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Thumbnail
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FutureBuilder<int>(
                        future: _getImageOrientation(annotation.imagePath),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final orientation = snapshot.data ?? 0;
                          return Transform.rotate(
                            angle: _getRotationAngle(orientation),
                            child: Image.file(
                              File(annotation.imagePath),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ID + Assigned Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "ID: ${annotation.id ?? ''}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.isAccepted.value
                                    ? "Reviewed At: 9:00 AM"
                                    : "",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          icon: null,
                          label: "Question",
                          text: "this is questions ",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    IconData? icon,
    required String label,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
                TextSpan(
                  text: text,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewList() {
    final reviewList =
        controller.testAnswersList
            .where((answer) => answer.reviewStatus == "review_accepted")
            .toList();

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
                "No completed reviews yet.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "Completed reviews will appear here.",
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
          return _buildAnswerCard2(item, index);
        },
      ),
    );
  }

  Widget _buildCompletedList() {
    final reviewList =
        controller.testAnswersList
            .where((answer) => answer.reviewStatus == "review_completed")
            .toList();

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
                "No completed reviews yet.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "Completed reviews will appear here.",
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
          return _buildAnswerCardForAnnotation(item, index);
        },
      ),
    );
  }

  Widget _buildAnswerCardForAnnotation(uploaded.Answers answer, int index) {
    final annotatedImages = controller.annotatedImagesMap[answer.sId] ?? [];
    final hasAnnotatedImage = annotatedImages.isNotEmpty;
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                if (hasAnnotatedImage) {
                  Get.to(() => AnnotatedImagesPage(imageUrls: annotatedImages));
                }
              },
              child: Hero(
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
                        'Question : ${answer.question?.text ?? 'No question text'}',
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
                      if ((answer.question?.text ?? '').length > 10)
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
                              fontSize: 12,
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

                  if (answer.reviewedAt != null)
                    Text(
                      'Evaluated: ${controller.formatDate(answer.reviewedAt)} at ${controller.formatTime(answer.reviewedAt)}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  const SizedBox(height: 8),
                  if (answer.feedback != null &&
                      answer.feedback!.expertReview != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: [
                              if (answer.feedback!.expertReview!.result != null)
                                Wrap(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      'Result: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${answer.feedback!.expertReview!.result}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),

                              if (answer.feedback!.expertReview!.score != null)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Score: ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '${answer.feedback!.expertReview!.score}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.blue[800],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          if (answer.feedback!.expertReview!.remarks != null &&
                              answer
                                  .feedback!
                                  .expertReview!
                                  .remarks!
                                  .isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Remarks: ${answer.feedback!.expertReview!.remarks}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          if (answer.feedback!.expertReview!.reviewedAt != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                'Reviewed At: ${controller.formatDate(answer.feedback!.expertReview!.reviewedAt)} at ${controller.formatTime(answer.feedback!.expertReview!.reviewedAt)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: Get.width * 0.03),
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
                            answer.submissionStatus?.trim().toLowerCase() ?? '',
                          ).withOpacity(0.1), // subtle background
                          border: Border.all(
                            color: _getStatusColor(
                              answer.submissionStatus?.trim().toLowerCase() ??
                                  '',
                            ),
                            width: Get.width * 0.002,
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
                                    answer.submissionStatus?.toLowerCase() ==
                                        'evaluated')
                                ? 'submitted'
                                : (answer.submissionStatus ?? 'Status unknown'),
                          ),
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: _getStatusColor(
                              (answer.publishStatus?.toLowerCase() ==
                                          'not_published' &&
                                      answer.submissionStatus?.toLowerCase() ==
                                          'evaluated')
                                  ? 'submitted'
                                  : (answer.submissionStatus
                                          ?.trim()
                                          .toLowerCase() ??
                                      ''),
                            ),
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
    );
  }

  Widget _buildAnswerCard2(uploaded.Answers answer, int index) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(
            () => AnnotationsPage(
              answerId: answer.sId ?? "",
              reviewRequest: answer.requestID ?? "",
              isAccepted: controller.isAccepted.value,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      answer.answerImages?.isNotEmpty == true &&
                              answer.answerImages?.first.imageUrl != null
                          ? Image.network(
                            answer.answerImages![0].imageUrl ?? "",
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                              );
                            },
                          )
                          : Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                          ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            "ID: ${answer.questionId ?? ''}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      answer.submittedAt != null
                          ? DateFormat(
                            'hh:mm a',
                          ).format(DateTime.parse(answer.submittedAt!))
                          : "Time unknown",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleExpanded(String answerId) {
    setState(() {
      _expandedStates[answerId] = !(_expandedStates[answerId] ?? false);
    });
  }
}
