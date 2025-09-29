import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/common/loading_widget.dart';
import 'package:mains/my_mains_view/plans/support_banner.dart';
import '../../app_routes.dart';
import '../../models/course_plans.dart';
import 'controller/all_plan_controller.dart';

class AllPlanScreen extends StatefulWidget {
  const AllPlanScreen({super.key});

  @override
  State<AllPlanScreen> createState() => _AllPlanScreenState();
}

class _AllPlanScreenState extends State<AllPlanScreen> {
  late AllPlanController controller;
  String? _selectedCategory;
  @override
  void initState() {
    super.initState();
    controller = Get.put(AllPlanController());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4F8), // Softer blue-gray background
        appBar: AppBar(
          title: Text(
            'Plans',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFF8E53),
                  Color(0xFFFFC107),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [Tab(text: 'All Plans'), Tab(text: 'Enrolled')],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const LoadingWidget();
          }

          if (controller.hasError.value) {
            return _buildErrorState();
          }

          // Build categories (unique, non-empty)
          final categories =
              <String>{}..addAll(
                controller.plans
                    .map((p) => p.category?.trim() ?? '')
                    .where((c) => c.isNotEmpty),
              );

          // Apply category filter
          final enrolledPlans =
              controller.plans
                  .where((p) => p.isEnrolled == true)
                  .where(
                    (p) =>
                        _selectedCategory == null ||
                        (p.category?.trim() ?? '') == _selectedCategory,
                  )
                  .toList();
          final notEnrolledPlans =
              controller.plans
                  .where((p) => p.isEnrolled != true)
                  .where(
                    (p) =>
                        _selectedCategory == null ||
                        (p.category?.trim() ?? '') == _selectedCategory,
                  )
                  .toList();

          return Column(
            children: [
              // Filter Row
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildFilterChip(
                        label: 'All',
                        selected: _selectedCategory == null,
                        onTap: () => setState(() => _selectedCategory = null),
                      ),
                      const SizedBox(width: 8),
                      ...categories.map(
                        (cat) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildFilterChip(
                            label: cat,
                            selected: _selectedCategory == cat,
                            onTap:
                                () => setState(() => _selectedCategory = cat),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPlanListWithSupport(
                      notEnrolledPlans,
                      context,
                      'No plans available',
                    ),
                    _buildPlanListWithSupport(
                      enrolledPlans,
                      context,
                      'No enrolled plans',
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[500]),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.refreshPlans(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A6572),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanListWithSupport(
    List<Data> plans,
    BuildContext context,
    String emptyMsg,
  ) {
    if (plans.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => controller.refreshPlans(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          children: [
            const SupportCard(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      emptyMsg,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => controller.refreshPlans(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length + 2,
        itemBuilder: (context, index) {
          // Show support card in the middle
          if (index == (plans.length / 2).floor()) {
            return const SupportCard();
          }

          // Show support card at the end
          if (index == plans.length + 1) {
            return const SupportCard();
          }

          // Show plan cards
          final planIndex =
              index > (plans.length / 2).floor() ? index - 1 : index;
          return _buildPlanCard(plans[planIndex], planIndex);
        },
      ),
    );
  }

  Widget _buildPlanCard(Data plan, int index) {
    final originalPrice = plan.mRP ?? 0;
    final offerPrice = plan.offerPrice ?? 0;
    final discountPercentage =
        originalPrice > 0
            ? ((originalPrice - offerPrice) / originalPrice * 100).round()
            : 0;

    return InkWell(
      onTap:
          plan.isEnrolled == true
              ? null
              : () {
                Get.toNamed(
                  AppRoutes.specificCourse,
                  arguments: {'planId': plan.sId},
                );
              },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF344955).withOpacity(0.1),
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF90CAF9), // light blue
                    Color(0xFF42A5F5), // medium blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white70,
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF344955),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      plan.name ?? 'Plan ${index + 1}',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF344955),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Validity
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: const Color(0xFF4A6572), // Dark blue-gray
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Validity: ${plan.duration ?? 365} days",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF344955), // Darker blue-gray
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 26),
                    child: Text(
                      "Plan validity is ${plan.duration ?? 365} days total",
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF5D737E), // Medium blue-gray
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(
                    height: 1,
                    color: Color(0xFFE0E6ED),
                  ), // Light blue-gray divider
                  const SizedBox(height: 16),

                  // Pricing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _priceColumn(
                        "Original Price",
                        '₹$originalPrice',
                        isStrike: true,
                        color: const Color(0xFF8A9BA8), // Gray-blue
                      ),
                      _discountChip(discountPercentage),
                      _priceColumn(
                        "Final Price",
                        '₹$offerPrice',
                        isBold: true,
                        color: Color(0xFF00BFA5), // Teal highlight
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  plan.isEnrolled == true
                      ? _purchasedButton(plan.sId)
                      : _viewDetailsButton(plan.sId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceColumn(
    String title,
    String value, {
    bool isStrike = false,
    bool isBold = false,
    Color? color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: const Color(0xFF5D737E), // Medium blue-gray
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: color ?? const Color(0xFF344955), // Dark blue-gray
            decoration: isStrike ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }

  Widget _discountChip(int discountPercentage) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFC107)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$discountPercentage% OFF',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _purchasedButton(String? planId) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.specificCourse, arguments: {'planId': planId});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53), Color(0xFFFFC107)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF6B6B),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Already purchased',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewDetailsButton(String? planId) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: const Color(0xFF5C6BC0).withOpacity(0.5)),
        ),
        child: ElevatedButton(
          onPressed: () {
            Get.toNamed(
              AppRoutes.specificCourse,
              arguments: {'planId': planId},
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF3949AB),
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFF3949AB),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'View Details',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3949AB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              selected
                  ? const LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8E53),
                      Color(0xFFFFC107),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: selected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.transparent : const Color(0xFFE0E6ED),
          ),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: selected ? Colors.white : const Color(0xFF344955),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
