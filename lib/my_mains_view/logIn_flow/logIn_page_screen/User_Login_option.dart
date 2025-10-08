import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/my_mains_view/logIn_flow/logIn_page_screen/terms&conditions.dart';
import 'controller.dart';

class UseerLogInScreen extends StatefulWidget {
  const UseerLogInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UseerLogInScreenState();
}

class _UseerLogInScreenState extends State<UseerLogInScreen>
    with SingleTickerProviderStateMixin {
  late UserLogInOption controller;
  final Color primaryColor = Color(0xFF6C63FF);
  final Color secondaryColor = Colors.white;
  final Color accentColor = Color.fromARGB(255, 102, 22, 2);
  final Color textColor = Color(0xFF333333);
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    controller = Get.put(UserLogInOption());
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.5, 1, curve: Curves.elasticOut),
      ),
    );
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: Get.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFC107), Color.fromARGB(255, 236, 87, 87)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      children: [
                        SizedBox(height: Get.height * 0.1),
                        // Logo/Icon with animation
                        Hero(
                          tag: 'app_logo',
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_circle,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        // Welcome text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Text(
                            "Welcome Back!",
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        SizedBox(height: 40),
                        // Phone input field
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text(
                                    "+91",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Container(
                                  height: 24,
                                  width: 1,
                                  color: Colors.grey.shade300,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: controller.phoneController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 10,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(10),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: "Enter mobile number",
                                      hintStyle: GoogleFonts.poppins(
                                        color: Colors.grey.shade400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 18,
                                      ),
                                      counterText: "",
                                    ),
                                    onChanged: (value) {
                                      controller.isPhoneValid.value =
                                          value.length == 10;
                                      controller.update();
                                      if (value.length == 10) {
                                        if (!controller.isTermsAccepted.value) {
                                          controller.isTermsAccepted.value =
                                              true;
                                        }
                                        FocusScope.of(context).unfocus();
                                        Future.delayed(
                                          Duration(milliseconds: 200),
                                          () {
                                            if (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                                Obx(
                                  () =>
                                      controller.isPhoneValid.value
                                          ? Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                          )
                                          : SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 30),

                        // Get OTP button (temporarily hidden - UI only)
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        //   child: Obx(
                        //     () => Container(
                        //       width: double.infinity,
                        //       height: 50,
                        //       child: ElevatedButton(
                        //         onPressed:
                        //             controller.isPhoneValid.value &&
                        //                     !controller.isLoading.value
                        //                 ? () {
                        //                   if (!controller
                        //                       .isTermsAccepted
                        //                       .value) {
                        //                     controller.isTermsAccepted.value =
                        //                         true;
                        //                   }
                        //                   controller.getOtp(
                        //                     this,
                        //                     controller.phoneController.text,
                        //                   );
                        //                 }
                        //                 : null,
                        //         style: ElevatedButton.styleFrom(
                        //           backgroundColor:
                        //               controller.isPhoneValid.value
                        //                   ? primaryColor
                        //                   : Color(0xFFF0F0F0),
                        //
                        //           padding: const EdgeInsets.symmetric(
                        //             vertical: 16,
                        //           ),
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(12),
                        //           ),
                        //           elevation: 2,
                        //         ),
                        //         child:
                        //             controller.isLoading.value
                        //                 ? SizedBox(
                        //                   height: 24,
                        //                   width: 24,
                        //                   child: CircularProgressIndicator(
                        //                     color: secondaryColor,
                        //                     strokeWidth: 2,
                        //                   ),
                        //                 )
                        //                 : Text(
                        //                   "Get OTP",
                        //                   style: GoogleFonts.poppins(
                        //                     color: secondaryColor,
                        //                     fontSize: 16,
                        //                     fontWeight: FontWeight.w500,
                        //                   ),
                        //                 ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20),

                        // // Divider with "OR"
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           height: 1,
                        //           color: Colors.white.withOpacity(0.3),
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 16),
                        //         child: Text(
                        //           "OR",
                        //           style: GoogleFonts.poppins(
                        //             color: Colors.white,
                        //             fontSize: 14,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Container(
                        //           height: 1,
                        //           color: Colors.white.withOpacity(0.3),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        // WhatsApp Login button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  controller.isPhoneValid.value
                                      ? () {
                                        controller.loginWithWhatsApp();
                                      }
                                      : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    controller.isPhoneValid.value
                                        ? Color(0xFF25D366)
                                        : Color(0xFFF0F0F0),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/whatsapp.png",
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Login with WhatsApp",
                                    style: GoogleFonts.poppins(
                                      color:
                                          controller.isPhoneValid.value
                                              ? Colors.white
                                              : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 150),
                        Center(
                          child: Obx(
                            () => TermsAndConditionsCheckbox(
                              value: controller.isTermsAccepted.value,
                              onAccepted: (value) {
                                controller.isTermsAccepted.value = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
