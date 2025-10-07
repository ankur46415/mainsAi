import '../app_imports.dart';
import '../my_mains_view/logIn_flow/register_user_profile/mian_profile_setup_page.dart';

class Decider extends StatelessWidget {
  const Decider({super.key});

  Future<Widget> _getInitialScreen() async {
    final authService = Get.find<AuthService>();
    final isLoggedIn = authService.isLoggedIn;

    if (isLoggedIn) {
      final prefs = await SharedPreferences.getInstance();
      final savedMobile = prefs.getString('login_mobile');

      // If profile was just completed, skip one-time login check and clear flag
      final justCompleted = prefs.getBool('profile_just_completed') ?? false;
      if (justCompleted == true) {
        await prefs.remove('profile_just_completed');
        // proceed to home directly
      } else if (savedMobile != null && savedMobile.isNotEmpty) {
        // Otherwise check latest status via login
        final result = await _checkViaLogin(savedMobile);
        if (result == 1511) {
          return ProfileSetupPage();
        } else if (result == 1510) {
          // proceed to home below
        } else {
          final isProfileComplete = prefs.getBool('is_profile_complete') ?? false;
          if (!isProfileComplete) return ProfileSetupPage();
        }
      } else {
        final isProfileComplete = prefs.getBool('is_profile_complete') ?? false;
        if (!isProfileComplete) return ProfileSetupPage();
      }

      if (!Get.isRegistered<BottomNavController>()) {
        Get.put(BottomNavController(), permanent: true);
      }
      if (!Get.isRegistered<HomeScreenController>()) {
        Get.put(HomeScreenController(), permanent: true);
      }

      final bottomNavController = Get.find<BottomNavController>();
      bottomNavController.currentIndex.value = 0;

      final homeController = Get.find<HomeScreenController>();
      homeController.dashBoardData(forceRefresh: true);

      return MyHomePage();
    } else {
      return IntroMainScreen();
    }
  }

  Future<int?> _checkViaLogin(String mobile) async {
    int? code;
    await callWebApi(
      null,
      ApiUrls.register,
      {'mobile': mobile},
      showLoader: false,
      hideLoader: false,
      onResponse: (response) async {
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          code = data['responseCode'];

          // Persist fresh token so subsequent calls don't 401
          final token = data['token'];
          if (token is String && token.isNotEmpty) {
            try {
              final authService = Get.find<AuthService>();
              await authService.setToken(token);
            } catch (_) {}
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('is_profile_complete', data['is_profile_complete'] == true);
        }
      },
      onError: () {},
    );
    return code;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
