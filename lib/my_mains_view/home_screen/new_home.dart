import '../../app_imports.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({super.key});

  @override
  State<HomeScreenPage> createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late HomeScreenController controller;
  late TabController _tabController;

  @override
  void initState() {
    controller = Get.put(HomeScreenController());

    int initialTabIndex = 0;

    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      initialTabIndex = args['tabIndex'] ?? 0;
    }

    // Ensure initial index is within bounds of tabs length
    const int tabsLength = 2;
    if (initialTabIndex < 0 || initialTabIndex >= tabsLength) {
      debugPrint(
          'HomeScreenPage -> Adjusting out-of-range tabIndex: ' + initialTabIndex.toString() + ' to bounds of ' + tabsLength.toString());
      initialTabIndex = 0;
    }

    _tabController = TabController(
      length: tabsLength,
      vsync: this,
      initialIndex: initialTabIndex,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final tabControllerManager = Get.find<TabControllerManager>();
        tabControllerManager.setTabController(_tabController);
        tabControllerManager.setIndex(initialTabIndex);
        if (initialTabIndex >= 0 && initialTabIndex < _tabController.length) {
          tabControllerManager.animateTo(initialTabIndex);
        }
      } catch (e) {
        debugPrint('HomeScreenPage -> TabControllerManager not found: ' + e.toString());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: CustomTabBar(tabController: _tabController),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [const WorkBookBookPage(), AiTestHome()],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
