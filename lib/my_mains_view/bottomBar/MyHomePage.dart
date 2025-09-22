import 'package:mains/app_imports.dart';
import 'package:mains/my_mains_view/TestScreens/workBookPage/work_book_pages.dart';
import 'package:mains/my_mains_view/my_library/controller.dart';

class MyHomePage extends StatefulWidget {
  final int initialLibraryTabIndex;
  MyHomePage({super.key, this.initialLibraryTabIndex = 0});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BottomNavController controller = Get.find();

  final List<TabIconData> tabIconsList = [
    TabIconData(
      imagePath: 'assets/images/home.png',
      selectedImagePath: 'assets/images/home.png',
      index: 0,
      isSelected: true,
      title: 'Home',
    ),
    TabIconData(
      imagePath: 'assets/images/bookb.png',
      selectedImagePath: 'assets/images/bookb.png',
      index: 1,
      isSelected: false,
      title: 'My Library',
    ),
    TabIconData(
      imagePath: 'assets/fitness_app/ai.png',
      selectedImagePath: 'assets/fitness_app/ai_selected.png',
      index: 2,
      isSelected: false,
      title: 'AI',
    ),
    TabIconData(
      imagePath: 'assets/images/exam.png',
      selectedImagePath: 'assets/images/exam.png',
      index: 3,
      isSelected: false,
      title: 'Result',
    ),
    TabIconData(
      imagePath: 'assets/images/gear.png',
      selectedImagePath: 'assets/images/gear.png',
      index: 4,
      isSelected: false,
      title: 'Settings',
    ),
  ];

  List<Widget> get _pages => [
    HomeScreenPage(),
    MyLibraryView(initialTabIndex: widget.initialLibraryTabIndex),
    VoiceScreen(key: UniqueKey(), isFromBottomNav: true),
    WorkBookPagesForTest(),
    ProfileScreen(),
  ];

  Widget _getCurrentPage(int index) {
    
    switch (index) {
      case 0:
        if (!Get.isRegistered<HomeScreenController>()) {
          Get.put(HomeScreenController(), permanent: true);
        }
        return HomeScreenPage();
        
      case 1:
        if (!Get.isRegistered<MyLibraryController>()) {
          Get.put(MyLibraryController(), permanent: true);
        }
        return MyLibraryView(initialTabIndex: widget.initialLibraryTabIndex);
        
      case 2:
        if (!Get.isRegistered<VoiceController>()) {
          Get.put(VoiceController(), permanent: true);
        }
        return VoiceScreen(key: UniqueKey(), isFromBottomNav: true);
        
      case 3:
        if (!Get.isRegistered<MainTestScreenController>()) {
          Get.put(MainTestScreenController(), permanent: true);
        }
        return WorkBookPagesForTest();
        
      case 4:
        if (!Get.isRegistered<ProfileController>()) {
          Get.put(ProfileController(), permanent: true);
        }
        return ProfileScreen();
        
      default:
        return HomeScreenPage();
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    return await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(
                  'Exit App',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                ),
                content: Text(
                  'Are you sure you want to exit?',
                  style: GoogleFonts.poppins(),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel', style: GoogleFonts.poppins()),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (Get.isRegistered<MyLibraryController>()) {
                        Get.find<MyLibraryController>().clearData();
                      }
                      await SystemNavigator.pop(animated: false);
                    },
                    child: Text(
                      'Exit',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Obx(() {
        int currentIndex = controller.currentIndex.value;
        
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: currentIndex == 2 ? 0 : 70),
                child: _getCurrentPage(currentIndex),
              ),
              if (currentIndex != 2)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: BottomBarView(
                    tabIconsList:
                        tabIconsList.map((tab) {
                          tab.isSelected = (tab.index == currentIndex);
                          return tab;
                        }).toList(),
                    changeIndex: (int index) {
                      controller.changeIndex(index);
                    },
                    addClick: () {
                      controller.changeIndex(2);
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
