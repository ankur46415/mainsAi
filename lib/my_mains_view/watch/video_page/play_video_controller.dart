import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:mains/models/course_leture_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class PlayVideoController extends GetxController {
  final List<Topics> topics;
  final int initialIndex;

  PlayVideoController(this.topics, this.initialIndex);

  var currentIndex = 0.obs;
  late YoutubePlayerController youtubeController;
  var isFullScreen = false.obs;

  Timer? _positionTimer;

  @override
  void onInit() {
    super.onInit();
    currentIndex.value = initialIndex;

    youtubeController = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
      ),
    );

    _loadCurrentVideo();
  }

  void _loadCurrentVideo() async {
    final videoId = _extractYoutubeId(
      topics[currentIndex.value].videoUrl ?? '',
    );
    if (videoId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final lastPosition = prefs.getDouble('video_$videoId') ?? 0.0;
    print("Restoring video $videoId at $lastPosition sec");

    await youtubeController.loadVideoById(
      videoId: videoId,
      startSeconds: lastPosition,
    );

    StreamSubscription? sub;
    sub = youtubeController.listen((value) async {
      if (value.playerState == PlayerState.cued ||
          value.playerState == PlayerState.buffering ||
          value.playerState == PlayerState.paused) {
        await youtubeController.playVideo();
        print("Played video after cue");
        await sub?.cancel();
      }
    });

    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      final pos = await youtubeController.currentTime;
      prefs.setDouble('video_$videoId', pos);
      print("Saved position $pos sec");
    });
  }

  void changeVideo(int index) {
    currentIndex.value = index;
    _positionTimer?.cancel();
    _loadCurrentVideo();
  }

  String _extractYoutubeId(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '';
    if (uri.host.contains('youtu.be')) {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    } else if (uri.host.contains('youtube.com')) {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  Future<void> _saveCurrentPosition() async {
    final videoId = _extractYoutubeId(
      topics[currentIndex.value].videoUrl ?? '',
    );
    final pos = await youtubeController.currentTime;
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('video_$videoId', pos);
  }

  @override
  void onClose() {
    _saveCurrentPosition();
    _positionTimer?.cancel();
    youtubeController.close();
    super.onClose();
  }
}

class PlayVideoBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments as Map<String, dynamic>?;
    Get.put(PlayVideoController(args?['topics'], args?['initialIndex'] ?? 0));
  }
}
