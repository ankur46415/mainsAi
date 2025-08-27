import 'package:mains/app_imports.dart';
import 'package:mains/my_kitabai_view/ai_test/ai_test_subjective/controller.dart';

class AiTestSubHome extends StatefulWidget {
  const AiTestSubHome({super.key});

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
    controller.fetchAiTestSubjective(this);
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
                    if (selectedSubcategory.tests != null &&
                        selectedSubcategory.tests!.isNotEmpty)
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
                        itemCount: selectedSubcategory.tests!.length,
                        itemBuilder: (context, index) {
                          final test = selectedSubcategory.tests![index];

                          return GestureDetector(
                            onTap: () {
                              NavigationUtils.navigateToTestDetails(
                                test,
                                AppRoutes.subjectiveTestNamePage,
                              );
                            },
                            child: _buildTestCard(
                              title: test.name ?? 'Untitled',
                              subtitle: test.description ?? '',
                              label: selectedSubcategory.name ?? '',
                              startColor: Colors.teal.shade700,
                              endColor: Colors.teal.shade400,
                              imageUrl:
                                  test.imageUrl ??
                                  'https://picsum.photos/300/200',
                            ),
                          );
                        },
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
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.fill,
        placeholder:
            (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget:
            (context, url, error) => Container(
              color: Colors.grey[300],
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.broken_image,
                    size: 40,
                    color: Colors.grey,
                  ),
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
