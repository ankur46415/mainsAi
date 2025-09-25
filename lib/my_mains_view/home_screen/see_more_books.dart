import '../../app_imports.dart';

class WorkBookCategoryPage extends StatefulWidget {
  final String mainCategory;
  final String subCategory;
  final List<Workbooks> books;

  const WorkBookCategoryPage({
    super.key,
    required this.mainCategory,
    required this.subCategory,
    required this.books,
  });

  @override
  State<WorkBookCategoryPage> createState() => _WorkBookCategoryPageState();
}

class _WorkBookCategoryPageState extends State<WorkBookCategoryPage> {
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "${widget.mainCategory} - ${widget.subCategory}",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        actions: [
          IconButton(
            tooltip: isGrid ? 'List view' : 'Grid view',
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: Icon(
              isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
            ),
            color: Colors.white,
          ),
        ],
      ),

      body:
          isGrid
              ? GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
                itemCount: widget.books.length,
                itemBuilder: (context, index) {
                  final book = widget.books[index];
                  return _buildImageBox(book, height: Get.width * 0.55);
                },
              )
              : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: widget.books.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final book = widget.books[index];
                  return _buildListItem(book);
                },
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
              child: CachedNetworkImage(
                imageUrl: book.coverImageUrl ?? '',
                fit: BoxFit.fill,
                placeholder:
                    (context, url) => Center(
                      child: Image.asset(
                        "assets/images/mains-logo.png",
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

            if (book.isPurchased== true)
              Positioned(
                bottom: 8,
                left: 8,
                child: _buildBadge('ENROLLED', Colors.green),
              )
            else if ((book.isEnrolled != true) && (book.isForSale == true))
              Positioned(bottom: 8, left: 8, child: _buildPriceBadge(book)),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(Workbooks book) {
    return InkWell(
      onTap: () => Get.to(() => WorkBookDetailesPage(bookId: book.sId)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: book.coverImageUrl ?? '',
                width: 64,
                height: 86,
                fit: BoxFit.cover,
                placeholder:
                    (context, url) => Container(
                      width: 64,
                      height: 86,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/mains-logo.png",
                        height: 28,
                      ),
                    ),
                errorWidget:
                    (context, url, error) => Container(
                      width: 64,
                      height: 86,
                      color: Colors.grey[200],
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/images/nophoto.png",
                        height: 28,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (book.isPurchased== true)
                        _buildBadge('ENROLLED', Colors.green)
                      else if ((book.isEnrolled != true) &&
                          (book.isForSale == true))
                        _buildPriceBadge(book),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
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
        text,
        style: GoogleFonts.poppins(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPriceBadge(Workbooks book) {
    final dynamic offer = book.offerPrice;
    String label;
    if (offer == null) {
      label = 'PAID';
    } else if (offer is num) {
      label = offer > 0 ? '₹ ${offer.toStringAsFixed(0)}' : 'PAID';
    } else {
      label = '₹ $offer';
    }
    return _buildBadge(label, Colors.red);
  }
}
