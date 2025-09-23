import 'package:mains/app_imports.dart';
import 'package:mains/my_mains_view/ai_test/ai_objective_test/full_obj_test_list.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.fetchObjectiveTestHomeData(this);
      final data = controller.aiTestHomeResponse.value?.data;
      if (data != null && data.categories.isNotEmpty) {
        for (var category in data.categories) {
          final subcategories = category.subcategories;
          if (subcategories.isNotEmpty) {
            final firstSub = subcategories.first.name;
            tabController.setSelected(category.category, firstSub);
          }
        }
      }
    });
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
                    subcategories.map((e) => e.name).toSet().toList();

                final selectedSub =
                    tabController.getSelected(category.category) ??
                    subCatNames.first;

                final selectedSubcategory = subcategories.firstWhereOrNull(
                  (s) => s.name == selectedSub,
                );

                final enabledTests =
                    (selectedSubcategory?.tests ?? [])
                        .where((t) => t.isEnabled == true)
                        .toList();

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
                          final isSelected = selectedSub == subName;

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
                    if (enabledTests.isNotEmpty)
                      Column(
                        children: [
                          SizedBox(
                            height:
                                Get.width *
                                0.45 *
                                ((enabledTests.length / 3).ceil()),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 12,
                                    crossAxisSpacing: 12,
                                    childAspectRatio: 0.7,
                                  ),
                              itemCount:
                                  enabledTests.length > 5
                                      ? 6
                                      : enabledTests.length,
                              itemBuilder: (context, index) {
                                if (index == 5) {
                                  final images =
                                      enabledTests
                                          .take(6)
                                          .map((t) => t.imageUrl)
                                          .toList();

                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(
                                        () => FullTestListObjPage(
                                          tests: enabledTests,
                                          subcategoryName:
                                              selectedSubcategory?.name ?? "",
                                          categoryName: category.category,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: GridView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 2,
                                                    crossAxisSpacing: 2,
                                                    childAspectRatio: 1,
                                                  ),
                                              itemCount: images.length,
                                              itemBuilder: (context, imgIndex) {
                                                return Image.network(
                                                  images[imgIndex],
                                                  fit: BoxFit.fill,
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              "See More",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                final test = enabledTests[index];
                                return InkWell(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.starttestpage,
                                      arguments: test,
                                    );
                                  },
                                  child: _buildTestCard(
                                    imageUrl: test.imageUrl,
                                    isPaid: test.isPaid,
                                    offerPrice:
                                        (test.planDetails.isNotEmpty)
                                            ? test.planDetails[0].offerPrice
                                            : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
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
    required String? imageUrl,
    bool? isPaid,
    int? offerPrice,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl ?? 'https://picsum.photos/200/300',
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
          if (isPaid == true)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(6), // padding around the icon
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock,
                  size: 12, // adjust size as needed
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
