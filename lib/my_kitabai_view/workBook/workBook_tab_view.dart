import 'package:mains/app_imports.dart';
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
        padding: const EdgeInsets.all(16),
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

          if (controller.workbooks.isEmpty) {
            return const Center(child: Text('No data found.'));
          }

          final Map<String, List<Workbooks>> categoryMap = {};
          for (final wb in controller.workbooks) {
            final mainCat = wb.mainCategory ?? 'Other';
            categoryMap.putIfAbsent(mainCat, () => <Workbooks>[]).add(wb);
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchWorkbookData();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () =>
                        controller.highlightedBooks.isEmpty
                            ? const Center(child: Text("No data"))
                            : CarouselSlider.builder(
                              itemCount: controller.highlightedBooks.length,
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
                                final book = controller.highlightedBooks[index];
                                return InkWell(
                                  onTap:
                                      () => Get.to(
                                        () => WorkBookDetailesPage(
                                          bookId: book.sId,
                                        ),
                                      ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    child: ClipRRect(
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
                                                Icons.broken_image,
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
                                  ),
                                );
                              },
                            ),
                  ),
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
                              child: ClipRRect(
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
                                          Icons.broken_image,
                                          color: Colors.grey,
                                          size: 40,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  ListView(
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

                          final selectedSub =
                              controller.expandedCategories[mainCategory];

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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              subCategory,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                color:
                                                    isSelected
                                                        ? Colors.white
                                                        : Colors.grey.shade800,
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
                                final selected = controller.expandedCategories[mainCategory];
                                final filteredBooks = workbooks
                                    .where((b) => (b.subCategory ?? 'Other') == selected)
                                    .toList();

                                if (filteredBooks.isEmpty) {
                                  return const Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Text("No books available in this subcategory"),
                                  );
                                }

                                // Limit to 5 + 1 "See More" card
                                final showMore = filteredBooks.length > 5;
                                final displayBooks = showMore ? filteredBooks.take(5).toList() : filteredBooks;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: showMore ? displayBooks.length + 1 : displayBooks.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 0.68,
                                    ),
                                    itemBuilder: (context, index) {
                                      if (showMore && index == displayBooks.length) {
                                        // Last card = See More
                                        return InkWell(
                                          onTap: () {
                                            Get.to(() => WorkBookCategoryPage(
                                              mainCategory: mainCategory,
                                              subCategory: selected!,
                                              books: filteredBooks,
                                            ));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.blue),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "See More",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[900],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }

                                      final book = displayBooks[index];
                                      return _buildImageBox(book, height: Get.width * 0.55);
                                    },
                                  ),
                                );
                              }),

                            ],
                          );
                        }).toList(),
                  ),
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
        child: ClipRRect(
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
                    fit: BoxFit.fill,
                    width: double.infinity,
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
      ),
    );
  }
}
