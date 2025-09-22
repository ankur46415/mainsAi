import '../../../app_imports.dart';
import 'Otp_verfication_Controller.dart';

class OtpVerification extends StatefulWidget {
  final String? mobile;
  const OtpVerification({super.key, this.mobile});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification>
    with SingleTickerProviderStateMixin {
  final Color primaryColor = Color(0xffe64d53);
  final Color secondaryColor = Colors.white;
  final Color successColor = Color(0xFF4CAF50);
  final Color textColor = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    final OtpVerificationController controller = Get.put(
      OtpVerificationController(),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "OTP Verification",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: Get.width * 0.15),
                Icon(
                  Icons.verified_user_outlined,
                  size: 100,
                  color: primaryColor,
                ),
                SizedBox(height: 24),
                Text(
                  "Verification Code",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "We've sent a 6-digit code to "),
                      TextSpan(
                        text: widget.mobile,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                InkWell(
                  onTap: () => Get.back(),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.edit, size: 16, color: primaryColor),
                      SizedBox(width: 4),
                      Text(
                        "Edit number",
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // OTP Input Field
                Pinput(
                  length: 6,
                  defaultPinTheme: PinTheme(
                    width: 48,
                    height: 56,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 20,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: CustomColors.dateHeaderColor),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 48,
                    height: 56,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 20,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: primaryColor, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  onChanged: (value) {
                    controller.otpCode.value = value;
                  },
                  onCompleted: (value) {
                    controller.onOtpSubmitted(value);
                  },
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive code? ",
                      style: GoogleFonts.poppins(
                        color: textColor.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // controller.resendOtp(
                        //   tickerProvider: this,
                        //   mobile: widget.mobile ?? '',
                        // );
                      },
                      child: Text(
                        "Resend OTP",
                        style: GoogleFonts.poppins(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.width * 0.35),
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isOtpComplete
                            ? () {
                              controller.verifyOtp(
                                tickerProvider: this,
                                mobile: widget.mobile.toString(),
                                otp: controller.otpCode.value,
                                deviceId: "your-device-id",
                                model: "your-device-model",
                              );
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          controller.isOtpComplete
                              ? primaryColor
                              : Colors.grey.shade400,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      "Verify & Continue",
                      style: GoogleFonts.poppins(
                        color: secondaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
