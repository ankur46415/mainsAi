import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:lottie/lottie.dart';
import 'dart:io';
import 'controller.dart';

class AnnotationsPage extends StatefulWidget {
  final String? answerId;
  final String? reviewRequest;
  final bool? isAccepted;
  const AnnotationsPage({
    super.key,
    this.answerId,
    this.isAccepted,
    this.reviewRequest,
  });

  @override
  State<AnnotationsPage> createState() => _AnnotationsPageState();
}

class _AnnotationsPageState extends State<AnnotationsPage> {
  final controller = Get.put(AnotationController());

  @override
  void initState() {
    super.initState();
    print("answer id: ${widget.answerId}");
    controller.currentIndex.value = -1;
    if (widget.isAccepted != null) {
      controller.isAccepted.value = widget.isAccepted!;
    }

    if (widget.reviewRequest != null && widget.reviewRequest!.isNotEmpty) {
      controller.currentRequestId = widget.reviewRequest;
      print('Setting review request ID: ${widget.reviewRequest}');
    }
    if (widget.answerId != null && widget.answerId!.isNotEmpty) {
      print('Loading images for questionId: ${widget.answerId}');
      _initializeImages();
    } else {
      print('❌ No question ID provided');
      Get.snackbar(
        'Error',
        'No question ID provided',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
      );
    }
    print("isaccepted: ${widget.isAccepted}");

    if (widget.answerId != null) {
      controller.loadImages(widget.answerId!);
    }
    print("requestId:${widget.reviewRequest}");
  }

