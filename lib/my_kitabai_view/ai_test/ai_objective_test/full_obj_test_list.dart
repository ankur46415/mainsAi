import 'package:mains/app_imports.dart';

class FullTestListObjPage extends StatelessWidget {
  final List<AiTestItem> tests;
  final String subcategoryName;
  final String categoryName;

  const FullTestListObjPage({
    super.key,
    required this.tests,
    required this.subcategoryName,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: subcategoryName),
      body:
          tests.isEmpty
              ? const Center(
                child: Text(
                  "No tests available",
                  style: TextStyle(color: Colors.grey),
                ),
              )
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  itemCount: tests.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.starttestpage, arguments: test);
                      },
                      child: _buildTestCard(imageUrl: test.imageUrl),
                    );
                  },
                ),
              ),
    );
  }

  Widget _buildTestCard({required String imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: const Icon(
                 Icons.menu_book_rounded,
                size: 40,
                color: Colors.grey,
              ),
            ),
      ),
    );
  }
}
