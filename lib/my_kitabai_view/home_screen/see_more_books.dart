import '../../app_imports.dart';

class WorkBookCategoryPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:     CustomAppBar( title:"$mainCategory - $subCategory"),

      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.68,
        ),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _buildImageBox(book, height: Get.width * 0.55);
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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: book.coverImageUrl ?? '',
            fit: BoxFit.fill,
            placeholder: (context, url) => Center(
              child: Image.asset("assets/images/mains-logo.png", height: 50),
            ),
            errorWidget: (context, url, error) => Container(
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
