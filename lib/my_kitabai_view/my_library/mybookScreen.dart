import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:mains/my_kitabai_view/bottomBar/controller.dart';
import 'package:mains/my_kitabai_view/book_detailes_page/booking_details_page/bookdetails_page.dart';
import 'package:mains/my_kitabai_view/workBook/work_book_detailes/work_book_detailes_page.dart';
import 'package:lottie/lottie.dart';
import '../../common/colors.dart';
import '../../model/book_model.dart';
import 'controller.dart';
import '../../model/my_workBook_List.dart';

class MyLibraryView extends StatefulWidget {
  final int? initialTabIndex;
  const MyLibraryView({super.key, this.initialTabIndex = 0});

  @override
  State<MyLibraryView> createState() => _MyLibraryViewState();
}

class _MyLibraryViewState extends State<MyLibraryView>
    with SingleTickerProviderStateMixin {
  late final MyLibraryController controller;
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrollingDown = false;

  final List<String> tabTitles = [
    "AI Books",
    "AI WorkBook",
    "AI Test",
    "AI Courses",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
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
    controller.loadBooks();
    controller.getworkbooks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(tabTitles.length, (index) {
            final bool isSelected = _tabController.index == index;
            return GestureDetector(
              onTap:
                  () => setState(() {
                    _tabController.index = index;
                  }),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepOrange : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : [],
                ),
                child: Text(
                  tabTitles[index],
                  style: GoogleFonts.poppins(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
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
      ),

      body: SafeArea(
        child: Column(
          children: [
            _buildCustomTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  RefreshIndicator(
                    onRefresh: () => controller.loadBooks(),
                    child: CustomScrollView(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: SizedBox(height: 8)),
                        _buildBookList(),
                      ],
                    ),
                  ),
                  RefreshIndicator(
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
                  const Center(child: Text("Coming soon")),
                  const Center(child: Text("Coming soon")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList() {
    return Obx(() {
      if (controller.isLoading.value && controller.books.isEmpty) {
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

      if (controller.books.isEmpty) {
        return _buildCenteredMessage(
          imagePath: "assets/images/loadingBooks.png",
          message: "My Library is Empty",
          onAddNow: () => controller.loadBooks(),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final book = controller.books[index];
          return _buildBookItem(book);
        }, childCount: controller.books.length),
      );
    });
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

  Widget _buildBookItem(Book book) {
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
            onTap:
                () => Get.to(() => BookDetailsPage(bookId: book.bookId ?? '')),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      book.coverImageUrl ?? book.coverImage ?? '',
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Image.asset(
                          'assets/images/mains-logo.png',
                          width: 80,
                          height: 120,
                          fit: BoxFit.cover,
                        );
                      },
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
                          book.title ?? 'No Title',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (book.rating != null) ...[
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
                                book.rating!.toStringAsFixed(1),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          book.author ?? 'Unknown Author',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (book.subject != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            book.subject!,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
                                if (book.bookId != null) {
                                  controller.deleteBook(book.bookId!);
                                }
                              },
                              child: Text(
                                'Remove',
                                style: GoogleFonts.poppins(color: Colors.red),
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
            ),
          ),
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
          return _buildWorkbookItem(workbook);
        }, childCount: controller.MyWorkBookLists.length),
      );
    });
  }

  Widget _buildWorkbookItem(Workbooks workbook) {
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
