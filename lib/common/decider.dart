import '../app_imports.dart';

class Decider extends StatelessWidget {
  const Decider({super.key});

  Future<Widget> _getInitialScreen() async {
    final authService = Get.find<AuthService>();
    final isLoggedIn = authService.isLoggedIn;

    if (isLoggedIn) {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getInitialScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
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
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            ),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
