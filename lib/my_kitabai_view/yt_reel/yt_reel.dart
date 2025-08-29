import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/my_kitabai_view/yt_reel/yt_reel_controller.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReelsView extends StatefulWidget {
  ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  late ReelsController c;
  @override
  void initState() {
    c = Get.put(ReelsController());

    c.fetchReels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          if (c.isLoading.value && c.videoIds.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (c.videoIds.isEmpty) {
            return const Center(
              child: Text(
                'No reels available',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }
          return PageView.builder(
            controller: c.pageController,
            itemCount: c.videoIds.length,
            scrollDirection: Axis.vertical,
            onPageChanged: c.onPageChanged,
            itemBuilder: (context, index) {
              return _ReelItem(index: index);
            },
          );
        }),
      ),
    );
  }
}

class _ReelItem extends StatefulWidget {
  final int index;
  const _ReelItem({required this.index});

  @override
  State<_ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<_ReelItem>
    with SingleTickerProviderStateMixin {
  late AnimationController likeBurst;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  ReelsController get c => Get.find<ReelsController>();

  @override
  void initState() {
    super.initState();
    likeBurst = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    scaleAnim = Tween<double>(
      begin: 0.6,
      end: 1.6,
    ).animate(CurvedAnimation(parent: likeBurst, curve: Curves.easeOutBack));
    fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: likeBurst,
        curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    likeBurst.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    c.likeOnDoubleTap(widget.index);
    likeBurst
      ..stop()
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = c.controllerFor(widget.index);
    final type =
        (widget.index < c.videoTypes.length)
            ? c.videoTypes[widget.index]
            : 'youtube';
    final url =
        (widget.index < c.videoUrls.length) ? c.videoUrls[widget.index] : null;

    Widget videoWidget;
    if (type == 'file' && url != null && url.isNotEmpty) {
      videoWidget = _FileVideoPlayer(url: url, key: ValueKey(url));
    } else if (ctrl != null) {
      videoWidget = YoutubePlayer(
        controller: ctrl,
        showVideoProgressIndicator: false,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
        ],
        onReady: () {
          try {
            ctrl.play();
          } catch (_) {}
        },
      );
    } else {
      videoWidget = _buildPlaceholder();
    }

    return GestureDetector(
      onDoubleTap: _onDoubleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: videoWidget),

          // ---- Heart burst on double tap ----
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Center(
                child: AnimatedBuilder(
                  animation: likeBurst,
                  builder: (context, _) {
                    return Opacity(
                      opacity: fadeAnim.value * (1 - likeBurst.value * 0.6),
                      child: Transform.scale(
                        scale: scaleAnim.value,
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.white70,
                          size: 120,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          Positioned(
            right: 10,
            bottom: 24,
            child: Obx(() {
              final isLiked =
                  (widget.index < c.likedFlags.length)
                      ? c.likedFlags[widget.index]
                      : false;
              final likeCount =
                  (widget.index < c.likeCounts.length)
                      ? c.likeCounts[widget.index]
                      : 0;
              final isMuted = c.muted.contains(widget.index);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ActionButton(
                    icon: isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.pinkAccent : Colors.white,
                    label: likeCount > 0 ? likeCount.toString() : 'Like',
                    onTap: () => c.toggleLikeAt(widget.index),
                  ),
                  const SizedBox(height: 16),
                  _ActionButton(
                    icon: isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    label: isMuted ? 'Muted' : 'Sound',
                    onTap: () => c.toggleMute(widget.index),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ),

          Positioned(
            left: 12,
            right: 72,
            bottom: 18,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.index < c.titles.length &&
                          c.titles[widget.index].isNotEmpty
                      ? c.titles[widget.index]
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    final id = c.videoIdAt(widget.index);
    if (id == null || id.isEmpty) {
      return const SizedBox.shrink();
    }
    final thumbUrl = 'https://img.youtube.com/vi/$id/hqdefault.jpg';
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          thumbUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.4),
                Colors.black.withOpacity(0.4),
              ],
            ),
          ),
        ),
        const Center(
          child: Icon(
            Icons.play_circle_filled,
            color: Colors.white70,
            size: 80,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _FileVideoPlayer extends StatefulWidget {
  final String url;
  const _FileVideoPlayer({Key? key, required this.url}) : super(key: key);

  @override
  State<_FileVideoPlayer> createState() => _FileVideoPlayerState();
}

class _FileVideoPlayerState extends State<_FileVideoPlayer> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _initialized = true;
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: true,
            showControls: false,
          );
        });
      });
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized || _chewieController == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Chewie(controller: _chewieController!);
  }
}
