import 'package:mains/app_imports.dart';

class AssetQrScanner extends StatefulWidget {
  const AssetQrScanner({super.key});

  @override
  State<AssetQrScanner> createState() => _AssetQrScannerState();
}

class _AssetQrScannerState extends State<AssetQrScanner> {
  late AsssetQrController controller;
  late MobileScannerController cameraController;

  RxBool isScannerActive = true.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AsssetQrController());
    cameraController = MobileScannerController(facing: CameraFacing.back);
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void restartScanner() {
    cameraController.start();
    isScannerActive.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: Text(
          "Get Asset",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (barcodeCapture) {
              if (controller.isScanning) {
                cameraController.stop();
                isScannerActive.value = false;
                controller.handleQrDetection(barcodeCapture);
              }
            },
          ),
          Obx(
            () =>
                !isScannerActive.value
                    ? Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: ElevatedButton.icon(
                          onPressed: restartScanner,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(
                            Icons.qr_code_scanner,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Scan Again",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
