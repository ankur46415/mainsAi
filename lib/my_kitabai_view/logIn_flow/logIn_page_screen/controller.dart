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
        } else {
          print("Server Error: ${response.statusCode}");
        }
      },
      onError: (errorResponse) {
        Utils.hideLoader();

        final errorResponseData = jsonDecode(errorResponse.body);

        String errorMessage =
            errorResponseData['msg'] ??
            "Something went wrong. Please try again.";
        print("Error Message: $errorMessage");
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
