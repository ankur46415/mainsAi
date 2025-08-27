class ImageWithStatus {
  final String imagePath;
  final bool isAnnotated;
  final String? annotatedPath;
  final bool isNetworkImage;

  ImageWithStatus({
    required this.imagePath,
    this.isAnnotated = false,
    this.annotatedPath,
    this.isNetworkImage = false,
  });

  String get displayPath => isAnnotated ? annotatedPath! : imagePath;

  bool get isFromNetwork => isNetworkImage || imagePath.startsWith('http');

  ImageWithStatus copyWith({
    String? imagePath,
    bool? isAnnotated,
    String? annotatedPath,
    bool? isNetworkImage,
  }) {
    return ImageWithStatus(
      imagePath: imagePath ?? this.imagePath,
      isAnnotated: isAnnotated ?? this.isAnnotated,
      annotatedPath: annotatedPath ?? this.annotatedPath,
      isNetworkImage: isNetworkImage ?? this.isNetworkImage,
    );
  }
}