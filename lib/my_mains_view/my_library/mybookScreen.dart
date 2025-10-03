import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:mains/app_routes.dart';
import 'package:mains/my_mains_view/bottomBar/controller.dart';
import 'package:mains/my_mains_view/workBook/work_book_detailes/work_book_detailes_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/colors.dart';
import '../../common/shred_pref.dart';
import 'controller.dart';
import '../../models/my_workBook_List.dart';

class MyLibraryView extends StatefulWidget {
  final int? initialTabIndex;
  const MyLibraryView({super.key, this.initialTabIndex = 0});

  @override
  State<MyLibraryView> createState() => _MyLibraryViewState();
}

class _MyLibraryViewState extends State<MyLibraryView> {
  late final MyLibraryController controller;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<MyLibraryController>()) {
      Get.put(MyLibraryController());
    }
    controller = Get.find<MyLibraryController>();

    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() => _isScrollingDown = true);
        }
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() => _isScrollingDown = false);
        }
      }
    });
    controller.getworkbooks();
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "My Library",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),

        // 👇 Add to Cart Icon
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 26,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.toNamed(AppRoutes.addToCart);
                    },
                  ),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: FutureBuilder<SharedPreferences>(
                    future: SharedPreferences.getInstance(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.shrink();

                      final prefs = snapshot.data!;
                      final cartCount = prefs.getInt(Constants.cartCount) ?? 0;

                      if (cartCount == 0) return const SizedBox.shrink();

                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$cartCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.getworkbooks(),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: 8)),
              _buildWorkbookList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenteredMessage({
    required String imagePath,
    required String message,
    Color color = Colors.black54,
    VoidCallback? onAddNow,
  }) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(imagePath, height: 100),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.poppins(fontSize: 14, color: color),
              textAlign: TextAlign.center,
            ),
            if (onAddNow != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                label: Text("Add Now"),
                onPressed: () {
                  Get.find<BottomNavController>().changeIndex(0);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWorkbookList() {
    return Obx(() {
      if (controller.isLoading.value && controller.MyWorkBookLists.isEmpty) {
        return SliverFillRemaining(
          hasScrollBody: false,
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

      if (controller.MyWorkBookLists.isEmpty) {
        return _buildCenteredMessage(
          imagePath: "assets/images/loadingBooks.png",
          message: "No Workbooks Found",
          onAddNow: () => controller.getworkbooks(),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final workbook = controller.MyWorkBookLists[index];
          return _buildWorkbookItem(workbook, index);
        }, childCount: controller.MyWorkBookLists.length),
      );
    });
  }

  Widget _buildWorkbookItem(Workbooks workbook, int index) {
    final String key =
        workbook.workbookId ??
        workbook.myWorkbookId ??
        '${workbook.title}-${index}';
    final String description = (workbook.description ?? '').trim();
    final bool showToggle = description.length > 120;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Get.to(() => WorkBookDetailesPage(bookId: workbook.workbookId));
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      workbook.coverImageUrl ?? workbook.coverImage ?? '',
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.book,
                            size: 40,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workbook.title ?? 'No Title',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // Pricing
                        if (workbook.offerPrice != null ||
                            workbook.MRP != null) ...[
                          const SizedBox(height: 6),
                          Builder(
                            builder: (context) {
                              final String currencySymbol =
                                  (workbook.currency != null &&
                                          workbook.currency!.isNotEmpty)
                                      ? workbook.currency!
                                      : '₹';
                              final num? offer = workbook.offerPrice;
                              final num? mrp = workbook.MRP;
                              final bool hasOffer = offer != null && offer > 0;
                              final bool hasMrp = mrp != null && mrp > 0;
                              return Row(
                                children: [
                                  if (hasOffer)
                                    Text(
                                      "$currencySymbol${offer.toStringAsFixed(0)}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.green[700],
                                      ),
                                    ),
                                  if (hasOffer && hasMrp)
                                    const SizedBox(width: 8),
                                  if (hasMrp)
                                    Text(
                                      "$currencySymbol${mrp.toStringAsFixed(0)}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey,
                                        decoration:
                                            hasOffer
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ],
                        if (workbook.rating != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[700],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                workbook.rating!.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (description.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Obx(() {
                            final bool isExpanded = controller.isDescExpanded(
                              key,
                            );
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  description,
                                  maxLines: isExpanded ? null : 2,
                                  overflow:
                                      isExpanded
                                          ? TextOverflow.visible
                                          : TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                if (showToggle)
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed:
                                        () =>
                                            controller.toggleDescExpanded(key),
                                    child: Text(
                                      isExpanded ? 'See less' : 'See more',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                        Row(
                          children: [
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text(
                                      'Remove My Book',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    content: Text(
                                      'Are you sure you want to remove this book from your library?',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                          if (workbook.workbookId != null) {
                                            controller.deletWorkeBook(
                                              workbook.workbookId!,
                                            );
                                          }
                                        },
                                        child: Text(
                                          'Remove',
                                          style: GoogleFonts.poppins(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.more_vert,
                                color: Colors.deepOrange,
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
        ),
      ),
    );
  }
}