  Future<void> _initializeImages() async {
    try {
      await controller.fetchReviewImages(widget.answerId!);

      if (controller.reviewImages.isEmpty) {}
    } catch (e) {
      print('Error initializing images: $e');
      String errorMessage = 'Failed to load review images';

      if (e.toString().contains('Question not found')) {
        errorMessage = 'Question not found. Please check the question ID.';
      } else if (e.toString().contains('Unauthorized')) {
        errorMessage = 'Session expired. Please login again.';
        // Optional: Navigate to login page
        // Get.offAllNamed('/login');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.currentIndex.value >= 0) {
          controller.currentIndex.value = -1;
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },

            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          backgroundColor: Colors.red,

          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Edit',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Obx(
                    () => Transform.scale(
                      scale: 0.75,
                      child: Switch(
                        value: controller.isEditMode.value,
                        activeColor: Colors.white,
                        onChanged: (val) {
                          print('🔧 Edit mode changed to: $val');
                          controller.isEditMode.value = val;
                          if (!val) {
                            print(
                              '🔧 Edit mode turned OFF - resetting controller',
                            );
                            controller.resetCurrentController();
                          } else {
                            print('🔧 Edit mode turned ON');
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.displayImages.isEmpty && widget.answerId != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset(
                        'assets/lottie/book_loading.json',
                        fit: BoxFit.contain,
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.color(const [
                              '**',
                            ], value: Colors.red),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.displayImages.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No images available',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.currentIndex.value >= 0) {
              final currentImage =
                  controller.imagesWithStatus[controller.currentIndex.value];
              return Stack(
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child:
                          controller.isEditMode.value
                              ? (currentImage.imagePath.startsWith('http')
                                  ? ImagePainter.network(
                                    currentImage.imagePath,
                                    controller: controller.currentController,
                                    scalable: true,
                                    colors: const [
                                      Colors.red,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.purple,
                                    ],
                                  )
                                  : currentImage.imagePath.startsWith('assets/')
                                  ? ImagePainter.asset(
                                    currentImage.imagePath,
                                    controller: controller.currentController,
                                    scalable: true,
                                    colors: const [
                                      Colors.red,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.purple,
                                    ],
                                  )
                                  : ImagePainter.file(
                                    File(currentImage.imagePath),
                                    controller: controller.currentController,
                                    scalable: true,
                                    colors: const [
                                      Colors.red,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.yellow,
                                      Colors.purple,
                                    ],
                                  ))
                              : InteractiveViewer(
                                minScale: 0.1,
                                maxScale: 4.0,
                                child:
                                    currentImage.displayPath.startsWith('http')
                                        ? Image.network(
                                          currentImage.displayPath,
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            print(
                                              'Error loading network image: $error',
                                            );
                                            return Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Icon(
                                                   Icons.menu_book_rounded,
                                                  color: Colors.grey[600],
                                                  size: 48,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                        : currentImage.displayPath.startsWith(
                                          'assets/',
                                        )
                                        ? Image.asset(
                                          currentImage.displayPath,
                                          fit: BoxFit.contain,
                                        )
                                        : Image.file(
                                          File(currentImage.displayPath),
                                          fit: BoxFit.contain,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            print(
                                              'Error loading file image: $error',
                                            );
                                            return Container(
                                              color: Colors.grey[300],
                                              child: Center(
                                                child: Icon(
                                                   Icons.menu_book_rounded,
                                                  color: Colors.grey[600],
                                                  size: 48,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                              ),
                    ),
                  ),
                  // Buttons and overlays
                  Positioned(
                    top: 50,
                    left: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        onPressed: () {
                          controller.currentIndex.value = -1;
                          if (controller.isEditMode.value) {
                            controller.resetCurrentController();
                          }
                        },
                      ),
                    ),
                  ),
                  if (controller.isEditMode.value)
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        children: [
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.save, size: 20),
                              label: Text(
                                'Save',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await controller.saveCurrentImage();
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Annotation saved successfully",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Error saving annotation: ${e.toString()}",
                                          style: GoogleFonts.poppins(),
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.displayImages.length,
              itemBuilder: (context, index) {
                final image = controller.displayImages[index];
                return InkWell(
                  onTap: () {
                    final actualIndex = controller.imagesWithStatus.indexWhere(
                      (img) => img.imagePath == image.imagePath,
                    );
                    if (actualIndex != -1) {
                      controller.setCurrentIndex(actualIndex);
                      if (controller.isEditMode.value && !image.isAnnotated) {
                        controller.resetCurrentController();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(bottom: 1),
                        child:
                            image.displayPath.startsWith('http')
                                ? Image.network(
                                  image.displayPath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print(
                                      'Error loading network image: $error',
                                    );
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Icon(
                                           Icons.menu_book_rounded,
                                          color: Colors.grey[600],
                                          size: 48,
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : Image.file(
                                  File(image.displayPath),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading file image: $error');
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Center(
                                        child: Icon(
                                           Icons.menu_book_rounded,
                                          color: Colors.grey[600],
                                          size: 48,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Page ${index + 1}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() {
          if (controller.needsSaving.value) {
            return FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Text(
                        "Enter Marks & Remarks",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildTextField(
                              controller: controller.scoreMark,
                              hint: "Marks",
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: controller.reviewResultRemark,
                              hint: "Enter review result",
                              maxLines: 3,
                            ),

                            const SizedBox(height: 12),
                            _buildTextField(
                              controller: controller.expertRemark,
                              hint: "Enter expert's remark",
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                      actionsPadding: const EdgeInsets.only(
                        right: 12,
                        bottom: 8,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(color: Colors.grey[700]),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();

                            controller.saveAnnotatedListAndUploadImages();
                          },
                          child: Text(
                            "Save",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.green,
              icon: const Icon(Icons.save, color: Colors.white),
              label: Text(
                'Save All',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }

          // if (controller.needsSaving.value) {
          //   return FloatingActionButton.extended(
          //     onPressed: () {
          //       controller.saveAnnotatedList();
          //       controller.saveAnnotatedListAndUploadImages();
          //     },
          //     backgroundColor: Colors.green,
          //     icon: const Icon(Icons.save, color: Colors.white),
          //     label: Text(
          //       'Save All',
          //       style: GoogleFonts.poppins(
          //         color: Colors.white,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   );
          // }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}
