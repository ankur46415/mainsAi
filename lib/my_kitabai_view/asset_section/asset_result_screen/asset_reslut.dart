import 'package:mains/app_imports.dart';
import 'package:mains/model/asset_list.dart' as asset_list;
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:http/http.dart' as http;

class AssetReslut extends StatefulWidget {
  final String? assetUrl;
  final bool? isDirected;
  const AssetReslut({super.key, this.assetUrl, this.isDirected});

  @override
  State<AssetReslut> createState() => _AssetReslutState();
}

class _AssetReslutState extends State<AssetReslut> {
  late AssetResultController controller;
  final RxInt currentTabIndex = 0.obs;
  final fallbackVideoId = 'XujmFbMVKmU';
  late PageController _pageController;

  final List<String> tabTitles = [
    'Summary',
    'Objective',
    'Subjective',
    'Videos',
    'PYQs',
  ];

  @override
  void initState() {
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final String assetUrl = args['assetUrl'] ?? '';
    final bool isDirectPath = args['isDirectPath'] == true;

    controller = Get.put(
      AssetResultController(assetUrls: assetUrl, isDirectPath: isDirectPath),
    );
    controller.fetchQrResponse();
    _pageController = PageController();
    _pageController.addListener(() {
      int newIndex = _pageController.page?.round() ?? 0;
      if (currentTabIndex.value != newIndex) {
        currentTabIndex.value = newIndex;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildCustomTabBar() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(tabTitles.length, (index) {
          final isSelected = currentTabIndex.value == index;
          return GestureDetector(
            onTap: () {
              currentTabIndex.value = index;
              _pageController.jumpToPage(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? Colors.redAccent : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                tabTitles[index],
                style: GoogleFonts.poppins(
                  fontSize: Get.width * 0.03,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.redAccent : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Padding(
          padding: EdgeInsets.only(),
          child: Obx(() {
            final qrType = controller.assetData.value?.qrCodeType ?? '';
            final formatted =
                qrType.isNotEmpty
                    ? '${qrType[0].toUpperCase()}${qrType.substring(1)} Asset'
                    : 'Asset';

            return Text(
              formatted,
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            );
          }),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: LoadingWidget());
          }
          return Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildCustomTabBar(),
                const Divider(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      currentTabIndex.value = index;
                    },
                    children: [
                      // Summary Tab
                      controller.summaries.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No summaries available',
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Please check back later or refresh the page.',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: controller.summaries.length,
                            itemBuilder: (context, index) {
                              final item = controller.summaries[index];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Obx(() {
                                        final bookTitle =
                                            controller.bookList.isNotEmpty
                                                ? controller
                                                        .bookList
                                                        .first
                                                        .title ??
                                                    ''
                                                : '';
                                        final titelName =
                                            bookTitle.isNotEmpty
                                                ? '${bookTitle[0].toUpperCase()}${bookTitle.substring(1)}'
                                                : '';

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            titelName,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: Get.width * 0.05,
                                    ),
                                    child: Text(
                                      "Summery",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      elevation: 7,
                                      color: Colors.white,
                                      child: ListTile(
                                        title: Text(
                                          item.content ??
                                              'No Summary Available',
                                          textAlign: TextAlign.justify,
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: Get.width * 0.14),
                                ],
                              );
                            },
                          ),
                      // Objective Tab
                      _buildObjectiveTab(),
                      // Subjective Tab
                      _buildSubjectiveTab(),
                      // Videos Tab
                      controller.videos.isEmpty
                          ? _buildFallbackVideo()
                          : ListView.builder(
                            itemCount: controller.videos.length,
                            itemBuilder: (context, index) {
                              final video = controller.videos[index];
                              return ListTile(
                                leading: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.redAccent,
                                ),
                                title: Text("Video ${index + 1}"),
                                subtitle: Text(video.toString()),
                              );
                            },
                          ),
                      // PYQs Tab
                      controller.pyqs.isEmpty
                          ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help_outline,
                                    size: 80,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "No PYQs available.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Past Year Questions will appear here when available.",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                          : ListView.builder(
                            itemCount: controller.pyqs.length,
                            itemBuilder: (context, index) {
                              final pyq = controller.pyqs[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Colors.white,
                                  elevation: 5,
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.article_outlined,
                                      color: Colors.redAccent,
                                    ),
                                    title: Text(
                                      "PYQ ${index + 1}",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      pyq.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() {
        if (controller.isLoading.value) return SizedBox.shrink();
        return GestureDetector(
          onTap: () {
            Get.off(() => VoiceScreen(initialChatMode: true));
          },
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.red.shade600, Colors.blue.shade400],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.9),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(child: Icon(Icons.mic, color: Colors.white)),
          ),
        );
      }),
    );
  }

  Widget _buildObjectiveTab() {
    final List<String> levels = ['L1', 'L2', 'L3'];
    final Map<String, List<asset_list.L1>> levelMap = {
      'L1': controller.objectiveL1,
      'L2': controller.objectiveL2,
      'L3': controller.objectiveL3,
    };

    return DefaultTabController(
      length: levels.length,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              labelColor: Colors.white,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.red,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.18),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              tabs:
                  levels
                      .map(
                        (level) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(level),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children:
                  levels.map((level) {
                    final sets = levelMap[level] ?? [];
                    if (sets.isEmpty) {
                      return Center(
                        child: Text(
                          'No $level sets available.',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: sets.length,
                      itemBuilder: (context, index) {
                        final obj = sets[index];
                        final totalQuestions =
                            obj.totalQuestions ?? obj.questions?.length ?? 0;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: ListTile(
                            title: Text(
                              obj.name ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              "Questions: $totalQuestions",
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                if ((obj.questions?.isNotEmpty ?? false)) {
                                  Get.toNamed(
                                    AppRoutes.questionView,
                                    arguments: {
                                      'questions': obj.questions!,
                                      'title': obj.name ?? "Questions",
                                    },
                                  );
                                } else {
                                  Get.snackbar(
                                    "No Questions",
                                    "This set has no questions yet.",
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 130, 128, 238),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(22),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "Start",
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectiveTab() {
    final setsMap =
        controller.assetData.value?.subjectiveQuestionSets?.toJson() ?? {};
    final levels = setsMap.keys.toList();
    if (levels.isEmpty ||
        levels.every((key) => (setsMap[key] as List?)?.isEmpty ?? true)) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.text_snippet_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No subjective content available.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Check back later or try a different asset.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    if (levels.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.text_snippet_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No subjective content available.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Check back later or try a different asset.",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return DefaultTabController(
      length: levels.length,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.08),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              dividerColor: Colors.transparent,
              isScrollable: true,
              labelColor: Colors.white,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Colors.red,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.18),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              indicatorPadding: EdgeInsets.symmetric(
                vertical: 6,
                horizontal: 8,
              ),
              tabs:
                  levels
                      .map(
                        (level) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: Text(level),
                        ),
                      )
                      .toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children:
                  levels.map((level) {
                    final sets = setsMap[level] as List<dynamic>? ?? [];
                    return ListView.builder(
                      itemCount: sets.length,
                      itemBuilder: (context, index) {
                        final set = sets[index];
                        final setName = set['name'] ?? 'No Set Name';
                        final questions =
                            set['questions'] as List<dynamic>? ?? [];
                        final levelText = set['level']?.toString() ?? '';
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: Colors.white,
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                setName,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing:
                                  levelText.isNotEmpty
                                      ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            255,
                                            124,
                                            126,
                                            235,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            45,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            levelText,
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      : null,
                              onTap: () {
                                Get.toNamed(
                                  AppRoutes.subjectiveSetDetail,
                                  arguments: {
                                    'setName': setName,
                                    'questions': questions,
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackVideo() {
    String extractYoutubeId(String url) {
      final uri = Uri.tryParse(url);
      if (uri == null) return '';
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
      } else if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'] ?? '';
      }
      return '';
    }

    final _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    _controller.loadVideoById(videoId: fallbackVideoId);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: YoutubePlayer(controller: _controller),
          ),
        ],
      ),
    );
  }
}
