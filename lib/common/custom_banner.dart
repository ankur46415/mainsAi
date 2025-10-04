import 'package:flutter/material.dart';
import 'carousel_controller.dart';

class AdsCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;
  final double borderRadius;
  final EdgeInsets padding;
  final AdsCarouselController? controller;
  final bool autoPlay;
  final Duration autoPlayDuration;

  const AdsCarousel({
    super.key,
    required this.imageUrls,
    this.height = 150,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.controller,
    this.autoPlay = true,
    this.autoPlayDuration = const Duration(seconds: 3),
  });

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  AdsCarouselController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? AdsCarouselController();
    _controller?.initialize(
      imageUrls: widget.imageUrls,
      autoPlay: widget.autoPlay,
      autoPlayDuration: widget.autoPlayDuration,
    );
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widget.imageUrls.length == 1) {
      return SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Padding(
          padding: widget.padding,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: _adImage(widget.imageUrls.first),
          ),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              height: widget.height,
              width: double.infinity,
              child: PageView.builder(
                controller: _controller?.pageController,
                onPageChanged: (index) {
                  _controller?.onPageChanged(index);
                },
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: widget.padding,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      child: _adImage(widget.imageUrls[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: _controller?.currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color:
                        _controller?.currentPage == index
                            ? Colors.blue
                            : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  Widget _adImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.fill,
      width: double.infinity,
      height: widget.height,
      errorBuilder:
          (context, error, stackTrace) => Container(color: Colors.grey),
    );
  }
}
