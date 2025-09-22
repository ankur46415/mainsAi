import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../models/play_video_model.dart';
import 'videoanswer_controller.dart';
import '../../../../models/GetAnswerAnalysis.dart';

class VideoAnswer extends StatefulWidget {
  final Question? question;
  const VideoAnswer({Key? key, this.question}) : super(key: key);

  @override
  State<VideoAnswer> createState() => _VideoAnswerState();
}

class _VideoAnswerState extends State<VideoAnswer> {
  late final VideoAnswerController controller;
  final isExpanded = false.obs;

  @override
  void initState() {
    super.initState();
    controller = Get.put(VideoAnswerController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setVideosFromQuestion(widget.question);
      controller.setQuestionData(widget.question);
    });
  }

  @override
  void dispose() {
    Get.delete<VideoAnswerController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.videos.isEmpty) {
        final comingSoonController = YoutubePlayerController.fromVideoId(
          videoId: 'XujmFbMVKmU',
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
          ),
        );
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: YoutubePlayerScaffold(
              controller: comingSoonController,
              builder:
                  (context, player) =>
                      AspectRatio(aspectRatio: 16 / 9, child: player),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  height:
                      isExpanded.value ? Get.height * 0.6 : Get.height * 0.3,
                  margin: const EdgeInsets.all(6),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              controller.currentVideoId.value != null
                                  ? Stack(
                                    children: [
                                      YoutubePlayerScaffold(
                                        key: ValueKey(
                                          controller.currentVideoId.value,
                                        ),
                                        controller:
                                            controller.youtubeController,
                                        builder: (context, player) {
                                          return SizedBox.expand(child: player);
                                        },
                                      ),

                                      // Loading overlay
                                      Obx(() {
                                        if (controller.isVideoLoading.value) {
                                          return Container(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            child: const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      }),
                                    ],
                                  )
                                  : Container(
                                    color: Colors.grey.shade200,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                        ),
                      ),
                      // Toggle button for expanding/collapsing
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: Icon(
                              isExpanded.value
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              isExpanded.value = !isExpanded.value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Video List below the player
              Expanded(
                child: Obx(() {
                  if (isExpanded.value) {
                    return const SizedBox.shrink(); // Hide list when expanded
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: controller.videos.length,
                    itemBuilder: (context, index) {
                      final video = controller.videos[index];
                      final bool isSelected =
                          controller.currentVideoId.value == video.youtubeId;

                      return VideoListItem(
                        video: video,
                        isSelected: isSelected,
                        onTap: () => controller.playVideo(video),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class VideoListItem extends StatelessWidget {
  final VideoModel video;
  final bool isSelected;
  final VoidCallback onTap;

  const VideoListItem({
    super.key,
    required this.video,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      color: isSelected ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side:
            isSelected
                ? BorderSide(color: Colors.blue.shade800, width: 2)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      video.thumbnailUrl,
                      width: 120,
                      height: 70,
                      fit: BoxFit.cover,
                      cacheWidth: 240,
                      cacheHeight: 140,
                      frameBuilder: (
                        context,
                        child,
                        frame,
                        wasSynchronouslyLoaded,
                      ) {
                        if (wasSynchronouslyLoaded) return child;
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                      errorBuilder:
                          (context, error, stackTrace) => Container(
                            width: 120,
                            height: 70,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.image_not_supported),
                          ),
                    ),
                  ),
                  Container(
                    width: 120,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Icon(
                    Icons.play_circle_outline,
                    color: Colors.white,
                    size: isSelected ? 36 : 30,
                  ),
                  // Duration badge
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Playing indicator
                  if (isSelected)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(width: 12),

              // Video title and details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video.title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (isSelected)
                        Text(
                          'Now Playing',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
