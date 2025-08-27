import 'app_imports.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (kDebugMode) {
    debugPaintSizeEnabled = false;
    debugPaintBaselinesEnabled = false;
    debugPaintPointersEnabled = false;
    debugRepaintRainbowEnabled = false;
    debugProfilePaintsEnabled = false;
    debugProfileBuildsEnabled = false;
  }

  if (kReleaseMode) {
    debugProfilePaintsEnabled = false;
    debugProfileBuildsEnabled = false;
  }

  try {
    final authService = await AuthService().init();
    Get.put(authService);

    Widget initialScreen;

    if (authService.isLoggedIn) {
      await Future.microtask(() {
        Get.put(BottomNavController(), permanent: true);
        Get.put(HomeScreenController(), permanent: true);
      });

      Get.find<BottomNavController>().currentIndex.value = 0;

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.find<HomeScreenController>().dashBoardData(forceRefresh: true);
      });

      initialScreen = MyHomePage();
    } else {
      initialScreen = IntroMainScreen();
    }

    runApp(MyApp(initialScreen: initialScreen));
  } catch (e) {
    runApp(MyApp(initialScreen: IntroMainScreen()));
  }
}

class MyApp extends StatelessWidget {
  final Widget? initialScreen;
  const MyApp({super.key, this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'mains',
      debugShowCheckedModeBanner: false,
      initialBinding: AppBindings(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialScreen,
      defaultTransition: Transition.fadeIn,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
      getPages: appPages,
    );
  }
}
