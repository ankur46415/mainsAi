import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/my_mains_view/add_to_cart/controller.dart';
import 'package:mains/my_mains_view/bottomBar/MyHomePage.dart';
import 'package:mains/my_mains_view/bottomBar/controller.dart';
import 'package:mains/my_mains_view/workBook/work_book_detailes/controller.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  late CreditCardController controller;
  String token = '';

  Set<int> selectedIndexes = {};
  bool initialSelectionDone = false;

  @override
  void initState() {
    super.initState();
    controller = Get.put(CreditCardController());
  }

  bool showSummary = false;

  double get subTotal {
    final items = controller.cartList.value?.data?.items;
    if (items == null) return 0;
    double sum = 0;
    for (int i = 0; i < (items.length); i++) {
      if (selectedIndexes.contains(i)) {
        sum += (items[i].price ?? 0) * 1;
      }
    }
    return sum;
  }

  double get gstAmount {
    final items = controller.cartList.value?.data?.items;
    if (items == null) return 0;
    double gstSum = 0;
    for (int i = 0; i < items.length; i++) {
      if (selectedIndexes.contains(i)) {
        final price = items[i].price ?? 0;
        final gstPercent = items[i].workbookId?.gst ?? 0;
        gstSum += price * (gstPercent / 100);
      }
    }
    return gstSum;
  }

  double get total => subTotal + gstAmount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color(0xFFE85757)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () async {
              final controller = Get.find<WorkBookBOOKDetailes>();
              if (controller.workbook.value != null) {
                await controller.fetchWorkbookDetails(
                  controller.workbook.value!.sId!,
                );
              }
              Navigator.pop(context);
            },
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.orange.shade400,
                    ),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading your cart...',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      controller.error.value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.fetchCartList(null),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Try Again',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          final items = controller.cartList.value?.data?.items ?? [];

          // By default, select all items only on initial load or when cart changes
          if (!initialSelectionDone && items.isNotEmpty) {
            selectedIndexes = Set<int>.from(
              List.generate(items.length, (i) => i),
            );
            initialSelectionDone = true;
          }
          // If cart becomes empty, reset the flag
          if (items.isEmpty && initialSelectionDone) {
            initialSelectionDone = false;
          }
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 60,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some items to get started',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Set bottom bar index to 0 and go to dashboard
                      final bottomNavController =
                          Get.find<BottomNavController>();
                      bottomNavController.changeIndex(0);
                      Get.offAll(() => MyHomePage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'Continue Shopping',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header with select all option
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedIndexes.length} item${selectedIndexes.length != 1 ? 's' : ''} selected',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    if (items.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedIndexes.length == items.length) {
                              selectedIndexes.clear();
                            } else {
                              selectedIndexes = Set<int>.from(
                                List.generate(items.length, (i) => i),
                              );
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedIndexes.length == items.length
                                ? 'Deselect All'
                                : 'Select All',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await controller.fetchCartList(null);
                  },
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = selectedIndexes.contains(index);

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Dismissible(
                          key: Key(item.title ?? index.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.all(20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade400,
                                  Colors.red.shade600,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          onDismissed: (direction) async {
                            final itemId = item.workbookId?.id;
                            if (itemId != null && itemId.isNotEmpty) {
                              await controller.deleteCartItem(itemId);
                              setState(() {
                                // Re-sync selectedIndexes with new cart items
                                final newItems =
                                    controller.cartList.value?.data?.items ??
                                    [];
                                selectedIndexes = Set<int>.from(
                                  List.generate(newItems.length, (i) => i),
                                );
                                initialSelectionDone = true;
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(
                                    isSelected ? 0.1 : 0.05,
                                  ),
                                  blurRadius: isSelected ? 12 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedIndexes.remove(index);
                                    } else {
                                      selectedIndexes.add(index);
                                    }
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? Colors.orange.withOpacity(0.8)
                                              : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      // Selection Indicator
                                      Container(
                                        width: 24,
                                        height: 24,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              isSelected
                                                  ? Colors.orange
                                                  : Colors.grey.shade300,
                                          border: Border.all(
                                            color:
                                                isSelected
                                                    ? Colors.orange
                                                    : Colors.grey.shade400,
                                            width: 2,
                                          ),
                                        ),
                                        child:
                                            isSelected
                                                ? const Icon(
                                                  Icons.check_rounded,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                                : null,
                                      ),

                                      // Product Image
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.orange.shade100,
                                              Colors.orange.shade300,
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.orange.withOpacity(
                                                0.2,
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child:
                                              (item.workbookId?.coverImageUrl !=
                                                          null &&
                                                      item
                                                          .workbookId!
                                                          .coverImageUrl!
                                                          .isNotEmpty)
                                                  ? Image.network(
                                                    item
                                                        .workbookId!
                                                        .coverImageUrl!,
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.fill,
                                                    errorBuilder:
                                                        (
                                                          context,
                                                          error,
                                                          stackTrace,
                                                        ) => Image.asset(
                                                          'assets/images/bookb.png',
                                                          width: 70,
                                                          height: 70,
                                                          fit: BoxFit.cover,
                                                        ),
                                                  )
                                                  : Image.asset(
                                                    'assets/images/bookb.png',
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                        ),
                                      ),

                                      const SizedBox(width: 16),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title ?? 'Untitled Item',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade800,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "₹${(item.price ?? 0).toStringAsFixed(2)}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.orange.shade700,
                                              ),
                                            ),
                                          ],
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
                  ),
                ),
              ),

              // Bottom Checkout Section
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(showSummary ? 24 : 0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 16,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showSummary) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Order Summary",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade600,
                              size: 22,
                            ),
                            onPressed: () {
                              setState(() {
                                showSummary = false;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildPriceRow(
                        "Subtotal",
                        "₹${subTotal.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 8),
                      _buildPriceRow(
                        "GST ",
                        "₹${gstAmount.toStringAsFixed(2)}",
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, thickness: 1),
                      const SizedBox(height: 12),
                      _buildPriceRow(
                        "Total Amount",
                        "₹${total.toStringAsFixed(2)}",
                        isBold: true,
                      ),
                      const SizedBox(height: 20),
                    ],

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            selectedIndexes.isEmpty
                                ? null
                                : () async {
                                  if (!showSummary &&
                                      selectedIndexes.isNotEmpty) {
                                    setState(() {
                                      showSummary = true;
                                    });
                                  } else if (showSummary) {
                                    // Gather selected workbook IDs
                                    final items =
                                        controller
                                            .cartList
                                            .value
                                            ?.data
                                            ?.items ??
                                        [];
                                    final selectedWorkbookIds =
                                        selectedIndexes
                                            .map((i) => items[i].workbookId?.id)
                                            .whereType<String>()
                                            .toList();

                                    // Call API
                                    await controller.proceedToPayment(
                                      selectedWorkbookIds,
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              selectedIndexes.isEmpty
                                  ? Colors.grey.shade300
                                  : Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 2,
                          shadowColor: Colors.orange.withOpacity(0.3),
                        ),
                        child: Text(
                          showSummary
                              ? "Proceed to Payment"
                              : selectedIndexes.isEmpty
                              ? "Select Items to Checkout"
                              : "Checkout (${selectedIndexes.length} items)",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                selectedIndexes.isEmpty
                                    ? Colors.grey.shade600
                                    : Colors.white,
                          ),
                        ),
                      ),
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

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: isBold ? Colors.grey.shade800 : Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: isBold ? Colors.orange.shade700 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
