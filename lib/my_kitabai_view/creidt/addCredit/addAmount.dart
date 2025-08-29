import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller.dart';

class AddAmountScreen extends StatefulWidget {
  const AddAmountScreen({super.key});

  @override
  State<AddAmountScreen> createState() => _AddAmountScreenState();
}

class _AddAmountScreenState extends State<AddAmountScreen> {
  int? selectedIndex;
  final PaymentController paymentController = Get.put(PaymentController());

  static const primaryColor = Color(0xffe64d53);
  static const goldColor = Color(0xFFFFC107);
  static const bgGradient = LinearGradient(
    colors: [Color(0xFFf8fafc), Color(0xFFe0e7ef), Color(0xFFf5e6fa)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const selectedGreen = Color(0xFF22C55E);

  @override
  void initState() {
    super.initState();
    paymentController.fetchRechargePlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Color(0xffe64d53),
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.15),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Recharge Plans",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.5,
          ),
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: bgGradient),
        child: Obx(() {
          if (paymentController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (paymentController.plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.credit_card_off,
                    size: 60,
                    color: primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'No recharge plans available',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: paymentController.plans.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.84, // Increased for more height
            ),
            itemBuilder: (context, index) {
              final plan = paymentController.plans[index];
              final isSelected = selectedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: AnimatedScale(
                  scale: isSelected ? 1.05 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? selectedGreen : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: selectedGreen.withOpacity(0.18),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 4,
                          ), // Reduced vertical padding
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.45),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.18),
                              width: 1.2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize:
                                    MainAxisSize.min, // Prevent overflow
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 38, // Reduced size
                                    width: 38,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          goldColor,
                                          Colors.amber.shade200,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: goldColor.withOpacity(0.18),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Image.asset(
                                        "assets/images/coin-icon.gif",
                                        height: 24, // Reduced size
                                        width: 24,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8), // Reduced spacing
                                  Text(
                                    "${plan.credits}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 20, // Reduced font size
                                      fontWeight: FontWeight.bold,
                                      color: goldColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    "Credits",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.currency_rupee,
                                        color: primaryColor,
                                        size: 18,
                                      ),
                                      Text(
                                        "${plan.offerPrice}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: double.infinity,
                                    height: 34, // Reduced height
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient:
                                          isSelected
                                              ? LinearGradient(
                                                colors: [
                                                  selectedGreen,
                                                  selectedGreen.withOpacity(
                                                    0.8,
                                                  ),
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              )
                                              : LinearGradient(
                                                colors: [
                                                  Colors.white.withOpacity(0.7),
                                                  Colors.white.withOpacity(0.5),
                                                ],
                                              ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: selectedGreen.withOpacity(
                                              0.18,
                                            ),
                                            blurRadius: 8,
                                          ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 6,
                                              ),
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          Text(
                                            isSelected
                                                ? "Selected"
                                                : "Purchase",
                                            style: GoogleFonts.poppins(
                                              color:
                                                  isSelected
                                                      ? Colors.white
                                                      : primaryColor,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (isSelected)
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: selectedGreen.withOpacity(
                                            0.18,
                                          ),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(3),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: selectedGreen,
                                      size: 22,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {
              if (selectedIndex != null) {
                final selectedPlan = paymentController.plans[selectedIndex!];
                paymentController.initiatePayment(
                  amount: selectedPlan.offerPrice.toDouble(),
                  context: context,
                );
              } else {
                Get.snackbar(
                  'Select a Plan',
                  'Please select a recharge plan to proceed.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primaryColor,
                  colorText: Colors.white,
                );
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.payment, size: 24, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  "Proceed to Pay",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
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
}
