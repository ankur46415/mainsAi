import 'package:flutter/material.dart';

class MiniYoutubePreview extends StatelessWidget {
  final String youtubeId;
  const MiniYoutubePreview({required this.youtubeId, Key? key})
    : super(key: key);

  String getThumbnailUrl() {
    return 'https://img.youtube.com/vi/$youtubeId/0.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        getThumbnailUrl(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}

class MiniFileVideoPreview extends StatelessWidget {
  final String thumbnailUrl; // pass pre-generated or API-provided thumbnail
  const MiniFileVideoPreview({required this.thumbnailUrl, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        thumbnailUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
