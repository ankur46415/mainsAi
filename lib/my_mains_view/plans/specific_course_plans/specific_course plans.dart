import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/app_routes.dart';
import 'package:mains/my_mains_view/plans/specific_course_plans/controller.dart';
import 'package:mains/common/loading_widget.dart';

class SpecificCourse extends StatefulWidget {
  const SpecificCourse({super.key});

  @override
  State<SpecificCourse> createState() => _SpecificCourseState();
}

class _SpecificCourseState extends State<SpecificCourse> {
  late SpecificCourseController controller;
  final RxInt selectedTabIndex = 0.obs;
  final RxString selectedSubCategory = ''.obs;
  String? planId;
  @override
  void initState() {
    final dynamic args = Get.arguments;
    if (args is Map && args['planId'] != null) {
      planId = args['planId']?.toString();
    }
    controller = Get.put(SpecificCourseController(planId: planId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 87, 87),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Plan',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget(message: "Loading plan...");
          }

          // Show error message if no plan data
          if (controller.plan.value == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No plan data available',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please try again later',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Plan Card (Dynamic) ----------
                Obx(() {
                  final plan = controller.plan.value;
                  final String title = plan?.name ?? "Plan Details";
                  final int durationDays = plan?.duration ?? 0;
                  final num mrp = plan?.mrp ?? 0;
                  final num offer = plan?.offerPrice ?? 0;
                  final int discountPct =
                      (mrp > 0) ? (((mrp - offer) / mrp) * 100).round() : 0;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top red part
                        Container(
                          padding: const EdgeInsets.all(14),
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 236, 87, 87),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // White content
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                durationDays > 0
                                    ? "Validity : ${durationDays ~/ 365} Year${durationDays >= 730 ? 's' : ''}"
                                    : "Validity : Not specified",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                durationDays > 0
                                    ? "Plan validity is ${durationDays} days total"
                                    : "Plan validity information not available",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (mrp > 0 || offer > 0) ...[
                                Row(
                                  children: [
                                    if (mrp > 0) ...[
                                      Text(
                                        "₹ $mrp",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    if (discountPct > 0)
                                      Text(
                                        "Discount: ${discountPct.clamp(0, 100)}%",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  offer > 0
                                      ? "Fees : ₹ $offer"
                                      : "Fees : Not specified",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        offer > 0
                                            ? Colors.green.shade700
                                            : Colors.grey,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  "Pricing information not available",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 20),

                // ---------- Description ----------
                Obx(() {
                  final plan = controller.plan.value;
                  final String desc = plan?.description ?? "";

                  if (desc.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "No description available for this plan",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  return Text(
                    desc,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  );
                }),

                const SizedBox(height: 24),

                Text(
                  "Descriptions",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Following contents are available with this plan",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 16),

                Obx(() {
                  final plan = controller.plan.value;
                  String categoryFromItems = '';
                  final items = plan?.items ?? [];
                  if (items.isNotEmpty) {
                    categoryFromItems =
                        items.first.referencedItem?.category ?? '';
                  }
                  final String category =
                      categoryFromItems.isNotEmpty
                          ? categoryFromItems
                          : (plan?.category ?? '');
                  return Text(
                    category,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  );
                }),

                const SizedBox(height: 16),

                // ---------- Subcategory Tabs (dynamic) ----------
                Obx(() {
                  final items = controller.plan.value?.items ?? [];
                  final List<String> subCats =
                      <String>{
                        for (final it in items)
                          if (it.referencedItem?.subCategory != null &&
                              it.referencedItem!.subCategory.isNotEmpty)
                            it.referencedItem!.subCategory,
                      }.toList();

                  if (subCats.isEmpty) {
                    return const SizedBox.shrink(); // Hide subcategory tabs if no subcategories
                  }

                  // Compute current selection without mutating reactive state during build
                  final String currentSelection =
                      (selectedSubCategory.value.isEmpty && subCats.isNotEmpty)
                          ? subCats.first
                          : selectedSubCategory.value;
                  final int computedIndex = subCats.indexOf(currentSelection);
                  final int currentIndex =
                      computedIndex >= 0 ? computedIndex : 0;

                  // Initialize selection post-frame to avoid mutating during build
                  if (selectedSubCategory.value.isEmpty && subCats.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (selectedSubCategory.value.isEmpty &&
                          subCats.isNotEmpty) {
                        selectedSubCategory.value = subCats.first;
                        selectedTabIndex.value = 0;
                      }
                    });
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(subCats.length, (index) {
                        final bool isSelected = currentIndex == index;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () {
                              selectedTabIndex.value = index;
                              selectedSubCategory.value = subCats[index];
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? Colors.blue
                                        : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                subCats[index],
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),

                const SizedBox(height: 20),

                Obx(() {
                  final allItems = controller.plan.value?.items ?? [];

                  // Build subcategories list to compute effective filter
                  final List<String> subCats =
                      <String>{
                        for (final it in allItems)
                          if (it.referencedItem?.subCategory != null &&
                              it.referencedItem!.subCategory.isNotEmpty)
                            it.referencedItem!.subCategory,
                      }.toList();

                  // Use first subcategory by default if none selected
                  final String effectiveFilter =
                      (selectedSubCategory.value.isEmpty && subCats.isNotEmpty)
                          ? subCats.first
                          : selectedSubCategory.value;

                  final items =
                      effectiveFilter.isEmpty
                          ? allItems
                          : allItems
                              .where(
                                (it) =>
                                    (it.referencedItem?.subCategory ?? '') ==
                                    effectiveFilter,
                              )
                              .toList();

                  if (items.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No content available',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This plan does not include any content yet',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final String? imageUrl =
                          item.referencedItem?.coverImageUrl;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              imageUrl == null || imageUrl.isEmpty
                                  ? Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  )
                                  : Image.network(
                                    imageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover, // 🔹 fills entire space
                                    errorBuilder:
                                        (_, __, ___) => Container(
                                          color: Colors.grey.shade200,
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                          ),
                                        ),
                                  ),
                        ),
                      );
                    },
                  );
                }),
                // Add bottom padding to prevent content from going under floating action button
                const SizedBox(height: 100),
              ],
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: Get.width * 0.03,
            right: Get.width * 0.03,
          ),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              alignment: Alignment.center,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 56,
                child: Obx(() {
                  final plan = controller.plan.value;
                  final bool isEnrolled = plan?.isEnrolled ?? false;
                  return FloatingActionButton.extended(
                    backgroundColor: isEnrolled ? Colors.grey : Colors.green,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    icon: Icon(
                      isEnrolled ? Icons.check_circle : Icons.payment,
                      color: Colors.white,
                    ),
                    label: Text(
                      isEnrolled ? 'ALREADY PURCHASED' : 'MAKE PAYMENT',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed:
                        isEnrolled
                            ? null
                            : () {
                              if (plan == null) {
                                Get.snackbar(
                                  'Error',
                                  'Plan information is not available. Please try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                                return;
                              }
                              Get.toNamed(
                                AppRoutes.makePayment,
                                arguments: {
                                  'planId': plan.id,
                                  'name': plan.name,
                                  'description': plan.description,
                                  'duration': plan.duration,
                                  'mrp': plan.mrp,
                                  'offerPrice': plan.offerPrice,
                                  'category': plan.category,
                                },
                              );
                            },
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
