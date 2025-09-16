import 'package:mains/common/utils.dart';
import '../../app_imports.dart';
import '../compelete_book/categorical_book_data.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late HomeScreenController controller;
  late TabController _tabController;

  @override
  void initState() {
    controller = Get.put(HomeScreenController());

    int initialTabIndex = 0;

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      initialTabIndex = args['tabIndex'] ?? 0;
    }

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: initialTabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final tabControllerManager = Get.find<TabControllerManager>();
        tabControllerManager.setTabController(_tabController);
        tabControllerManager.setIndex(initialTabIndex);
        tabControllerManager.animateTo(initialTabIndex);
      } catch (e) {}
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: CustomTabBar(tabController: _tabController),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              const WorkBookBookPage(),
              AiTestHome(),
              Obx(() {
                if (controller.isLoading.value || !controller.hasLoaded.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && !(Get.isDialogOpen ?? false)) {
                      showLogoLoadingDialog();
                    }
                  });
                  return const SizedBox.shrink();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted && (Get.isDialogOpen ?? false)) {
                      Get.back();
                    }
                  });
                  return RefreshIndicator(
                    onRefresh: () async {
                      await controller.dashBoardData(forceRefresh: true);
                    },
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: Get.width * 0.05),
                            Obx(() {
                              if (controller.isLoading.value ||
                                  !controller.hasLoaded.value) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final enabledHighlightedBooks =
                                  controller.highlightedBooks
                                      .where((book) => book.isEnabled == true)
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
                                      autoPlayInterval: const Duration(
                                        seconds: 3,
                                      ),
                                      autoPlayAnimationDuration: const Duration(
                                        milliseconds: 800,
                                      ),
                                      pauseAutoPlayOnTouch: true,
                                    ),
                                    itemBuilder: (context, index, realIndex) {
                                      final book =
                                          enabledHighlightedBooks[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.to(
                                            () => BookDetailsPage(
                                              bookId: book.bookId ?? '',
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl:
                                                      book.image_url ?? '',
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  errorWidget:
                                                      (
                                                        context,
                                                        url,
                                                        error,
                                                      ) => Container(
                                                        color: Colors.grey[200],
                                                        alignment:
                                                            Alignment.center,
                                                        child: const Icon(
                                                          Icons
                                                              .menu_book_rounded,
                                                          color: Colors.grey,
                                                          size: 50,
                                                        ),
                                                      ),
                                                  placeholder:
                                                      (context, url) => Center(
                                                        child: Image.asset(
                                                          "assets/images/mains-logo.png",
                                                        ),
                                                      ),
                                                ),
                                                // Paid/Enrolled indicator
                                                if ((book as dynamic)
                                                        .isEnrolled ==
                                                    true)
                                                  Positioned(
                                                    bottom: 8,
                                                    left: 8,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        'ENROLLED',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  )
                                                else if (book.isPaid == true)
                                                  Positioned(
                                                    bottom: 8,
                                                    left: 8,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withValues(
                                                                  alpha: 0.3,
                                                                ),
                                                            blurRadius: 4,
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  2,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Text(
                                                        'PAID',
                                                        style:
                                                            GoogleFonts.poppins(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 16, left: 16),
                              child: Utils.primaryText(
                                text: 'Trending Now',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.blue[900]!,
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              child: Obx(() {
                                if (controller.isLoading.value ||
                                    !controller.hasLoaded.value) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                final enabledTrendingBooks =
                                    controller.trendingBooks
                                        .where((book) => book.isEnabled == true)
                                        .toList();
                                return ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: enabledTrendingBooks.length,
                                  itemBuilder: (context, index) {
                                    final book = enabledTrendingBooks[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(
                                          () => BookDetailsPage(
                                            bookId: book.bookId ?? '',
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: Get.width * 0.3,
                                        height: Get.width * 0.8,
                                        margin: const EdgeInsets.only(
                                          right: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          child: Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              CachedNetworkImage(
                                                imageUrl: book.image_url ?? '',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                placeholder:
                                                    (context, url) => Center(
                                                      child: Image.asset(
                                                        "assets/images/mains-logo.png",
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => Container(
                                                      color: Colors.grey[200],
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Icon(
                                                        Icons.menu_book_rounded,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    ),
                                              ),
                                              // Paid indicator - only show when isPaid is true
                                              if ((book as dynamic)
                                                          .isEnrolled ==
                                                      true ||
                                                  book.isPaid == true)
                                                Positioned(
                                                  bottom: 8,
                                                  left: 8,
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ((book as dynamic)
                                                                      .isEnrolled ==
                                                                  true)
                                                              ? Colors.green
                                                              : Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withValues(
                                                                alpha: 0.3,
                                                              ),
                                                          blurRadius: 4,
                                                          offset: const Offset(
                                                            0,
                                                            2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Text(
                                                      ((book as dynamic)
                                                                  .isEnrolled ==
                                                              true)
                                                          ? 'ENROLLED'
                                                          : 'PAID',
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Obx(() {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: controller.categories.length,
                                    itemBuilder: (context, categoryIndex) {
                                      final category =
                                          controller.categories[categoryIndex];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              category.category ?? '',
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue[900],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: Get.width * 0.1,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                  ),
                                              itemCount:
                                                  category
                                                      .subCategories
                                                      ?.length ??
                                                  0,
                                              itemBuilder: (context, subIndex) {
                                                final subCategory =
                                                    category
                                                        .subCategories![subIndex];
                                                return Obx(() {
                                                  final isSelected =
                                                      controller
                                                          .expandedCategories[category
                                                          .category] ==
                                                      subCategory.name;
                                                  return GestureDetector(
                                                    onTap:
                                                        () => controller
                                                            .updateSelection(
                                                              category.category ??
                                                                  '',
                                                              subCategory
                                                                      .name ??
                                                                  '',
                                                            ),
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            right: 12,
                                                            left: 10,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            isSelected
                                                                ? Colors.blue
                                                                : Colors
                                                                    .grey[200],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          subCategory.name ??
                                                              '',
                                                          style: GoogleFonts.poppins(
                                                            fontSize: 12,
                                                            color:
                                                                isSelected
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .grey[800],
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                          Obx(() {
                                            final expandedSubCategory =
                                                controller
                                                    .expandedCategories[category
                                                    .category];
                                            if (expandedSubCategory != null &&
                                                expandedSubCategory
                                                    .isNotEmpty) {
                                              final books =
                                                  (controller.getBooksForSubCategory(
                                                            category.category ??
                                                                '',
                                                            expandedSubCategory,
                                                          ) ??
                                                          [])
                                                      .where(
                                                        (book) =>
                                                            book.isEnabled ==
                                                            true,
                                                      )
                                                      .toList();
                                              if (books.isEmpty) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Text(
                                                    'No books available in this subcategory',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return Padding(
                                                padding: const EdgeInsets.all(
                                                  12,
                                                ),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 0.72,
                                                        crossAxisSpacing: 3,
                                                        mainAxisSpacing: 6,
                                                      ),
                                                  itemCount:
                                                      books.length > 4
                                                          ? 6
                                                          : books.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    if (books.length > 4 &&
                                                        index == 5) {
                                                      final extraBooks = books
                                                          .sublist(
                                                            0,
                                                            books.length >= 4
                                                                ? 4
                                                                : books.length,
                                                          );
                                                      return GestureDetector(
                                                        onTap: () {
                                                          Get.to(
                                                            () => CategoricalBookData(
                                                              category:
                                                                  category
                                                                      .category ??
                                                                  '',
                                                              subCategory:
                                                                  controller
                                                                      .expandedCategories[category
                                                                      .category] ??
                                                                  '',
                                                            ),
                                                          );
                                                        },
                                                        child: Center(
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                              border: Border.all(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                            width:
                                                                Get.width * 0.3,
                                                            height:
                                                                Get.width * 0.8,
                                                            child: Stack(
                                                              children: [
                                                                Positioned.fill(
                                                                  child: Padding(
                                                                    padding:
                                                                        const EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              8,
                                                                        ),
                                                                    child: GridView.builder(
                                                                      physics:
                                                                          const NeverScrollableScrollPhysics(),
                                                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                                        crossAxisCount:
                                                                            2,
                                                                        crossAxisSpacing:
                                                                            4,
                                                                        mainAxisSpacing:
                                                                            4,
                                                                        childAspectRatio:
                                                                            0.7,
                                                                      ),
                                                                      itemCount:
                                                                          extraBooks
                                                                              .length,
                                                                      itemBuilder: (
                                                                        context,
                                                                        i,
                                                                      ) {
                                                                        final img =
                                                                            extraBooks[i].image_url ??
                                                                            '';
                                                                        return Padding(
                                                                          padding: EdgeInsets.only(
                                                                            top:
                                                                                Get.width *
                                                                                0.02,
                                                                          ),
                                                                          child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(
                                                                              6,
                                                                            ),
                                                                            child:
                                                                                img.isEmpty
                                                                                    ? Image.asset(
                                                                                      "assets/images/nophoto.png",
                                                                                      fit:
                                                                                          BoxFit.cover,
                                                                                    )
                                                                                    : CachedNetworkImage(
                                                                                      imageUrl:
                                                                                          img,
                                                                                      fit:
                                                                                          BoxFit.cover,
                                                                                      placeholder:
                                                                                          (
                                                                                            context,
                                                                                            url,
                                                                                          ) => Container(
                                                                                            color:
                                                                                                Colors.grey[200],
                                                                                          ),
                                                                                      errorWidget:
                                                                                          (
                                                                                            context,
                                                                                            url,
                                                                                            error,
                                                                                          ) => Image.asset(
                                                                                            "assets/images/nophoto.png",
                                                                                            fit:
                                                                                                BoxFit.cover,
                                                                                          ),
                                                                                    ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 5,
                                                                  left: 0,
                                                                  right: 0,
                                                                  child: Center(
                                                                    child: Text(
                                                                      "Tap to see more",
                                                                      style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            Colors.blue[900],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                    final book = books[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                          () => BookDetailsPage(
                                                            bookId:
                                                                book.bookId ??
                                                                '',
                                                          ),
                                                        );
                                                      },
                                                      child: Container(
                                                        width: Get.width,
                                                        height: Get.width * 0.8,
                                                        margin:
                                                            const EdgeInsets.only(
                                                              right: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                6,
                                                              ),
                                                          child: Stack(
                                                            fit:
                                                                StackFit.expand,
                                                            children: [
                                                              book.image_url ==
                                                                      null
                                                                  ? Center(
                                                                    child: Image.asset(
                                                                      "assets/images/nophoto.png",
                                                                      fit:
                                                                          BoxFit
                                                                              .contain,
                                                                      height:
                                                                          60,
                                                                    ),
                                                                  )
                                                                  : CachedNetworkImage(
                                                                    imageUrl:
                                                                        book.image_url ??
                                                                        '',
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    placeholder:
                                                                        (
                                                                          context,
                                                                          url,
                                                                        ) => Center(
                                                                          child: Image.asset(
                                                                            "assets/images/mains-logo.png",
                                                                          ),
                                                                        ),
                                                                    errorWidget:
                                                                        (
                                                                          context,
                                                                          url,
                                                                          error,
                                                                        ) => Container(
                                                                          color:
                                                                              Colors.grey[200],
                                                                          child: Center(
                                                                            child: Image.asset(
                                                                              "assets/images/nophoto.png",
                                                                              fit:
                                                                                  BoxFit.contain,
                                                                              height:
                                                                                  60,
                                                                              color:
                                                                                  Colors.grey,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  ),

                                                              if ((book as dynamic)
                                                                          .isEnrolled ==
                                                                      true ||
                                                                  book.isPaid == true)
                                                                Positioned(
                                                                  bottom: 8,
                                                                  left: 8,
                                                                  child: Container(
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                      color:
                                                                          ((book
                                                                                          as dynamic)
                                                                                      .isEnrolled ==
                                                                                  true)
                                                                              ? Colors.green
                                                                              : Colors.red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors.black.withValues(
                                                                            alpha:
                                                                                0.3,
                                                                          ),
                                                                          blurRadius:
                                                                              4,
                                                                          offset: const Offset(
                                                                            0,
                                                                            2,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    child: Text(
                                                                      ((book
                                                                                      as dynamic)
                                                                                  .isEnrolled ==
                                                                              true)
                                                                          ? 'ENROLLED'
                                                                          : 'PAID',
                                                                      style: GoogleFonts.poppins(
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          }),
                                        ],
                                      );
                                    },
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
