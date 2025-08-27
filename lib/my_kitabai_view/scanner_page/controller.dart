import 'package:mains/app_imports.dart';

class ScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController();
  RxString scannedCode = ''.obs;
  var hasNavigated = false.obs;
  var isScanning = true.obs;
  DateTime? lastScanTime;
  static const scanDebounceTime = Duration(milliseconds: 500);
  bool isDialogShowing = false;

  @override
  void onInit() {
    super.onInit();
    print('ScannerController: Initialized');
    resetScanner();
  }

  @override
  void onClose() {
    print('ScannerController: Closing and disposing camera');
    cameraController.dispose();
    super.onClose();
  }

  void resetScanner() {
    print('ScannerController: Resetting scanner state');
    hasNavigated.value = false;
    scannedCode.value = '';
    isScanning.value = true;
    isDialogShowing = false;
    lastScanTime = null;
    if (!cameraController.isStarting) {
      print('ScannerController: Starting camera');
      cameraController.start();
    }
  }

  void stopScanner() {
    print('ScannerController: Stopping scanner');
    isScanning.value = false;
    hasNavigated.value = true;
    if (cameraController.isStarting) {
      print('ScannerController: Stopping camera');
      cameraController.stop();
    }
  }

  bool canScan() {
    if (!isScanning.value) return false;

    final now = DateTime.now();
    if (lastScanTime != null) {
      final timeSinceLastScan = now.difference(lastScanTime!);
      if (timeSinceLastScan < scanDebounceTime) {
        return false;
      }
    }
    return true;
  }

  void onDetect(BarcodeCapture capture, BuildContext context) async {
    if (!isScanning.value || hasNavigated.value || isDialogShowing) {
      print(
        'ScannerController: Ignoring scan - isScanning: ${isScanning.value}, hasNavigated: ${hasNavigated.value}, isDialogShowing: $isDialogShowing',
      );
      return;
    }

    print('ScannerController: BarcodeCapture received:');
    for (final barcode in capture.barcodes) {
      print('--- Barcode Detected ---');
      print('Raw Value: ${barcode.rawValue}');
      print('Display Value: ${barcode.displayValue}');
      print('Format: ${barcode.format}');
      print('Type: ${barcode.type}');
    }

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;

      if (value != null && value.isNotEmpty) {
        print('ScannerController: QR Code detected');
        hasNavigated.value = true;
        isScanning.value = false;
        isDialogShowing = true;

        try {
          // Extract question ID from the scanned URL
          final uri = Uri.tryParse(value);
          String? questionId;
          if (uri != null && uri.pathSegments.isNotEmpty) {
            // Look for 'question' in the path, then get the next segment as ID
            final idx = uri.pathSegments.indexOf('question');
            if (idx != -1 && idx + 1 < uri.pathSegments.length) {
              questionId = uri.pathSegments[idx + 1];
            }
          }

          if (questionId == null || questionId.isEmpty) {
            print(
              'ScannerController: Could not extract question ID from QR code URL',
            );
            return;
          }

          final apiUrl = '${ApiUrls.viewQRQuestionBase}$questionId/view';
          print('ScannerController: Hitting API: $apiUrl');
          await callWebApiGet(
            null,
            apiUrl,
            onResponse: (response) {
              if (response.statusCode == 200) {
                final jsonData = jsonDecode(response.body);
                print('ScannerController: API Response: $jsonData');
                final data = jsonData['data'];
                final String extractedId = data['id'] ?? questionId;
                final String questionText = data['question'] ?? '';
                stopScanner();
                showCustomDialog(context, extractedId, questionText);
              } else {
                print(
                  'ScannerController: API call failed with status: ${response.statusCode}',
                );
              }
            },
            onError: () {
              print('ScannerController: Error while calling API');
            },
            showLoader: false,
            hideLoader: false,
          );
        } catch (e) {
          print('ScannerController: Error while calling API: $e');
        }

        break; // Only handle the first QR
      }
    }
  }

  void toggleFlash() {
    cameraController.toggleTorch();
  }

  void showCustomDialog(
    BuildContext context,
    String questionId,
    String questionText,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        final RxBool isExpanded =
            false.obs; // ✅ define here to keep dialog state local

        return WillPopScope(
          onWillPop: () async {
            isDialogShowing = false;
            resetScanner();
            return true;
          },
          child: Dialog(
            insetPadding: const EdgeInsets.all(24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  // ✅ wrap to allow scroll if needed
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (questionId.isNotEmpty && questionText.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.shade100,
                              width: 1.5,
                            ),
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
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Obx(
                                  () => Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Question: ',
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(
                                          text: questionText,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    maxLines: isExpanded.value ? null : 5,
                                    overflow:
                                        isExpanded.value
                                            ? TextOverflow.visible
                                            : TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                GestureDetector(
                                  onTap: () {
                                    isExpanded.toggle();
                                  },
                                  child: Obx(
                                    () => Text(
                                      isExpanded.value
                                          ? "See less"
                                          : "See more",
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Upload button
                      if (questionId.isNotEmpty && questionText.isNotEmpty)
                        _buildOptionCard(
                          context,
                          icon: Icons.cloud_upload_rounded,
                          title: 'Upload Answer',
                          subtitle: 'Upload Your Answer Sheets',
                          color: Colors.blue,
                          onTap: () async {
                            Navigator.of(context).pop();
                            Get.off(
                              () => UploadAnswers(
                                questionId: questionId,
                                questionsText: questionText,
                              ),
                            );
                            await cameraController.stop();
                          },
                        ),

                      // Manual button
                      if (questionId.isEmpty || questionText.isEmpty)
                        _buildOptionCard(
                          context,
                          icon: Icons.qr_code_scanner_rounded,
                          title: 'Manual',
                          subtitle: 'Manual',
                          color: Colors.green,
                          onTap: () async {
                            Navigator.of(context).pop();
                            Get.off(
                              () => QrResultScreen(qrresult: scannedCode.value),
                            );
                            await cameraController.stop();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      isDialogShowing = false;
    });
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          print('ScannerController: Option tapped: $title');
          stopScanner();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void switchCamera() {
    cameraController.switchCamera();
  }
}

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScannerController());
  }
}
