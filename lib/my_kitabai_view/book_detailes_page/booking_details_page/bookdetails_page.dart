import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/common/loading_widget.dart';
import 'package:mains/my_kitabai_view/book_detailes_page/booking_details_page/controller.dart';
import 'package:mains/my_kitabai_view/book_detailes_page/summery/summery_texts.dart';
import 'package:mains/my_kitabai_view/bottomBar/MyHomePage.dart';
import 'package:mains/my_kitabai_view/bottomBar/controller.dart';
import 'package:mains/my_kitabai_view/my_library/controller.dart';
import 'package:mains/my_kitabai_view/voice_screen/Aiscreen.dart';
import 'package:mains/my_kitabai_view/voice_screen/controller.dart';
import 'package:mains/my_kitabai_view/watch/watch_intro.dart';
import 'dart:convert';

class BookDetailsPage extends StatefulWidget {
  final String? bookId;
  const BookDetailsPage({super.key, this.bookId});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late BookingDetailesController controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(BookingDetailesController());
    if (widget.bookId != null) {
      controller.fetchBookDetails(widget.bookId!);
    }
    controller.fetchBookStatus(widget.bookId!);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value ||
            controller.bookDetails.value?.data == null) {
          return Center(child: LoadingWidget());
        }

        final bookData = controller.bookDetails.value!.data!;
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: 260,
                pinned: true,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double currentHeight = constraints.biggest.height;
                    final bool showTitleImage =
                        currentHeight > kToolbarHeight + 50;
                    return FlexibleSpaceBar(
                      centerTitle: true,
                      title:
                          showTitleImage
                              ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                width: Get.width * 0.45,
                                height: Get.width * 0.45,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: bookData.cover_image_url ?? '',
                                    fit: BoxFit.fill,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Image.asset(
                                          'assets/images/book2.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                  ),
                                ),
                              )
                              : const SizedBox.shrink(),
                      background: Image.asset(
                        'assets/images/bg.jpg',
                        fit: BoxFit.cover,
                        cacheWidth: (Get.width * 2).toInt(),
                        cacheHeight: 520,
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBookInfoCard(bookData),
                      const SizedBox(height: 8),
                      _buildStatsCard(),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 12),
                      _buildTagsSection(bookData),
                      Obx(
                        () => SummarySection(
                          summary: controller.bookDetails.value?.data?.summary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildIndexSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBookInfoCard(dynamic bookData) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            bookData.title ?? 'No Title',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Get.width * 0.01),
          Text(
            '${bookData.subjectName ?? ''} | ${bookData.paperName ?? ''}, ${bookData.examName ?? ''}',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Get.width * 0.02),
          _buildRatingRow(bookData),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildMetaDataRow(bookData),
        ],
      ),
    );
  }

  Widget _buildRatingRow(dynamic bookData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          bookData.rating?.toString() ?? '0.0',
          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 4),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < (bookData.rating?.round() ?? 0)
                  ? Icons.star
                  : Icons.star_border,
              size: 14,
              color: Colors.amber,
            );
          }),
        ),
        const SizedBox(width: 6),
        Text(
          '(${bookData.ratingCount ?? 0} Ratings)',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaDataRow(dynamic bookData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetaDataItem(
          label: 'Creator',
          value: bookData.author ?? 'Unknown',
        ),
        _buildMetaDataItem(
          label: 'Institustion',
          value: bookData.publisher ?? 'Unknown',
        ),
        _buildMetaDataItem(
          label: 'Language',
          value: bookData.language ?? 'English',
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            label: 'Conversations',
            value: '23,776',
            icon: Icons.forum_outlined,
          ),
          Container(height: 40, width: 1, color: Colors.grey[200]),
          _buildStatItem(
            context,
            label: 'Users',
            value: '76,346',
            icon: Icons.people_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          height: Get.width * 0.13,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Chat',
                  onTap: () {
                    if (Get.isRegistered<VoiceController>()) {
                      Get.delete<VoiceController>();
                    }
                    final aiGuidelines = controller.aiGuidelines.value;

                    Get.to(
                      () => VoiceScreen(
                        initialChatMode: true,
                        questionId: widget.bookId!,
                        welcomeAiMessages: aiGuidelines?.message ?? "",
                        welcomeAiFAQsForChat:
                            aiGuidelines?.fAQs != null
                                ? jsonEncode(
                                  aiGuidelines!.fAQs!
                                      .map((e) => e.toJson())
                                      .toList(),
                                )
                                : null,
                      ),
                    );
                  },
                  isLeft: true,
                ),
              ),
              Container(
                width: 1,
                height: Get.width * 0.06,
                color: Colors.white.withOpacity(0.5),
              ),
              Expanded(
                child: _buildActionButton(
                  label: 'Talk',
                  onTap: () {
                    if (Get.isRegistered<VoiceController>()) {
                      Get.delete<VoiceController>();
                    }
                    final aiGuidelines = controller.aiGuidelines.value;

                    Get.to(
                      () => VoiceScreen(
                        initialChatMode: false,
                        questionId: widget.bookId!,
                        welcomeAiMessages: aiGuidelines?.message ?? "",
                        welcomeAiFAQsForChat:
                            aiGuidelines?.fAQs != null
                                ? jsonEncode(
                                  aiGuidelines!.fAQs!
                                      .map((e) => e.toJson())
                                      .toList(),
                                )
                                : null,
                      ),
                    );
                  },
                  isLeft: false,
                ),
              ),
              Container(
                width: 1,
                height: Get.width * 0.06,
                color: Colors.white.withOpacity(0.5),
              ),

              Expanded(
                child: _buildActionButton(
                  label: 'Watch',
                  onTap: () {
                    if (Get.isRegistered<VoiceController>()) {
                      Get.delete<VoiceController>();
                    }
                    Get.to(() => WatchIntroOfCourses(bookId: widget.bookId));
                  },
                  isLeft: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  controller.isSaved == true || controller.isActionLoading.value
                      ? () async {
                        if (!Get.isRegistered<MyLibraryController>()) {
                          Get.put(MyLibraryController(), permanent: true);
                        }

                        final myLibraryController =
                            Get.find<MyLibraryController>();
                        await myLibraryController.loadBooks();

                        final bottomNavController =
                            Get.find<BottomNavController>();
                        bottomNavController.changeIndex(1);
                        Get.offAll(() => MyHomePage());
                      }
                      : () => controller.addToMyBooks(widget.bookId.toString()),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                    controller.isSaved == true ? Colors.green : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(52),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                disabledBackgroundColor: Colors.grey,
                disabledForegroundColor: Colors.white.withOpacity(0.7),
              ),
              child:
                  controller.isActionLoading.value
                      ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : Text(
                        controller.isSaved == true
                            ? 'Go to My Library'
                            : 'Add To My Library',
                        style: GoogleFonts.poppins(
                          fontSize: 16, // Larger font
                          fontWeight: FontWeight.w500, // Medium weight
                          color: Colors.white,
                        ),
                      ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return InkWell(
      borderRadius: BorderRadius.only(
        topLeft: isLeft ? const Radius.circular(30) : Radius.zero,
        bottomLeft: isLeft ? const Radius.circular(30) : Radius.zero,
        topRight: !isLeft ? const Radius.circular(30) : Radius.zero,
        bottomRight: !isLeft ? const Radius.circular(30) : Radius.zero,
      ),
      onTap: onTap,
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildTagsSection(dynamic bookData) {
    final String tagString = bookData.tag ?? '';

    if (tagString.trim().isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No tags available',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      );
    }

    final List<String> tags =
        tagString
            .split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();

    if (tags.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'No tags available',
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: Wrap(
        spacing: Get.width * 0.03,
        runSpacing: 8,
        children: tags.map((tag) => _buildTag(tag)).toList(),
      ),
    );
  }

  Widget _buildIndexSection() {
    return Obx(() {
      final indexChapters = controller.bookDetails.value?.data?.index;

      // Show title and message when no data
      if (indexChapters == null || indexChapters.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Index',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'No index available',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: indexChapters.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Index',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final chapter = indexChapters[index - 1];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey),
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    title: Text(
                      chapter.chapterName ?? 'Untitled Chapter',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children:
                        (chapter.topics ?? [])
                            .map(
                              (topic) => ListTile(
                                title: Text(
                                  topic.topicName ?? 'Untitled Topic',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                                onTap: () {
                                  // Handle tap, use topic.topicId or topic.topicName
                                },
                              ),
                            )
                            .toList(),
                  ),
                ),
              ),

              const SizedBox(height: 4),
            ],
          );
        },
      );
    });
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(tag, style: GoogleFonts.poppins(fontSize: 12)),
    );
  }
}

Widget _buildStatItem(
  BuildContext context, {
  required String label,
  required String value,
  required IconData icon,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).primaryColor,
        ),
      ),
    ],
  );
}

Widget _buildMetaDataItem({required String label, required String value}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        label.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 10,
          color: Colors.grey[500],
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.grey[800],
        ),
      ),
    ],
  );
}
