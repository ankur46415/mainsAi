import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../model/GetAnswerAnalysis.dart';
import '../../../../model/play_video_model.dart';
import 'dart:async';

class VideoAnswerController extends GetxController with WidgetsBindingObserver {
  late YoutubePlayerController youtubeController;
  final currentVideoId = RxnString();
  final RxList<VideoModel> videos = <VideoModel>[].obs;
  final RxBool isVideoLoading = false.obs;
  Question? _questionData;

  void setVideosFromQuestion(Question? question) {
    videos.clear();

    if (question != null &&
        question.answerVideoUrls != null &&
        question.answerVideoUrls!.isNotEmpty) {
      for (int i = 0; i < question.answerVideoUrls!.length; i++) {
        final videoUrl = question.answerVideoUrls![i];
        final videoModel = _createVideoModelFromUrl(videoUrl, i + 1);
        if (videoModel != null) {
          videos.add(videoModel);
        }
      }

      if (videos.isNotEmpty) {
        initializeYoutubePlayer(videos.first.youtubeId);
      }
    }
  }

  void _processVideosAsync(List<dynamic> videoUrls) async {
    final stopwatch = Stopwatch()..start();
    try {
      const int batchSize = 2;
      for (int i = 0; i < videoUrls.length; i += batchSize) {
        final endIndex =
            (i + batchSize < videoUrls.length)
                ? i + batchSize
                : videoUrls.length;
        for (int j = i; j < endIndex; j++) {
          final videoUrl = videoUrls[j];
          final videoModel = _createVideoModelFromUrl(videoUrl, j + 1);
          if (videoModel != null) {
            videos.add(videoModel);
            print(
              '✅ Added video:  {videoModel.title} (ID:  {videoModel.youtubeId})',
            );
          } else {
            print('❌ Failed to create video model for URL: $videoUrl');
          }
        }
        if (endIndex < videoUrls.length) {
          await Future.delayed(const Duration(milliseconds: 5));
        }
      }
      if (videos.isNotEmpty) {
        print(
          '🎬 Initializing player with first video: ${videos.first.youtubeId}',
        );
        initializeYoutubePlayer(videos.first.youtubeId);
      }
      stopwatch.stop();
      print(
        '⏱️ Video processing completed in ${stopwatch.elapsedMilliseconds}ms',
      );
    } catch (e) {
      print('❌ Error processing videos: $e');
      stopwatch.stop();
    }
  }

  void refreshVideos(Question? question) {
    if (currentVideoId.value != null) {
      try {
        youtubeController.close();
      } catch (e) {
        print('Error closing existing player: $e');
      }
    }
    currentVideoId.value = null;
    setVideosFromQuestion(question);
  }

  VideoModel? _createVideoModelFromUrl(dynamic videoUrl, int index) {
    try {
      String url = videoUrl.toString();
      String? youtubeId = _extractYoutubeId(url);
      if (youtubeId == null) {
        print('Could not extract YouTube ID from URL: $url');
        return null;
      }
      String title = _generateVideoTitle(url, index);
      return VideoModel(
        id: index.toString(),
        title: title,
        thumbnailUrl: 'https://img.youtube.com/vi/$youtubeId/0.jpg',
        duration: '0:00',
        youtubeId: youtubeId,
      );
    } catch (e) {
      print('Error creating video model from URL: $e');
      return null;
    }
  }

  String _generateVideoTitle(String url, int index) {
    if (url.contains('title=')) {
      final titleMatch = RegExp(r'title=([^&]+)').firstMatch(url);
      if (titleMatch != null) {
        return Uri.decodeComponent(titleMatch.group(1)!);
      }
    }
    if (url.contains('explanation') || url.contains('tutorial')) {
      return 'Video Explanation $index';
    } else if (url.contains('solution') || url.contains('answer')) {
      return 'Solution Video $index';
    } else if (url.contains('concept') || url.contains('theory')) {
      return 'Concept Video $index';
    } else if (url.contains('example') || url.contains('demo')) {
      return 'Example Video $index';
    }
    return 'Video $index';
  }

