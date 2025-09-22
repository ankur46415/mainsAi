import 'package:mains/app_imports.dart';
import 'package:mains/models/ai_test_subjective.dart';

class FullTestListPage extends StatelessWidget {
  final List<Test> tests;
  final String subcategoryName;

  const FullTestListPage({
    super.key,
    required this.tests,
    required this.subcategoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: subcategoryName),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            tests.isNotEmpty
                ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: tests.length,
                  itemBuilder: (context, index) {
                    final test = tests[index];
                    return GestureDetector(
                      onTap: () {
                        NavigationUtils.navigateToTestDetails(
                          test,
                          AppRoutes.subjectiveTestNamePage,
                        );
                      },
                      child: _buildTestCard(
                        imageUrl:
                            test.imageUrl ?? 'https://picsum.photos/300/200',
                      ),
                    );
                  },
                )
                : Center(
                  child: Text(
                    "No tests available in this subcategorys",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
      ),
    );
  }

  Widget _buildTestCard({required String imageUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
        placeholder:
            (context, url) => Container(
              color: Colors.grey[300],
              child: Center(
                child: Image.asset(
                  'assets/images/bookb.png',
                  fit: BoxFit.fill,
                  color: Colors.grey,
                ),
              ),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon( Icons.menu_book_rounded, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    'Image not available',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
