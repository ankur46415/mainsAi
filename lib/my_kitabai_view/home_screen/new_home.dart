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
                if (controller.isLoading.value) {
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
                            Obx(
                              () =>
                                  controller.highlightedBooks.isEmpty
                                      ? const Center(child: Text("No data"))
                                      : CarouselSlider.builder(
                                        itemCount:
                                            controller.highlightedBooks.length,
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          enlargeCenterPage: true,
                                          aspectRatio: 16 / 14,
                                          viewportFraction: 0.7,
                                          autoPlayInterval: const Duration(
                                            seconds: 3,
                                          ),
                                          autoPlayAnimationDuration:
                                              const Duration(milliseconds: 800),
                                          pauseAutoPlayOnTouch: true,
                                        ),
                                        itemBuilder: (
                                          context,
                                          index,
                                          realIndex,
                                        ) {
                                          final book =
                                              controller
                                                  .highlightedBooks[index];
                                          return InkWell(
                                            onTap: () {
                                              Get.to(
                                                () => BookDetailsPage(
                                                  bookId: book.bookId ?? '',
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 3,
                                                  ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
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
                              child: Utils.primaryText(
                                text: 'Trending Now',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.blue[900]!,
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
                                    final book =
                                        controller.trendingBooks[index];
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
                                          child: CachedNetworkImage(
                                            imageUrl: book.image_url ?? '',
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                            placeholder:
                                                (context, url) => Center(
                                                  child: Image.asset(
                                                    "assets/images/mains-logo.png",
                                                  ),
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.grey[200],
                                                      alignment:
                                                          Alignment.center,
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
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade300,
                                    Colors.deepOrange.shade400,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.local_offer,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Special Offer!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          'Get 50% off on premium courses!',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.9,
                                            ),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.asset(
                                  'assets/images/addpromo2.png',
                                ),
                              ),
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
                                              final books = controller
                                                  .getBooksForSubCategory(
                                                    category.category ?? '',
                                                    expandedSubCategory,
                                                  );
                                              if (books == null ||
                                                  books.isEmpty) {
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
                                                          child:
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
                                                                            .fill,
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
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/images/bot11.gif',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 3,
                                    right: 7,
                                    child: Container(
                                      color: Colors.white,
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Text(
                                          'mains',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1, 1),
                                                blurRadius: 3,
                                                color: Colors.black54,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