  String? _extractYoutubeId(String url) {
    print('🔍 Extracting YouTube ID from: $url');
    final patterns = [
      RegExp(
        r'(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([a-zA-Z0-9_-]{11})',
      ),
      RegExp(r'youtube\.com\/v\/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com\/watch\?.*v=([a-zA-Z0-9_-]{11})'),
    ];
    for (int i = 0; i < patterns.length; i++) {
      final pattern = patterns[i];
      final match = pattern.firstMatch(url);
      if (match != null) {
        final videoId = match.group(1);
        if (_isValidYoutubeId(videoId!)) {
          print('✅ Extracted YouTube ID using pattern $i: $videoId');
          return videoId;
        } else {
          print('❌ Invalid YouTube ID format: $videoId');
        }
      }
    }
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      if (_isValidYoutubeId(url)) {
        print('✅ URL is already a valid YouTube ID: $url');
        return url;
      } else {
        print('❌ URL is not a valid YouTube ID: $url');
      }
    }
    print('❌ Could not extract valid YouTube ID from URL: $url');
    return null;
  }

  bool _isValidYoutubeId(String videoId) {
    if (videoId.length != 11) {
      return false;
    }
    final validPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    if (!validPattern.hasMatch(videoId)) {
      return false;
    }
    if (videoId.startsWith('-') || videoId.startsWith('_')) {
      return false;
    }
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  void initializeYoutubePlayer(String videoId) {
    print('🎬 Initializing YouTube player with video: $videoId');
    currentVideoId.value = videoId;
    try {
      if (videoId.isEmpty || videoId.length != 11) {
        print('❌ Invalid video ID format: $videoId');
        isVideoLoading.value = false;
        return;
      }
      youtubeController = YoutubePlayerController.fromVideoId(
        videoId: videoId,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: false,
          mute: false,
          showVideoAnnotations: false,
          strictRelatedVideos: true,
          enableCaption: false,
        ),
      );
      youtubeController.listen((event) {
        print('🎬 YouTube event: $event');
        if (event is YoutubePlayerValue) {
          print('🎬 Player state: ${event.playerState}');
          print('🎬 Error state: ${event.error}');
          if (event.error != YoutubeError.none) {
            print('❌ YouTube player error: ${event.error}');
            isVideoLoading.value = false;
            if (event.error == YoutubeError.invalidParam) {
              print(
                '🔄 Invalid param error detected, attempting to recreate player',
              );
              Future.delayed(const Duration(milliseconds: 1000), () {
                recreatePlayerWithQuestion(videoId, _questionData);
              });
            }
            return;
          }
          switch (event.playerState) {
            case PlayerState.playing:
              isVideoLoading.value = false;
              print('✅ Video started playing');
              break;
            case PlayerState.paused:
              isVideoLoading.value = false;
              print('⏸️ Video paused');
              break;
            case PlayerState.ended:
              isVideoLoading.value = false;
              print('⏹️ Video ended');
              break;
            case PlayerState.buffering:
              isVideoLoading.value = true;
              print('⏳ Video buffering...');
              break;
            case PlayerState.cued:
              isVideoLoading.value = false;
              print('📺 Video cued and ready');
              break;
            case PlayerState.unStarted:
              isVideoLoading.value = true;
              print('⏳ Video loading...');
              break;
            default:
              isVideoLoading.value = true;
              print('⏳ Video in unknown state: ${event.playerState}');
              break;
          }
        }
      });
      print('✅ YouTube player initialized successfully');
    } catch (e) {
      print('❌ Error initializing YouTube player: $e');
      isVideoLoading.value = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        print('🔄 Attempting to recreate player due to initialization error');
        recreatePlayerWithQuestion(videoId, _questionData);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
  void playVideo(VideoModel video) {
    print(
      '🎬 Attempting to play video: ${video.title} (ID: ${video.youtubeId})',
    );
    print('🎬 Current video ID: ${currentVideoId.value}');
    try {
      if (currentVideoId.value != video.youtubeId) {
        print('🔄 Switching to different video: ${video.youtubeId}');
        isVideoLoading.value = true;
        forceRefreshPlayer(video.youtubeId);
        Future.delayed(const Duration(milliseconds: 1000), () async {
          try {
            final isReady = await waitForPlayerReady(timeoutSeconds: 5);
            if (isReady) {
              final isCued = await waitForPlayerState(
                PlayerState.cued,
                timeoutSeconds: 5,
              );
              if (isCued) {
                await Future.delayed(const Duration(milliseconds: 500));
                youtubeController.playVideo();
                print('✅ Started playing video: ${video.youtubeId}');
              } else {
                print('❌ Player not in cued state, attempting to play anyway');
                youtubeController.playVideo();
              }
            } else {
              print('❌ Player not ready, attempting to play anyway');
              youtubeController.playVideo();
            }
          } catch (e) {
            print('❌ Error playing video: $e');
            isVideoLoading.value = false;
            retryVideoLoading(video);
          }
        });
      } else {
        print('▶️ Playing current video: ${video.youtubeId}');
        try {
          youtubeController.playVideo();
        } catch (e) {
          print('❌ Error playing current video: $e');
          forceRefreshPlayer(video.youtubeId);
        }
      }
    } catch (e) {
      print('❌ Error playing video: $e');
      isVideoLoading.value = false;
      try {
        print(
          '🔄 Attempting to reinitialize player for video: ${video.youtubeId}',
        );
        forceRefreshPlayer(video.youtubeId);
        Future.delayed(const Duration(milliseconds: 1500), () async {
          final isReady = await waitForPlayerReady(timeoutSeconds: 5);
          if (isReady) {
            youtubeController.playVideo();
          } else {
            print('🔄 Final fallback: completely recreating player');
            recreatePlayerWithQuestion(video.youtubeId, _questionData);
          }
          isVideoLoading.value = false;
        });
      } catch (reinitError) {
        print('❌ Failed to reinitialize player: $reinitError');
        print('🔄 Final fallback: completely recreating player');
        recreatePlayerWithQuestion(video.youtubeId, _questionData);
        isVideoLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    try {
      if (currentVideoId.value != null) {
        youtubeController.close();
      }
      videos.clear();
      currentVideoId.value = null;
      WidgetsBinding.instance.removeObserver(this);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: SystemUiOverlay.values,
      );
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
      print('🧹 VideoAnswerController: Cleaned up resources');
    } catch (e) {
      print('❌ Error during VideoAnswerController cleanup: $e');
    }
    super.onClose();
  }

  VideoModel? getCurrentVideo() {
    if (currentVideoId.value == null) return null;
    try {
      return videos.firstWhere(
        (video) => video.youtubeId == currentVideoId.value,
      );
    } catch (e) {
      return null;
    }
  }

  bool isVideoPlaying(String youtubeId) {
    return currentVideoId.value == youtubeId;
  }

  void forceRefreshPlayer(String videoId) {
    print('🔄 Force refreshing player for video: $videoId');
    try {
      youtubeController.close();
      currentVideoId.value = null;
      Future.delayed(const Duration(milliseconds: 200), () {
        initializeYoutubePlayer(videoId);
      });
    } catch (e) {
      print('❌ Error force refreshing player: $e');
    }
  }

  bool isPlayerReady() {
    try {
      return youtubeController != null && currentVideoId.value != null;
    } catch (e) {
      print('❌ Error checking player readiness: $e');
      return false;
    }
  }

  Future<bool> waitForPlayerReady({int timeoutSeconds = 5}) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed.inSeconds < timeoutSeconds) {
      if (isPlayerReady()) {
        print('✅ Player is ready');
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    print('⏰ Timeout waiting for player to be ready');
    return false;
  }

  Future<bool> waitForPlayerState(
    PlayerState targetState, {
    int timeoutSeconds = 10,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed.inSeconds < timeoutSeconds) {
      try {
        if (youtubeController.value?.playerState == targetState) {
          print('✅ Player reached target state: $targetState');
          return true;
        }
        if (youtubeController.value.error != YoutubeError.none) {
          print('❌ Player error detected: ${youtubeController.value.error}');
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print('❌ Error checking player state: $e');
        return false;
      }
    }
    print('⏰ Timeout waiting for player state: $targetState');
    return false;
  }

  void recreatePlayer(String videoId) {
    print('🔄 Completely recreating player for video: $videoId');
    try {
      if (currentVideoId.value != null) {
        youtubeController.close();
      }
      currentVideoId.value = null;
      isVideoLoading.value = true;
      videos.clear();
      Future.delayed(const Duration(milliseconds: 500), () {
        initializeYoutubePlayer(videoId);
        isVideoLoading.value = false;
      });
    } catch (e) {
      print('❌ Error recreating player: $e');
      isVideoLoading.value = false;
    }
  }

  void recreatePlayerWithQuestion(String videoId, Question? question) {
    print(
      '🔄 Completely recreating player with question data for video: $videoId',
    );
    try {
      if (currentVideoId.value != null) {
        youtubeController.close();
      }
      currentVideoId.value = null;
      isVideoLoading.value = true;
      videos.clear();
      if (question?.answerVideoUrls != null) {
        _processVideosAsync(question!.answerVideoUrls!);
      }
      Future.delayed(const Duration(milliseconds: 800), () {
        initializeYoutubePlayer(videoId);
        isVideoLoading.value = false;
      });
    } catch (e) {
      print('❌ Error recreating player with question: $e');
      isVideoLoading.value = false;
    }
  }

  void retryVideoLoading(
    VideoModel video, {
    int retryCount = 0,
    int maxRetries = 3,
  }) {
    if (retryCount >= maxRetries) {
      print('❌ Max retries reached for video: ${video.youtubeId}');
      isVideoLoading.value = false;
      return;
    }
    print(
      '🔄 Retrying video loading (attempt ${retryCount + 1}/$maxRetries) for video: ${video.youtubeId}',
    );
    final delay = Duration(milliseconds: 1000 * (1 << retryCount));
    Future.delayed(delay, () {
      try {
        forceRefreshPlayer(video.youtubeId);
        Future.delayed(const Duration(milliseconds: 1500), () async {
          final isReady = await waitForPlayerReady(timeoutSeconds: 5);
          if (isReady) {
            final isCued = await waitForPlayerState(
              PlayerState.cued,
              timeoutSeconds: 5,
            );
            if (isCued) {
              youtubeController.playVideo();
              print('✅ Retry successful for video: ${video.youtubeId}');
            } else {
              retryVideoLoading(
                video,
                retryCount: retryCount + 1,
                maxRetries: maxRetries,
              );
            }
          } else {
            retryVideoLoading(
              video,
              retryCount: retryCount + 1,
              maxRetries: maxRetries,
            );
          }
        });
      } catch (e) {
        print('❌ Error in retry attempt: $e');
        retryVideoLoading(
          video,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      }
    });
  }

  void setQuestionData(Question? question) {
    _questionData = question;
    print('📝 Question data stored for video switching');
  }
}

class VideoAnswerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoAnswerController());
  }
}
