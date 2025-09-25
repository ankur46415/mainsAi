import 'package:mains/app_imports.dart';
import 'package:mains/models/workBookBookDetailes.dart';
import 'package:mains/my_mains_view/my_library/controller.dart';

class WorkBookDetailesPage extends StatefulWidget {
  final String? bookId;
  const WorkBookDetailesPage({super.key, this.bookId});

  @override
  State<WorkBookDetailesPage> createState() => _WorkBookDetailesPageState();
}

class _WorkBookDetailesPageState extends State<WorkBookDetailesPage> {
  late WorkBookBOOKDetailes controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    controller = Get.put(WorkBookBOOKDetailes());
    if (widget.bookId != null) {
      controller.fetchWorkbookDetails(widget.bookId!);
    } else {
      Get.snackbar('Error', 'No Book ID found');
    }
    super.initState();
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
        if (controller.isLoading.value) {
          return Center(
            child: Padding(
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
            ),
          );
        }

        final bookData = controller.workbook.value;
        if (bookData == null) {
          return const Center(child: Text("No Data Found..."));
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
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
                    backgroundColor: Colors.black.withValues(alpha: 0.4),
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
                                    imageUrl: bookData.coverImageUrl ?? '',
                                    fit: BoxFit.fill,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.red,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) => Image.asset(
                                          'assets/images/allbook.png',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (bookData.isEnrolled == true) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'ENROLLED',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ] else if ((bookData.isEnrolled != true) &&
                              (bookData.isForSale == true)) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if ((bookData.mrp ?? 0) > 0 &&
                                      (bookData.offerPrice ?? 0) > 0) ...[
                                    Text(
                                      '₹ ${bookData.mrp}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Text(
                                    (bookData.offerPrice != null &&
                                            bookData.offerPrice! > 0)
                                        ? '₹ ${bookData.offerPrice}'
                                        : 'PAID',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (bookData.isForSale == true) ...[
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    (bookData.countOfCartItems != null &&
                                            bookData.isInCart == true)
                                        ? Colors.green
                                        : Colors.orange,
                                borderRadius: BorderRadius.circular(25),
                              ),

                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.addToCart);
                                    },
                                    borderRadius: BorderRadius.circular(25),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          const Icon(
                                            Icons.shopping_cart_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          Positioned(
                                            right: -6,
                                            top: -6,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                "${bookData.countOfCartItems}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Divider
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: Colors.white.withOpacity(0.7),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                  ),
                                  (bookData.countOfCartItems != null &&
                                          bookData.isInCart == true)
                                      ? InkWell(
                                        onTap: () {
                                          controller.deleteCartItem(
                                            widget.bookId?.toString() ?? '',
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.remove,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                      : InkWell(
                                        onTap: () {
                                          controller.addWorkbookToCart(
                                            widget.bookId?.toString() ?? '',
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(25),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      _buildBookInfoCard(bookData),
                      const SizedBox(height: 8),
                      _buildStatsCard(),
                      const SizedBox(height: 16),
                      _buildActionButtons(bookData),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: Get.width,
                        child: Card(
                          elevation: 4,
                          color: const Color.fromARGB(255, 146, 169, 233),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookData.title ?? '',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.library_books_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Total Sets: ${controller.workbookDetailes.value?.sets?.length ?? 0}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.question_answer_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Total Questions: ${controller.workbookDetailes.value?.totalQuestionsCount ?? 0}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Obx(() {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Get.width * 0.05),
                          child: Column(
                            children:
                                controller.sets.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final set = entry.value;
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 6,
                                      horizontal: 4,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 18,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        110,
                                        179,
                                        243,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Get.toNamed(
                                          AppRoutes.allWorkbookquestions,
                                          arguments: {
                                            'sid': set.sId,
                                            'bookId': widget.bookId,
                                            'imageUrl':
                                                bookData.coverImageUrl ?? '',
                                            'title': bookData.title ?? '',
                                          },
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${index + 1} - ${set.name ?? ""}",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                '${set.questions?.length ?? 0}',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                'Questions',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                        );
                      }),
                      SizedBox(height: Get.width * 0.1),
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

  Widget _buildBookInfoCard(Workbook bookData) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            bookData.title ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: Get.width * 0.01),
          Text(
            '${bookData.subject ?? ''} | ${bookData.paper ?? ''}, ${bookData.exam ?? ''}',
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

  Widget _buildRatingRow(Workbook bookData) {
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

  Widget _buildMetaDataRow(Workbook bookData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMetaDataItem(
          label: 'Creator',
          value: bookData.author ?? 'Unknown',
        ),
        _buildMetaDataItem(
          label: 'Institution',
          value: bookData.publisher ?? 'Unknown',
        ),
        _buildMetaDataItem(
          label: 'Language',
          value: bookData.language ?? 'Unknown',
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
            color: Colors.black.withValues(alpha: 0.1),
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
            label: 'Total Submissions',
            value:
                '${controller.workbookDetailes.value?.totalQuestionsCount ?? 0}',
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

  Widget _buildActionButtons(Workbook bookData) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              final bool isEnrolled = bookData.isEnrolled == true;
              final bool isForSale = bookData.isForSale == true;
              final bool showPurchase = isForSale && !isEnrolled;

              if (showPurchase) {
                final success = await controller.addWorkbookToCart(
                  widget.bookId?.toString() ?? '',
                );
                if (success) Get.toNamed(AppRoutes.addToCart);
              } else if (controller.isSaved == true ||
                  controller.isActionLoading.value) {
                if (!Get.isRegistered<MyLibraryController>()) {
                  Get.put(MyLibraryController(), permanent: true);
                }

                final myLibraryController = Get.find<MyLibraryController>();
                myLibraryController.loadBooks();

                final bottomNavController = Get.find<BottomNavController>();
                bottomNavController.changeIndex(1);
                Get.offAll(() => MyHomePage());
              } else {
                controller.addToMyBooks(widget.bookId.toString());
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  bookData.isForSale == true
                      ? Colors.orange
                      : bookData.isMyWorkbookAdded == true
                      ? Colors.green
                      : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child:
                controller.isActionLoading.value
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                    : Text(
                      bookData.isForSale == true
                          ? 'Purchase Book'
                          : bookData.isMyWorkbookAdded == true
                          ? 'Go to My Library'
                          : 'Add to My Library',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
          ),
        ),
      ],
    );
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
}
