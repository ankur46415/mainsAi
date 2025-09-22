import 'package:mains/app_imports.dart';
import 'package:mains/common/custom_banner.dart';
import 'package:mains/my_kitabai_view/workBook/work_bookController.dart';
import '../home_screen/see_more_books.dart';

class WorkBookBookPage extends StatefulWidget {
  const WorkBookBookPage({super.key});

  @override
  State<WorkBookBookPage> createState() => _WorkBookBookPageState();
}

class _WorkBookBookPageState extends State<WorkBookBookPage> {
  late WorkBookcontroller controller;

  @override
  void initState() {
    controller = Get.put(WorkBookcontroller());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          top: Get.width * 0.05,
          bottom: Get.width * 0.04,
        ),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Center(
                child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Lottie.asset(
                      'assets/lottie/book_loading.json',
                      fit: BoxFit.contain,
                      delegates: LottieDelegates(
                        values: [
                          ValueDelegate.color(const ['**'], value: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          if (!controller.hasLoaded.value || controller.isLoading.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 100),
              child: Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'assets/lottie/book_loading.json',
                    fit: BoxFit.contain,
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(const ['**'], value: Colors.red),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (controller.workbooks
              .where((wb) => wb.isEnabled == true)
              .isEmpty) {
            return const Center(child: Text('No data founds.'));
          }

          final Map<String, List<Workbooks>> categoryMap = {};
          for (final wb in controller.workbooks.where(
            (wb) => wb.isEnabled == true,
          )) {
            final mainCat = wb.mainCategory ?? 'Other';
            categoryMap.putIfAbsent(mainCat, () => <Workbooks>[]).add(wb);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchWorkbookData();
              await controller.fetchHomePageAdds();
              await controller.fetchPopularReels();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.width * 0.02),
                  Obx(() {
                    final enabledHighlightedBooks =
                        controller.highlightedBooks
                            .where((wb) => wb.isEnabled == true)
                            .toList();
                    return enabledHighlightedBooks.isEmpty
                        ? const Center(child: Text("No data"))
                        : CarouselSlider.builder(
                          itemCount: enabledHighlightedBooks.length,
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 16 / 14,
                            viewportFraction: 0.7,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration: const Duration(
                              milliseconds: 800,
                            ),
                            pauseAutoPlayOnTouch: true,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final book = enabledHighlightedBooks[index];
                            return InkWell(
                              onTap:
                                  () => Get.to(
                                    () =>
                                        WorkBookDetailesPage(bookId: book.sId),
                                  ),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: book.coverImageUrl ?? '',
                                        fit: BoxFit.fill,
                                        width: double.infinity,
                                        errorWidget:
                                            (context, url, error) => Container(
                                              color: Colors.grey[200],
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.menu_book_rounded,
                                                color: Colors.grey,
                                              ),
                                            ),
                                        placeholder:
                                            (context, url) => Center(
                                              child: Image.asset(
                                                "assets/images/mains-logo.png",
                                              ),
                                            ),
                                      ),
                                    ),
                                    // Paid indicator - only show when isPaid is true
                                    if (book.isEnrolled == true)
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.3,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'ENROLLED',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    else if ((book.isEnrolled != true) &&
                                        (book.isPaid == true))
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.3,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            'PAID',
                                            style: GoogleFonts.poppins(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, left: 16),
                    child: Text(
                      'Trending Now',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: Obx(
                      () => ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.trendingBooks.length,
                        itemBuilder: (context, index) {
                          final book = controller.trendingBooks[index];
                          return InkWell(
                            onTap:
                                () => Get.to(
                                  () => WorkBookDetailesPage(bookId: book.sId),
                                ),
                            child: Container(
                              width: Get.width * 0.3,
                              height: Get.width * 0.8,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: book.coverImageUrl ?? '',
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      placeholder:
                                          (context, url) => Center(
                                            child: Image.asset(
                                              "assets/images/mains-logo.png",
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: Colors.grey[200],
                                            alignment: Alignment.center,
                                            child: const Icon(
                                              Icons.menu_book_rounded,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          ),
                                    ),
                                  ),
                                  if (book.isEnrolled == true)
                                    Positioned(
                                      bottom: 18,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'ENROLLED',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  else if ((book.isEnrolled != true) &&
                                      (book.isPaid == true))
                                    Positioned(
                                      bottom: 18,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.3,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'PAID',
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // TOP BANNER (location: 'top')
                  Obx(() {
                    final items = controller.adsByLocation['top'] ?? [];
                    if (items.isEmpty) return const SizedBox.shrink();

                    final urls =
                        items
                            .map((ad) => ad.imageUrl)
                            .where((url) => url != null)
                            .map((url) => url!)
                            .toList();

                    return AdsCarousel(
                      imageUrls: urls,
                      height: 150,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    );
                  }),
                  _buildSectionTitle('Tips'),

                  _buildTipsSection(),
                  SizedBox(height: Get.width * 0.05),
                  Obx(() {
                    final items = controller.adsByLocation['middle'] ?? [];
                    if (items.isEmpty) return const SizedBox.shrink();

                    final urls =
                        items
                            .map((ad) => ad.imageUrl)
                            .where((url) => url != null)
                            .map((url) => url!)
                            .toList();

                    return AdsCarousel(
                      imageUrls: urls,
                      height: 150,
                      borderRadius: 12,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    );
                  }),
                  Padding(
                    padding: EdgeInsets.only(
                      left: Get.width * 0.05,
                      right: Get.width * 0.05,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), //
                      children:
                          categoryMap.entries.map((entry) {
                            final mainCategory = entry.key;
                            final workbooks = entry.value;
                            final subCategories =
                                workbooks
                                    .map((w) => w.subCategory ?? 'Other')
                                    .toSet()
                                    .toList();

                            controller.expandedCategories.putIfAbsent(
                              mainCategory,
                              () => subCategories.first,
                            );

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    mainCategory,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Get.width * 0.03,
                                  ),
                                  child: Container(
                                    height: Get.width * 0.1,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      itemCount: subCategories.length,
                                      itemBuilder: (context, subIndex) {
                                        final subCategory =
                                            subCategories[subIndex];
                                        final isSelected =
                                            controller
                                                .expandedCategories[mainCategory] ==
                                            subCategory;

                                        return GestureDetector(
                                          onTap:
                                              () => controller.updateSelection(
                                                mainCategory,
                                                subCategory,
                                              ),
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  isSelected
                                                      ? Colors.blue
                                                      : Colors.grey.shade200,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Center(
                                              child: Text(
                                                subCategory,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  color:
                                                      isSelected
                                                          ? Colors.white
                                                          : Colors
                                                              .grey
                                                              .shade800,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Obx(() {
                                  final selected =
                                      controller
                                          .expandedCategories[mainCategory];
                                  final filteredBooks =
                                      workbooks
                                          .where(
                                            (b) =>
                                                (b.subCategory ?? 'Other') ==
                                                selected,
                                          )
                                          .toList();

                                  if (filteredBooks.isEmpty) {
                                    return const Padding(
                                      padding: EdgeInsets.all(12),
                                      child: Text(
                                        "No books available in this subcategory",
                                      ),
                                    );
                                  }

                                  final showMore = filteredBooks.length > 5;
                                  final displayBooks =
                                      showMore
                                          ? filteredBooks.take(5).toList()
                                          : filteredBooks;

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: GridView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          showMore
                                              ? displayBooks.length + 1
                                              : displayBooks.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 12,
                                            childAspectRatio: 0.68,
                                          ),
                                      itemBuilder: (context, index) {
                                        if (showMore &&
                                            index == displayBooks.length) {
                                          final bgImages =
                                              displayBooks.take(4).toList();
                                          return InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => WorkBookCategoryPage(
                                                  mainCategory: mainCategory,
                                                  subCategory: selected!,
                                                  books: filteredBooks,
                                                ),
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              child: Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  // Background images in 2x2 grid
                                                  ...List.generate(bgImages.length, (
                                                    i,
                                                  ) {
                                                    return Positioned(
                                                      left:
                                                          (i % 2) *
                                                          (Get.width * 0.15),
                                                      top:
                                                          (i ~/ 2) *
                                                          (Get.width * 0.275),
                                                      width: Get.width * 0.15,
                                                      height: Get.width * 0.275,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              4,
                                                            ),
                                                        child:
                                                            bgImages[i].coverImageUrl !=
                                                                        null &&
                                                                    bgImages[i]
                                                                        .coverImageUrl!
                                                                        .isNotEmpty
                                                                ? CachedNetworkImage(
                                                                  imageUrl:
                                                                      bgImages[i]
                                                                          .coverImageUrl!,
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                )
                                                                : Image.asset(
                                                                  "assets/images/nophoto.png",
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                ),
                                                      ),
                                                    );
                                                  }),
                                                  // Overlay for darkening the background
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                  ),
                                                  // Centered See More text
                                                  Center(
                                                    child: Text(
                                                      "See More",
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }

                                        final book = displayBooks[index];
                                        return _buildImageBox(
                                          book,
                                          height: Get.width * 0.55,
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                  Obx(() {
                    final items = controller.adsByLocation['bottom'] ?? [];
                    if (items.isEmpty) return const SizedBox.shrink();

                    final urls =
                        items
                            .map((ad) => ad.imageUrl)
                            .where((url) => url != null)
                            .map((url) => url!)
                            .toList();

                    return AdsCarousel(
                      imageUrls: urls,
                      height: 150,
                      borderRadius: 12,
                      //padding: const EdgeInsets.symmetric(horizontal: 12),
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImageBox(Workbooks book, {double height = 200}) {
    return InkWell(
      onTap: () => Get.to(() => WorkBookDetailesPage(bookId: book.sId)),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child:
                  book.coverImageUrl == null || book.coverImageUrl!.isEmpty
                      ? Center(
                        child: Image.asset(
                          "assets/images/nophoto.png",
                          fit: BoxFit.contain,
                          height: 60,
                        ),
                      )
                      : CachedNetworkImage(
                        imageUrl: book.coverImageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder:
                            (context, url) => Center(
                              child: Image.asset(
                                "assets/images/mains-logo.png",
                                fit: BoxFit.contain,
                                height: 50,
                              ),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              color: Colors.grey[200],
                              child: Center(
                                child: Image.asset(
                                  "assets/images/nophoto.png",
                                  fit: BoxFit.contain,
                                  height: 60,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
            ),
            // Paid indicator - only show when isPaid is true
            if (book.isEnrolled == true)
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'ENROLLED',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else if ((book.isEnrolled != true) && (book.isPaid == true))
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'PAID',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection() {
    return SizedBox(
      height: 180,
      child: Obx(() {
        final reels = controller.reels;
        if (reels.isEmpty) {
          return const Center(child: Text('No reels'));
        }

        final displayReels = reels.length > 3 ? reels.sublist(0, 3) : reels;

        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: displayReels.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final reel = displayReels[index];
            String? thumbnailUrl;

            if (reel.youtubeId != null && reel.youtubeId!.isNotEmpty) {
              // 👇 YouTube thumbnail
              thumbnailUrl =
                  "https://img.youtube.com/vi/${reel.youtubeId}/hqdefault.jpg";
            }
            // } else if (reel.thumbnailUrl != null &&
            //     reel.thumbnailUrl!.isNotEmpty) {
            //   // 👇 Use API-provided thumbnail if available
            //   thumbnailUrl = reel.thumbnailUrl;
            // }

            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.reels);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 120,
                  height: 180,
                  color: Colors.black12,
                  child:
                      thumbnailUrl != null
                          ? Image.network(
                            thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          )
                          : const Icon(Icons.play_circle_fill, size: 48),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue[900],
      ),
    ),
  );
}
