import '../../../app_imports.dart';
import '../../../common/utils.dart';
import '../otp_screen/Otp_verification.dart';

class UserLogInOption extends GetxController {
  RxBool isPhoneValid = false.obs;
  RxBool isLoading = false.obs;
  var isTermsAccepted = false.obs;

  final TextEditingController phoneController = TextEditingController();

  Future<void> getOtp(TickerProvider tickerProvider, String phone) async {
    if (!isTermsAccepted.value) {
      Get.snackbar(
        "Terms Required",
        "Please accept the Terms & Conditions before proceeding",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await callWebApi(
      tickerProvider,
      ApiUrls.getOtp,
      {"mobile": phone},
      showLoader: true,
      hideLoader: true,
      onResponse: (response) async {
        Utils.hideLoader();
        if (response.statusCode == 200) {
          Get.to(() => OtpVerification(mobile: phone));
        } else {}
      },
      onError: (errorResponse) {
        Utils.hideLoader();

        final errorResponseData = jsonDecode(errorResponse.body);

        String errorMessage =
            errorResponseData['msg'] ??
            "Something went wrong. Please try again.";

        Get.snackbar(
          "Error",
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> loginWithWhatsApp() async {
    if (!isTermsAccepted.value) {
      Get.snackbar(
        "Terms Required",
        "Please accept the Terms & Conditions before proceeding",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isPhoneValid.value) {
      Get.snackbar(
        "Phone Required",
        "Please enter a valid mobile number",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Send WhatsApp OTP
      await sendWhatsAppOtp();
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Failed to send WhatsApp OTP. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> sendWhatsAppOtp() async {
    final mobile = "${phoneController.text}";

    await callWebApi(
      null,
      "https://test.ailisher.com/api/whatsapp/send-otp",
      {"mobile": mobile, "client": "ailisher"},
      showLoader: false,
      hideLoader: false,
      onResponse: (response) async {
        isLoading.value = false;
        if (response.statusCode == 200) {
          Get.snackbar(
            "OTP Sent",
            "WhatsApp OTP has been sent to your number",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          // Navigate to OTP verification with WhatsApp flag
          Get.to(
            () => OtpVerification(
              mobile: phoneController.text,
              isWhatsAppOtp: true,
            ),
          );
        } else {
          Get.snackbar(
            "Error",
            "Failed to send WhatsApp OTP",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onError: (errorResponse) {
        isLoading.value = false;
        Get.snackbar(
          "Error",
          "Failed to send WhatsApp OTP. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }
}

class UserLogInOptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UserLogInOption());
  }
}
