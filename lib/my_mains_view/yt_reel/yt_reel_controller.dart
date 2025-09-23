// ========================= CONTROLLER =========================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mains/common/api_services.dart';
import 'package:mains/common/api_urls.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// Removed direct http usage; using shared callWebApiGet

class ReelsController extends GetxController {
  final RxList<String> videoIds = <String>[].obs;
  final RxList<String> reelIds = <String>[].obs;
  final RxList<bool> viewedFlags = <bool>[].obs;
  final RxList<bool> likedFlags = <bool>[].obs;
  final RxList<int> likeCounts = <int>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  // TODO: replace with your real endpoint
  final String apiUrl = ApiUrls.reelsUser;
  final String viewApiBase = ApiUrls.reelsBase;
  final String likeApiBase = ApiUrls.reelsBase;

  // Current page index
  final RxInt currentIndex = 0.obs;

  // Track likes
  final RxSet<int> liked = <int>{}.obs;

  // Player controllers mapped by index
  final Map<int, YoutubePlayerController> _players = {};

  // Mute state per index (optional)
  final RxSet<int> muted = <int>{}.obs;

  final RxList<String> videoTypes = <String>[].obs; // 'youtube' or 'file'
  final RxList<String> videoUrls =
      <String>[].obs; // direct video url or youtube link
  final RxList<String> titles = <String>[].obs;

  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    fetchReels();
  }

  @override
  void onClose() {
    _disposeAllExcept({});
    pageController.dispose();
    super.onClose();
  }

  // Safe getter for id
  String? videoIdAt(int index) {
    if (index < 0 || index >= videoIds.length) return null;
    return videoIds[index];
  }

  // Public getter to read controller for a given index if available
  YoutubePlayerController? controllerFor(int index) => _players[index];

  // Handle page change: auto-play current, pause others, manage init window
  void onPageChanged(int index) {
    currentIndex.value = index;
    // Maintain a 3-item window: previous, current, next
    final window =
        {
          index - 1,
          index,
          index + 1,
        }.where((i) => i >= 0 && i < videoIds.length).toList();
    _ensureInitializedForIndices(window);
    _disposeAllExcept(window.toSet());
    _playOnly(index);
    _maybeMarkViewed(index);
  }

  // Toggle like on single tap button
  void toggleLike(int index) {
    if (liked.contains(index)) {
      liked.remove(index);
    } else {
      liked.add(index);
    }
  }

  // Double tap like helper (always like and brief heart burst handled in UI)
  void likeOnDoubleTap(int index) {
    liked.add(index);
  }

  // Toggle mute for a given index
  void toggleMute(int index) {
    final ctrl = _players[index];
    if (ctrl == null) return;
    if (muted.contains(index)) {
      muted.remove(index);
      ctrl.unMute();
    } else {
      muted.add(index);
      ctrl.mute();
    }
  }

  // ============== Internal helpers ==============
  void _ensureInitializedForIndices(List<int> indices) {
    for (final i in indices) {
      if (_players.containsKey(i)) continue;
      final id = videoIdAt(i);
      if (id == null || id.isEmpty) continue;
      final ctrl = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          loop: true,
          enableCaption: false,
          controlsVisibleAtStart: true,
          disableDragSeek: true,
        ),
      );
      _players[i] = ctrl;
    }
  }

  void _disposeAllExcept(Set<int> keep) {
    final toDispose = _players.keys.where((k) => !keep.contains(k)).toList();
    for (final k in toDispose) {
      _players[k]?.pause();
      _players[k]?.dispose();
      _players.remove(k);
      muted.remove(k);
    }
  }

  void _playOnly(int index) {
    _players.forEach((i, c) {
      if (i == index) {
        try {
          c.unMute();
        } catch (_) {}
        c.play();
      } else {
        c.pause();
        try {
          c.mute();
        } catch (_) {}
      }
    });
  }

  void _maybeMarkViewed(int index) {
    if (index < 0 || index >= reelIds.length) return;
    if (index < viewedFlags.length && viewedFlags[index] == true) return;
    final reelId = reelIds[index];
    if (reelId.isEmpty) return;
    markReelViewed(reelId).then((_) {
      if (index < viewedFlags.length) viewedFlags[index] = true;
    });
  }

  Future<void> fetchReels() async {
    try {
      isLoading(true);
      errorMessage('');
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final rawUrl = apiUrl.trim();
      if (rawUrl.isEmpty ||
          !(rawUrl.startsWith('http://') || rawUrl.startsWith('https://'))) {
        errorMessage('Invalid reels API URL');
        debugPrint('[Reels] ERROR: Invalid API URL: "$apiUrl"');
        return;
      }
      debugPrint('[Reels] Fetching reels → GET $rawUrl');
      debugPrint('[Reels] Using token present: ${authToken.isNotEmpty}');

      await callWebApiGet(
        null,
        rawUrl,
        token: authToken,
        showLoader: false,
        hideLoader: true,
        onResponse: (response) {
          debugPrint('[Reels] Response status: ${response.statusCode}');
          final preview =
              response.body.length > 500
                  ? response.body.substring(0, 500)
                  : response.body;
          debugPrint('[Reels] Raw body (first 500 chars): $preview');

          final jsonResponse =
              json.decode(response.body) as Map<String, dynamic>;
          debugPrint('[Reels] json keys: ${jsonResponse.keys.toList()}');
          final dataList =
              (jsonResponse['data'] as List<dynamic>? ?? [])
                  .cast<Map<String, dynamic>>();
          debugPrint('[Reels] items in data: ${dataList.length}');
          final ids = <String>[];
          final idsBackend = <String>[];
          final viewed = <bool>[];
          final liked = <bool>[];
          final likes = <int>[];
          final types = <String>[];
          final urls = <String>[];
          final titlesList = <String>[];
          for (final m in dataList) {
            final backendId = (m['_id'] as String?)?.trim() ?? '';
            final isViewed = (m['isViewed'] as bool?) ?? false;
            final isLiked = (m['isLiked'] as bool?) ?? false;
            final metrics = (m['metrics'] as Map<String, dynamic>?) ?? const {};
            final likesCount = (metrics['likes'] as int?) ?? 0;
            final youtubeId = (m['youtubeId'] as String?)?.trim();
            final youtubeLink = (m['youtubeLink'] as String?)?.trim();
            final videoUrl = (m['videoUrl'] as String?)?.trim();
            String? id = youtubeId;
            String type = '';
            String url = '';
            final title = (m['title'] as String?)?.trim() ?? '';
            if ((id == null || id.isEmpty) &&
                youtubeLink != null &&
                youtubeLink.isNotEmpty) {
              id = YoutubePlayer.convertUrlToId(youtubeLink);
            }
            if (id != null && id.isNotEmpty) {
              type = 'youtube';
              url = youtubeLink ?? '';
            } else if (videoUrl != null && videoUrl.isNotEmpty) {
              type = 'file';
              id = videoUrl;
              url = videoUrl;
            }
            debugPrint(
              '[Reels] mapped item id: $id from youtubeId:"$youtubeId" link:"$youtubeLink" videoUrl:"$videoUrl"',
            );
            if (id != null && id.isNotEmpty) {
              ids.add(id);
              idsBackend.add(backendId);
              viewed.add(isViewed);
              liked.add(isLiked);
              likes.add(likesCount);
              types.add(type);
              urls.add(url);
              titlesList.add(title);
            } else {
              debugPrint('[Reels] skipped item: missing valid video id/url');
            }
          }
          debugPrint('[Reels] valid ids count: ${ids.length} → $ids');
          videoIds.assignAll(ids);
          reelIds.assignAll(idsBackend);
          viewedFlags.assignAll(viewed);
          likedFlags.assignAll(liked);
          likeCounts.assignAll(likes);
          videoTypes.assignAll(types);
          videoUrls.assignAll(urls);
          titles.assignAll(titlesList);
          debugPrint('[Reels] videoIds assigned.');
          _ensureInitializedForIndices([0, 1]);
          _playOnly(0);
          _maybeMarkViewed(0);
          errorMessage('');
        },
        onError: () {
          errorMessage('Failed to load reels');
          debugPrint('[Reels] Error: non-2xx response.');
        },
      );
    } catch (e) {
      errorMessage('Error: $e');
      debugPrint('[Reels] Exception: $e');
    } finally {
      isLoading(false);
      debugPrint(
        '[Reels] fetchReels finished. videoIds len: ${videoIds.length}',
      );
    }
  }

  // ============== Mark Viewed ==============
  final RxString lastViewedReelId = ''.obs;
  Future<void> markReelViewed(String reelId) async {
    try {
      if (reelId.isEmpty) return;
      if (lastViewedReelId.value == reelId) return;

      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final url = "$viewApiBase/$reelId/view";
      lastViewedReelId.value = reelId;
      debugPrint('[Reels] Marking viewed → POST $url');
      await callWebApi(
        null,
        url,
        {},
        token: authToken,
        showLoader: false,
        onResponse: (_) {},
        onError: () {},
      );
    } catch (e) {
      debugPrint('[Reels] markReelViewed error: $e');
    }
  }

  // ============== Toggle Like ==============
  Future<void> toggleLikeAt(int index) async {
    if (index < 0 || index >= reelIds.length) return;
    final reelId = reelIds[index];
    if (reelId.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('authToken') ?? '';
      final url = "$likeApiBase/$reelId/like";
      debugPrint('[Reels] Toggling like → POST $url');
      await callWebApi(
        null,
        url,
        {},
        token: authToken,
        showLoader: false,
        onResponse: (_) {},
        onError: () {},
      );

      // Local optimistic update
      final wasLiked = (index < likedFlags.length) ? likedFlags[index] : false;
      final currentCount = (index < likeCounts.length) ? likeCounts[index] : 0;
      if (index < likedFlags.length) likedFlags[index] = !wasLiked;
      if (index < likeCounts.length) {
        likeCounts[index] =
            wasLiked ? (currentCount - 1).clamp(0, 1 << 30) : currentCount + 1;
      }
    } catch (e) {
      debugPrint('[Reels] toggleLike error: $e');
    }
  }
}
