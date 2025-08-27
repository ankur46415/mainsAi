import 'package:mains/app_imports.dart';

class TestCategoriesObjectivePage extends StatefulWidget {
  const TestCategoriesObjectivePage({super.key});

  @override
  State<TestCategoriesObjectivePage> createState() =>
      _TestCategoriesObjectivePageState();
}

class _TestCategoriesObjectivePageState
    extends State<TestCategoriesObjectivePage>
    with TickerProviderStateMixin {
  final AiTestObjectiveController controller = Get.put(
    AiTestObjectiveController(),
  );
  final TestTabController tabController = Get.put(TestTabController());

  @override
  void initState() {
    super.initState();
    controller.fetchObjectiveTestHomeData(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final data = controller.aiTestHomeResponse.value?.data;

        if (controller.isLoading.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Lottie.asset(
                'assets/lottie/book_loading.json',
                height: 200,
                width: 200,
                delegates: LottieDelegates(
                  values: [
                    ValueDelegate.color(['**'], value: Colors.red),
                  ],
                ),
              ),
            ),
          );
        }

        if (data == null || data.categories.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              child: Text(
                "Objective test is empty",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(16),
          children:
              data.categories.map((category) {
                final subcategories = category.subcategories;

                if (subcategories.isEmpty) return const SizedBox.shrink();

                final subCatNames =
                    subcategories.map((e) => e.name ?? "").toSet().toList();

                if (tabController.getSelected(category.category) == null &&
                    subCatNames.isNotEmpty) {
                  tabController.setSelected(
                    category.category,
                    subCatNames.first,
                  );
                }
                final selectedSub =
                    tabController.getSelected(category.category) ?? "";

                final selectedSubcategory = subcategories.firstWhereOrNull(
                  (s) => s.name == selectedSub,
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.category,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: subCatNames.length,
                        itemBuilder: (context, index) {
                          final subName = subCatNames[index];
                          final isSelected =
                              tabController.getSelected(category.category) ==
                              subName;

                          return GestureDetector(
                            onTap:
                                () => tabController.setSelected(
                                  category.category,
                                  subName,
                                ),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  subName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (selectedSubcategory?.tests.isNotEmpty == true)
                      SizedBox(
                        height: Get.width * 0.35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedSubcategory!.tests.length,
                          padding: const EdgeInsets.only(bottom: 12),
                          itemBuilder: (context, index) {
                            final test = selectedSubcategory.tests[index];
                            return Container(
                              width: Get.width*0.28,
                              margin: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.starttestpage,
                                    arguments: test,
                                  );
                                },
                                child: _buildTestCard(
                                  title: test.name,
                                  subtitle: test.description,
                                  label: selectedSubcategory.name ?? '',
                                  startColor: Colors.indigo.shade600,
                                  endColor: Colors.indigo.shade400,
                                  imageUrl: test.imageUrl,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("No tests available in this subcategory"),
                      ),
                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
        );
      }),
    );
  }

  Widget _buildTestCard({
    required String title,
    required String subtitle,
    required String imageUrl,
    required String label,
    required Color startColor,
    required Color endColor,
  }) {
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
                Icons.broken_image,
                size: 40,
                color: Colors.grey,
              ),
            ),
      ),
    );
  }
}
