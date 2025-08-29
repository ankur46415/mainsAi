import '../../app_imports.dart';

class AnnotatedImagesPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;
  const AnnotatedImagesPage({
    Key? key,
    required this.imageUrls,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialIndex);
    return Scaffold(
      backgroundColor: Colors.black,

      body: PageView.builder(
        controller: controller,
        itemCount: imageUrls.length,
        itemBuilder: (context, idx) {
          return Center(
            child: InteractiveViewer(
              child: Image.network(
                imageUrls[idx],
                fit: BoxFit.contain,
                errorBuilder:
                    (_, __, ___) => const Icon(
                       Icons.menu_book_rounded,
                      size: 80,
                      color: Colors.white,
                    ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
