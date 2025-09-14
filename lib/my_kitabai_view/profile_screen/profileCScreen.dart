import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mains/app_routes.dart';
import 'package:mains/my_kitabai_view/auth_service/auth_service.dart';
import 'package:mains/my_kitabai_view/creidt/controller.dart';
import 'package:mains/my_kitabai_view/creidt/ui_card.dart';
import 'package:mains/my_kitabai_view/profile_screen/profile_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../common/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  late ProfileController controller;
  late CreditBalanceController creditController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ProfileController());
    creditController = Get.put(CreditBalanceController());

    // Call APIs on first load
    controller.fetchUserProfile();
    creditController.fetchCreditBalance();
  }

  @override
  void didPopNext() {
    // Called when user comes back to ProfileScreen
    controller.fetchUserProfile();
    creditController.fetchCreditBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.fetchUserProfile();
            creditController
                .fetchCreditBalance(); // Call CreditCard API refresh
          },
          child: Obx(() {
            final profile = controller.userProfile.value?.profile;

            if (controller.isLoading.value) {
              return _buildLoading();
            }

            if (profile == null) return const SizedBox.shrink();

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileCard(profile),
                  const SizedBox(height: 24),

                  CreditCard(),
                  const SizedBox(height: 24),
                  _buildSettingsOption(
                    icon: Icons.history,
                    title: "Payment History",
                    onTap: () => Get.toNamed(AppRoutes.payHistory),
                  ),
                  _buildSettingsOption(
                    icon: Icons.history,
                    title: "Plans",
                    onTap: () => Get.toNamed(AppRoutes.plans),
                  ),
                  if (profile.isEvaluator == true)
                    _buildSettingsOption(
                      icon: Icons.admin_panel_settings,
                      title: "Evaluator",
                      onTap: () => Get.toNamed(AppRoutes.listOfSubmissions),
                    ),

                  _buildSettingsOption(
                    icon: Icons.feedback,
                    title: "Feedback",
                    onTap: () => Get.toNamed(AppRoutes.feedback),
                  ),
                  _buildSettingsOption(
                    icon: Icons.description,
                    title: "Terms & Conditions",
                    onTap: () async {
                      final Uri url = Uri.parse(
                        "https://mobishaala.com/assets/files/pp.pdf",
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "Could not launch Terms & Conditions PDF",
                        );
                      }
                    },
                  ),

                  _buildSettingsOption(
                    icon: Icons.help,
                    title: "Help",
                    onTap: () {
                      Get.toNamed(AppRoutes.helpScreen);
                    },
                  ),
                  _buildSettingsOption(
                    icon: Icons.logout,
                    title: "Logout",
                    isLogout: true,
                    onTap: _handleLogout,
                  ),

                  // _buildShareCard(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: false,
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
    title: Text(
      "Profile",
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _buildLoading() => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Lottie.asset(
        'assets/lottie/book_loading.json',
        height: 200,
        width: 200,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(['**'], value: Colors.red),
          ],
        ),
      ),
    ),
  );

  Widget _buildProfileCard(profile) => Stack(
    children: [
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name ?? 'No Name',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (profile.mobile != null) ...[
                const SizedBox(height: 4),
                Text(
                  profile.mobile!,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              _buildProfileDetailRow(
                Icons.transgender,
                "Gender",
                profile.gender,
              ),
              _buildProfileDetailRow(
                Icons.language,
                "Native Language",
                profile.nativeLanguage,
              ),
              if (profile.exams?.isNotEmpty == true)
                _buildProfileDetailRow(
                  Icons.school,
                  "Target Exams",
                  profile.exams!.join(', '),
                ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 12,
        right: 12,
        child: GestureDetector(
          onTap: controller.showEditProfileDialog,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CustomColors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Icon(Icons.edit, size: 18, color: CustomColors.primaryColor),
          ),
        ),
      ),
    ],
  );

  Widget _buildProfileDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          Text(
            value ?? 'Not specified',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.black87),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isLogout ? Colors.red : Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        minLeadingWidth: 0,
      ),
    );
  }

  Widget _buildShareCard() => SizedBox(
    width: Get.width,
    height: Get.width * 0.17,
    child: Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              "Share with friends",
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () {
                const appLink =
                    'https://play.google.com/store/apps/details?id=com.mainsapp&pcampaignid=web_share';
                Share.share('''🤖📚 Meet Your AI Mentor – mains!
Get instant answers from your books, personalized guidance, and smart AI-powered tests to boost your performance.
📲 Download now: $appLink''');
              },
              icon: const Icon(Icons.share, color: Colors.white),
              label: Text(
                'Share App',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _handleLogout() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.logout, size: 40, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    "Are you sure you want to logout?",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You will need to log in again to continue using the app.",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Cancel", style: GoogleFonts.poppins()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final authService = Get.find<AuthService>();
                            await authService.logout();
                            await authService.clearToken();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text("Logout", style: GoogleFonts.poppins()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
