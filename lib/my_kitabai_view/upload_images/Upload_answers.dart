import 'dart:io';
import '../../app_imports.dart';
import 'controller.dart';

class UploadAnswers extends StatefulWidget {
  final String? questionId;
  final String? questionsText;
  const UploadAnswers({super.key, this.questionId, this.questionsText});

  @override
  State<UploadAnswers> createState() => _UploadAnswersState();
}

class _UploadAnswersState extends State<UploadAnswers> {
  late final UploadAnswersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(UploadAnswersController());
    print("widget.questionId : ${widget.questionId}");
    if (widget.questionId != null) {
      controller.setQuestionId(widget.questionId);
      print("Setting questionId in initState: ${widget.questionId}");
    } else {
      print("Warning: widget.questionId is null");
    }
  }

  Widget _buildQuestionBox() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.95 + (value * 0.05),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.blue.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50.withOpacity(0.8),
                Colors.white,
                Colors.blue.shade50.withOpacity(0.5),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'QUESTION',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ],
              ),

              Text(
                widget.questionsText.toString(),

                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Current questionId: ${controller.questionId.value}");
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: CustomColors.meeting,
        elevation: 0,
        title: Text(
          'Upload Answers',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildQuestionBox(),
              SizedBox(height: Get.width * 0.02),
              Obx(
                () => Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Answer Image Captured',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${controller.capturedImages.length} of 5',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: controller.capturedImages.length / 5,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.meeting.withOpacity(0.8),
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),

              const SizedBox(height: 20),

              // Image grid
              Obx(
                () => Expanded(
                  child:
                      controller.capturedImages.isEmpty
                          ? _buildEmptyState(context)
                          : _buildImageGrid(controller),
                ),
              ),

              const SizedBox(height: 20),

              Column(
                children: [
                  Obx(() {
                    return controller.capturedImages.length == 5
                        ? _buildActionButton(
                          context: context,
                          icon: Icons.add_a_photo_rounded,
                          label: 'Add Images',
                          color: CustomColors.grey, // Disabled color
                          onTap: () {}, // Disabled action
                          width: Get.width * 0.5,
                        )
                        : _buildActionButton(
                          context: context,
                          icon: Icons.add_a_photo_rounded,
                          label: 'Add Images',
                          color: CustomColors.meeting,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              builder: (context) {
                                return SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Top handle bar
                                        Container(
                                          width: 40,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        // Camera option
                                        ListTile(
                                          leading: Lottie.asset(
                                            'assets/lottie/cameralottie.json',
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            'Camera',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Take a new photo',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.captureImage();
                                          },
                                        ),

                                        const Divider(),

                                        // Gallery option
                                        ListTile(
                                          leading: Lottie.asset(
                                            'assets/lottie/gallery.json',
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            'Gallery',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Choose from existing photos',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            controller.pickImageFromGallery();
                                          },
                                        ),

                                        const SizedBox(height: 12),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },

                          width: Get.width * 0.5,
                        );
                  }),

                  const SizedBox(height: 12),
                  _buildActionButton(
                    context: context,
                    icon: Icons.cloud_upload_rounded,
                    label: 'Submit All Images',
                    color: Colors.green[600]!,
                    onTap: () {
                      if (controller.capturedImages.isEmpty) {
                        Get.snackbar(
                          'No Sheets',
                          'Please capture at least one answer sheet',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red[400],
                          colorText: Colors.white,
                        );
                        return;
                      }
                      _showSubmitConfirmation(context, controller);
                    },
                  ),
                ],
              ).animate().slideY(
                begin: 0.2,
                end: 0,
                curve: Curves.easeOutQuart,
                duration: 500.ms,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_camera_back_rounded,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No Answer Images Captured',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the "Add Images" button to start',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildImageGrid(UploadAnswersController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: controller.capturedImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final image = controller.capturedImages[index];
          return GestureDetector(
            onTap: () => _showImagePreview(context, image),
            child: Stack(
              children: [
                // Image with shimmer effect
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 1000.ms),
                ),

                // Index badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: CustomColors.meeting,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap:
                        () =>
                            _showDeleteConfirmation(context, controller, index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    double? width, // 👈 Optional width parameter
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      color: color,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width:
              width ?? double.infinity, // 👈 Use provided width or full width
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, File image) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.file(image, fit: BoxFit.contain),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _deleteImage(image);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Delete'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _deleteImage(File image) {
    final index = controller.capturedImages.indexWhere(
      (file) => file.path == image.path,
    );
    if (index != -1) {
      controller.capturedImages.removeAt(index);
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    UploadAnswersController controller,
    int index,
  ) {
    if (Get.isDialogOpen ?? false) Get.back();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Delete this sheet?',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            content: Text(
              'Are you sure you want to remove this answer sheet?',
              style: GoogleFonts.poppins(),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.capturedImages.removeAt(index);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Delete',
                  style: GoogleFonts.poppins(
                    color: Colors.red[400],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _showSubmitConfirmation(
    BuildContext context,
    UploadAnswersController controller,
  ) {
    if (Get.isDialogOpen ?? false) Get.back();

    Future.delayed(const Duration(milliseconds: 100), () {
      showDialog(
        context: context,
        builder:
            (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 340),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_rounded,
                        size: 64,
                        color: CustomColors.meeting,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Total Answer Sheets : ${controller.capturedImages.length}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Please ensure all answer sheets are clearly visible before submitting.',
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.grey[400]!),
                              ),
                              child: Text(
                                'Review Again',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () async {
                                final uploadController =
                                    Get.find<UploadAnswersController>();
                                final bottomNavController =
                                    Get.find<BottomNavController>();
                                bottomNavController.changeIndex(3);
                                Get.offAll(() => MyHomePage());
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                );
                                uploadController.uploadImagesToAPI();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.meeting,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Submit Now',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      );
    });
  }
}
