import 'package:mains/app_imports.dart';

class AiTestHome extends StatefulWidget {
  const AiTestHome({super.key});

  @override
  State<AiTestHome> createState() => _AiTestHomeState();
}

class _AiTestHomeState extends State<AiTestHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        toolbarHeight: 20,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            labelColor: Colors.red.shade700,
            unselectedLabelColor: Colors.black87,
            labelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            indicatorColor: Colors.red,
            indicatorWeight: 2,
            tabs: const [Tab(text: "Prelims"), Tab(text: "Mains")],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [TestCategoriesObjectivePage(), AiTestSubHome()],
      ),
    );
  }
}
