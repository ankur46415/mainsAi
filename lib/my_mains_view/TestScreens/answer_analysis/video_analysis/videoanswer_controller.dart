import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../../models/GetAnswerAnalysis.dart';
import '../../../../models/play_video_model.dart';
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
          } else {}
        }
        if (endIndex < videoUrls.length) {
          await Future.delayed(const Duration(milliseconds: 5));
        }
      }
      if (videos.isNotEmpty) {
        initializeYoutubePlayer(videos.first.youtubeId);
      }
      stopwatch.stop();
    } catch (e) {
      stopwatch.stop();
    }
  }

  void refreshVideos(Question? question) {
    if (currentVideoId.value != null) {
      try {
        youtubeController.close();
      } catch (e) {}
    }
    currentVideoId.value = null;
    setVideosFromQuestion(question);
  }

  VideoModel? _createVideoModelFromUrl(dynamic videoUrl, int index) {
    try {
      String url = videoUrl.toString();
      String? youtubeId = _extractYoutubeId(url);
      if (youtubeId == null) {
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
          return videoId;
        } else {}
      }
    }
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(url)) {
      if (_isValidYoutubeId(url)) {
        return url;
      } else {}
    }
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
    currentVideoId.value = videoId;
    try {
      if (videoId.isEmpty || videoId.length != 11) {
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
        if (event is YoutubePlayerValue) {
          if (event.error != YoutubeError.none) {
            isVideoLoading.value = false;
            if (event.error == YoutubeError.invalidParam) {
              Future.delayed(const Duration(milliseconds: 1000), () {
                recreatePlayerWithQuestion(videoId, _questionData);
              });
            }
            return;
          }
          switch (event.playerState) {
            case PlayerState.playing:
              isVideoLoading.value = false;
              break;
            case PlayerState.paused:
              isVideoLoading.value = false;
              break;
            case PlayerState.ended:
              isVideoLoading.value = false;
              break;
            case PlayerState.buffering:
              isVideoLoading.value = true;
              break;
            case PlayerState.cued:
              isVideoLoading.value = false;
              break;
            case PlayerState.unStarted:
              isVideoLoading.value = true;
              break;
            default:
              isVideoLoading.value = true;
              break;
          }
        }
      });
    } catch (e) {
      isVideoLoading.value = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        recreatePlayerWithQuestion(videoId, _questionData);
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
  void playVideo(VideoModel video) {
    try {
      if (currentVideoId.value != video.youtubeId) {
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
              } else {
                youtubeController.playVideo();
              }
            } else {
              youtubeController.playVideo();
            }
          } catch (e) {
            isVideoLoading.value = false;
            retryVideoLoading(video);
          }
        });
      } else {
        try {
          youtubeController.playVideo();
        } catch (e) {
          forceRefreshPlayer(video.youtubeId);
        }
      }
    } catch (e) {
      isVideoLoading.value = false;
      try {
        forceRefreshPlayer(video.youtubeId);
        Future.delayed(const Duration(milliseconds: 1500), () async {
          final isReady = await waitForPlayerReady(timeoutSeconds: 5);
          if (isReady) {
            youtubeController.playVideo();
          } else {
            recreatePlayerWithQuestion(video.youtubeId, _questionData);
          }
          isVideoLoading.value = false;
        });
      } catch (reinitError) {
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
    } catch (e) {}
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
    try {
      youtubeController.close();
      currentVideoId.value = null;
      Future.delayed(const Duration(milliseconds: 200), () {
        initializeYoutubePlayer(videoId);
      });
    } catch (e) {
    }
  }

  bool isPlayerReady() {
    try {
      return youtubeController != null && currentVideoId.value != null;
    } catch (e) {
      return false;
    }
  }

  Future<bool> waitForPlayerReady({int timeoutSeconds = 5}) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed.inSeconds < timeoutSeconds) {
      if (isPlayerReady()) {
        return true;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
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
          return true;
        }
        if (youtubeController.value.error != YoutubeError.none) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  void recreatePlayer(String videoId) {
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
      isVideoLoading.value = false;
    }
  }

  void recreatePlayerWithQuestion(String videoId, Question? question) {
   
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
      isVideoLoading.value = false;
    }
  }

  void retryVideoLoading(
    VideoModel video, {
    int retryCount = 0,
    int maxRetries = 3,
  }) {
    if (retryCount >= maxRetries) {
      isVideoLoading.value = false;
      return;
    }
  
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
  }
}

class VideoAnswerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VideoAnswerController());
  }
}
