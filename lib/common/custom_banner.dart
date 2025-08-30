import 'dart:async';
import 'package:flutter/material.dart';

class AdsCarousel extends StatefulWidget {
  final List<String> imageUrls; // ads ke URLs
  final double height;
  final double borderRadius;
  final EdgeInsets padding;

  const AdsCarousel({
    super.key,
    required this.imageUrls,
    this.height = 150,
    this.borderRadius = 12,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
  });

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    if (widget.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (_pageController.hasClients) {
          _currentPage =
              (_currentPage + 1) % widget.imageUrls.length; // next index
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
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

    return Column(
      children: [
        SizedBox(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
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
              width: _currentPage == index ? 20 : 8,
              decoration: BoxDecoration(
                color:
                    _currentPage == index ? Colors.blue : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
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
