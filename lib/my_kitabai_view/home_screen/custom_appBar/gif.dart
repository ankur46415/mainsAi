import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

class CustomLoopingGif extends StatefulWidget {
  final String assetPath;
  final double height;
  final double width;
  final BoxFit fit;

  const CustomLoopingGif({
    super.key,
    required this.assetPath,
    this.height = 100,
    this.width = 100,
    this.fit = BoxFit.cover,
  });

  @override
  State<CustomLoopingGif> createState() => _CustomLoopingGifState();
}

class _CustomLoopingGifState extends State<CustomLoopingGif>
    with SingleTickerProviderStateMixin {
  late GifController controller;

  @override
  void initState() {
    super.initState();
    controller = GifController(vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Gif(
      image: AssetImage(widget.assetPath),
      controller: controller,
      autostart: Autostart.loop,
      height: widget.height,
      width: widget.width,
      fit: widget.fit,
    );
  }
}
