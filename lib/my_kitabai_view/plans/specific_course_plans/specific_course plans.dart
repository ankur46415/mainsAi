import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/app_routes.dart';
import 'package:mains/my_kitabai_view/plans/specific_course_plans/controller.dart';
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---------- Plan Card (Dynamic) ----------
                Obx(() {
                  final plan = controller.plan.value;
                  final String title =
                      plan?.name.isNotEmpty == true ? plan!.name : "";
                  final int durationDays = plan?.duration ?? 365;
                  final num mrp = plan?.mrp ?? 18000;
                  final num offer = plan?.offerPrice ?? 10000;
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
                                "Validity : ${durationDays ~/ 365} Year${durationDays >= 730 ? 's' : ''}",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Plan validity is ${durationDays} days total",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    "₹ $mrp",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
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
                                "Fees : ₹ $offer",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
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
                  final String desc =
                      plan?.description.isNotEmpty == true
                          ? plan!.description
                          : "";
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

                  // Compute current selection without mutating reactive state during build
                  final String currentSelection =
                      (selectedSubCategory.value.isEmpty && subCats.isNotEmpty)
                          ? subCats.first
                          : selectedSubCategory.value;
                  final int computedIndex = subCats.indexOf(currentSelection);
                  final int currentIndex =
                      computedIndex >= 0 ? computedIndex : 0;

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
                  final filter = selectedSubCategory.value;
                  final items =
                      filter.isEmpty
                          ? allItems
                          : allItems
                              .where(
                                (it) =>
                                    (it.referencedItem?.subCategory ?? '') ==
                                    filter,
                              )
                              .toList();
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
                const SizedBox(height: 20),
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
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.green,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: Text(
                    'MAKE PAYMENT',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () {
                    final plan = controller.plan.value;
                    Get.toNamed(
                      AppRoutes.makePayment,
                      arguments: {
                        'planId': plan?.id,
                        'name': plan?.name,
                        'description': plan?.description,
                        'duration': plan?.duration,
                        'mrp': plan?.mrp,
                        'offerPrice': plan?.offerPrice,
                        'category': plan?.category,
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
