import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/controller.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/full_test_list/full_test_list.dart';

class AiTestSubHome extends StatefulWidget {
  AiTestSubHome({super.key});

  @override
  State<AiTestSubHome> createState() => _AiTestSubHomeState();
}

class _AiTestSubHomeState extends State<AiTestSubHome>
    with TickerProviderStateMixin {
  final AiTestSubjectiveController controller = Get.put(
    AiTestSubjectiveController(),
  );

  final TestTabController tabController = Get.put(TestTabController());
  @override
  void initState() {
    super.initState();
    controller.fetchAiTestSubjective(this).then((_) {
      final data = controller.aiTestSubjective.value?.data;
      if (data != null && data.categories != null) {
        for (var category in data.categories!) {
          if (category.subcategories != null &&
              category.subcategories!.isNotEmpty) {
            final firstSub = category.subcategories!.first.name;
            if (firstSub != null) {
              tabController.setSelected(category.category!, firstSub);
            }
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
                    ValueDelegate.color(const ['**'], value: Colors.red),
                  ],
                ),
              ),
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error loading tests',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchAiTestSubjective(this),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final data = controller.aiTestSubjective.value?.data;
        if (data == null ||
            data.categories == null ||
            data.categories!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.quiz_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No tests available',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new tests',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children:
              data.categories!.map((category) {
                if (category.category == null ||
                    category.subcategories == null) {
                  return const SizedBox.shrink();
                }

                final subcategories = category.subcategories!;
                if (subcategories.isEmpty) return const SizedBox.shrink();

                final subCatNames =
                    subcategories
                        .where(
                          (sub) => sub.name != null && sub.name!.isNotEmpty,
                        )
                        .map((e) => e.name!)
                        .toSet()
                        .toList();

                if (subCatNames.isEmpty) return const SizedBox.shrink();

                if (tabController.getSelected(category.category!) == null &&
                    subCatNames.isNotEmpty) {
                  tabController.setSelected(
                    category.category!,
                    subCatNames.first,
                  );
                }

                final selectedSub =
                    tabController.getSelected(category.category!) ?? "";
                final selectedSubcategory = subcategories.firstWhereOrNull(
                  (s) => s.name == selectedSub,
                );

                if (selectedSubcategory == null) return const SizedBox.shrink();
                final enabledTests =
                    (selectedSubcategory.tests ?? [])
                        .where((t) => t.isEnabled == true)
                        .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.category!,
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
                              tabController.getSelected(category.category!) ==
                              subName;

                          return GestureDetector(
                            onTap:
                                () => tabController.setSelected(
                                  category.category!,
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
                                        ? Colors.blue[600]
                                        : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color:
                                      isSelected
                                          ? Colors.blue[600]!
                                          : Colors.grey[300]!,
                                ),
                              ),
                              child: Text(
                                subName,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.grey[700],
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
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 0.8,
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
                                        .map(
                                          (t) =>
                                              t.imageUrl ??
                                              'https://picsum.photos/300/200',
                                        )
                                        .toList();

                                return GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => FullTestListPage(
                                        tests: enabledTests,
                                        subcategoryName:
                                            selectedSubcategory.name ?? "",
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                ),
                                            itemCount: images.length,
                                            itemBuilder: (context, imgIndex) {
                                              return Image.network(
                                                images[imgIndex],
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.4),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          "See More",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final test = enabledTests[index];
                              return GestureDetector(
                                onTap: () {
                                  NavigationUtils.navigateToTestDetails(
                                    test,
                                    AppRoutes.subjectiveTestNamePage,
                                  );
                                },
                                child: _buildTestCard(
                                  imageUrl:
                                      test.imageUrl ??
                                      'https://picsum.photos/300/200',
                                  isPaid: test.isPaid,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Text(
                            "No tests available in this subcategory",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                );
              }).toList(),
        );
      }),
    );
  }

  Widget _buildTestCard({required String imageUrl, bool? isPaid}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
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
                      Image.asset("assets/images/bookb.png", color: Colors.grey),
                    ],
                  ),
                ),
          ),
          // Paid indicator - only show when isPaid is true
          if (isPaid == true)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
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
                  'PAID',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
