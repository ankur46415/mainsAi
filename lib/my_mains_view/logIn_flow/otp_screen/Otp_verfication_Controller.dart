import '../../../common/utils.dart';
import '../../../common/decider.dart';
import '../../../app_imports.dart';
import '../register_user_profile/mian_profile_setup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerificationController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  var isLoggedIn = false.obs;
  var otpCode = ''.obs;
  var isLoading = false.obs;
  var verificationSuccess = false.obs;
  var token = ''.obs;

  bool get isOtpComplete => otpCode.value.length == 6;

  void onOtpSubmitted(String code) {
    otpCode.value = code;
  }

  Future<void> verifyOtp({
    required TickerProvider tickerProvider,
    required String mobile,
    required String otp,
    String? deviceId,
    String? model,
    bool isWhatsAppOtp = false,
  }) async {
    final body = {
      'mobile': mobile,
      'otp': otp,
      'device_id': deviceId ?? "your-device-id",
      'model': model ?? "your-device-model",
    };

    try {
      String apiUrl =
          isWhatsAppOtp
              ? "https://test.ailisher.com/api/whatsapp/verify-otp"
              : ApiUrls.verifyOtp;

      if (isWhatsAppOtp) {
        body['client'] = 'ailisher';
      }

      await callWebApi(
        tickerProvider,
        apiUrl,
        body,
        showLoader: true,
        hideLoader: false,
        onResponse: (response) async {
          final responseData = jsonDecode(response.body);

          // Handle WhatsApp OTP response (different structure)
          if (isWhatsAppOtp &&
              response.statusCode == 200 &&
              responseData['success'] == true) {
            verificationSuccess.value = true;

            // For WhatsApp OTP, we need to call the login API to get the proper response code
            await loginUserForWhatsApp(tickerProvider, mobile);
          }
          // Handle regular OTP response
          else if (response.statusCode == 200 && responseData['code'] == 2300) {
            verificationSuccess.value = true;
            token.value = responseData['data']['token'];

            if (responseData['data'] != null) {
              final userData = responseData['data'];

              if (userData['user_id'] != null && userData['email'] != null) {
                await _authService.setUserData(
                  userId: userData['user_id'],
                  userEmail: userData['email'],
                  userName:
                      "${userData['first_name'] ?? ''} ${userData['last_name'] ?? ''}"
                          .trim(),
                  userPhone: mobile,
                );
              } else {}
            } else {}

            await registerUser(
              tickerProvider: tickerProvider,
              mobile: mobile,
              responseCode: responseData['responseCode'],
            );
          } else {
            Utils.hideLoader();
            throw Exception(
              responseData['message'] ?? "OTP verification failed",
            );
          }
        },
        onError: (errorResponse) {
          Utils.hideLoader();
          try {
            final errorData = jsonDecode(errorResponse.body);
            return errorData;
          } catch (e) {
            throw Exception(e.toString());
          }
        },
      );
    } catch (e) {
      Utils.hideLoader();
      throw Exception(e.toString());
    }
  }

  Future<void> loginUserForWhatsApp(
    TickerProvider tickerProvider,
    String mobile,
  ) async {
    final body = {'mobile': mobile};

    await callWebApi(
      tickerProvider,
      ApiUrls.register,
      body,
      showLoader: false,
      hideLoader: false,
      onResponse: (response) async {
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          String? token = responseData['token'];
          int? code = responseData['responseCode'];
          isLoggedIn.value = true;

          if (token != null) {
            await _authService.setToken(token);

            // Persist the login mobile for Decider routing
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('login_mobile', mobile);
            await prefs.setBool(
              'is_profile_complete',
              responseData['is_profile_complete'] == true,
            );

            if (responseData['user_id'] != null) {
              await _authService.setUserData(
                userId: responseData['user_id'],
                userEmail: responseData['email'] ?? "mobishaala@gmail.com",
                userName: responseData['profile']?['name'] ?? "User",
                userPhone: mobile,
              );
            }

            Utils.hideLoader();

            if (code == 1510) {
              Get.offAll(() => const Decider());
            } else if (code == 1511) {
              Get.offAll(() => ProfileSetupPage());
            } else {
              Get.snackbar(
                "Notice",
                "Unexpected response code: $code",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade100,
                colorText: Colors.black,
              );
            }
          }
        } else {
          Utils.hideLoader();
          Get.snackbar(
            "Error",
            "Login failed. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onError: (errorResponse) {
        Utils.hideLoader();
        Get.snackbar(
          "Error",
          "Login failed. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Future<void> registerUser({
    required TickerProvider tickerProvider,
    required String mobile,
    int? responseCode,
  }) async {
    final body = {'mobile': mobile};

    await callWebApi(
      tickerProvider,
      ApiUrls.register,
      body,
      showLoader: false,
      hideLoader: false,
      onResponse: (response) async {
        final responseData = jsonDecode(response.body);

        if (response.statusCode == 200) {
          String? token = responseData['token'];
          int? code = responseCode ?? responseData['responseCode'];
          bool isProfileComplete = responseData['is_profile_complete'] == true;
          isLoggedIn.value = true;

          if (token != null) {
            await _authService.setToken(token);

            // Save profile completeness status and login mobile to SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('is_profile_complete', isProfileComplete);
            await prefs.setString('login_mobile', mobile);

            if (responseData['user_id'] != null) {
              await _authService.setUserData(
                userId: responseData['user_id'],
                userEmail: responseData['email'] ?? "mobishaala@gmail.com",
                userName: responseData['profile']?['name'] ?? "User",
                userPhone: mobile,
              );
            } else {}
            Utils.hideLoader();
            if (code == 1510) {
              Get.offAll(() => const Decider());
            } else if (code == 1511) {
              Get.offAll(() => ProfileSetupPage());
            } else {
              Get.snackbar(
                "Notice",
                "Unexpected response code: $code",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange.shade100,
                colorText: Colors.black,
              );
            }
          }
        } else {
          throw Exception();
        }
      },
      onError: (errorResponse) {
        Utils.hideLoader();
        throw Exception(errorResponse.toString());
      },
    );
  }
}

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpVerificationController());
  }
}
