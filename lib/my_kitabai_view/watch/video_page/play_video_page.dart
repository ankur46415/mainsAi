import '../../../app_imports.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'play_video_controller.dart';

class PlayVideoPage extends StatefulWidget {
  final List<Topics> topics;
  final int initialIndex;

  const PlayVideoPage({
    Key? key,
    required this.topics,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<PlayVideoPage> createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  late PlayVideoController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      PlayVideoController(widget.topics, widget.initialIndex),
    );
  }

  @override
  void dispose() {
    controller.youtubeController.close();
    controller.isFullScreen.value = false;
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.white,
        appBar:
            controller.isFullScreen.value
                ? null
                : CustomAppBar(title: "Watch Lectures"),

        body: SingleChildScrollView(
          child: YoutubePlayerControllerProvider(
            controller: controller.youtubeController,
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                SizedBox(height: Get.width*0.02,),
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: controller.youtubeController,
                          aspectRatio: 16 / 9,
                        ),
                      ),

                      // Fullscreen Toggle Icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Obx(() {
                          return IconButton(
                            icon: Icon(
                              controller.isFullScreen.value
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (controller.isFullScreen.value) {
                                // Exit fullscreen
                                controller.isFullScreen.value = false;
                                controller.youtubeController.exitFullScreen();
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.portraitUp,
                                ]);
                              } else {
                                // Enter fullscreen
                                controller.isFullScreen.value = true;
                                controller.youtubeController.enterFullScreen();
                                SystemChrome.setPreferredOrientations([
                                  DeviceOrientation.landscapeLeft,
                                  DeviceOrientation.landscapeRight,
                                ]);
                              }
                            },
                          );
                        }),
                      ),
                    ],
                  ),

                  // Topic Buttons
                  Obx(
                    () => SizedBox(
                      height: 60,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children:
                              controller.topics.asMap().entries.map((entry) {
                                final index = entry.key;
                                final topic = entry.value;
                                final isSelected =
                                    controller.currentIndex.value == index;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSelected
                                              ? Colors.redAccent
                                              : Colors.white,
                                      foregroundColor:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 0.9,
                                        ),
                                      ),
                                    ),
                                    onPressed:
                                        () => controller.changeVideo(index),
                                    child: Text(
                                      topic.topicName ?? 'Topic ${index + 1}',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Tabs
                  const TabBar(
                    labelColor: Colors.redAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.redAccent,
                    tabs: [
                      Tab(text: 'Notes'),
                      Tab(text: 'PDF'),
                      Tab(text: 'Quiz'),
                    ],
                  ),

                  // Tab Views
                  SizedBox(
                    height:
                        400, // Set a fixed height or use MediaQuery for dynamic
                    child: TabBarView(
                      children: [
                        Center(
                          child: Text(
                            'Notes WILL BE APPEAR HERE',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'PDF WILL BE APPEAR HERE',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Quiz content goes here',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
