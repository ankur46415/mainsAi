import 'dart:async';
import 'package:flutter/material.dart';

class AdsCarouselController extends ChangeNotifier {
  PageController? _pageController;
  int _currentPage = 0;
  Timer? _timer;
  List<String> _imageUrls = [];
  bool _isAutoPlay = false;

  PageController? get pageController => _pageController;
  int get currentPage => _currentPage;
  List<String> get imageUrls => _imageUrls;
  bool get isAutoPlay => _isAutoPlay;

  void initialize({
    required List<String> imageUrls,
    bool autoPlay = true,
    Duration autoPlayDuration = const Duration(seconds: 3),
  }) {
    _imageUrls = imageUrls;
    _isAutoPlay = autoPlay && imageUrls.length > 1;
    _currentPage = 0;
    
    _pageController?.dispose();
    _pageController = PageController();
    
    _timer?.cancel();
    
    if (_isAutoPlay) {
      _startAutoPlay(autoPlayDuration);
    }
    
    notifyListeners();
  }

  void _startAutoPlay(Duration duration) {
    _timer = Timer.periodic(duration, (timer) {
      if (_pageController?.hasClients == true) {
        _currentPage = (_currentPage + 1) % _imageUrls.length;
        _pageController?.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    });
  }

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void goToPage(int index) {
    if (_pageController?.hasClients == true && 
        index >= 0 && 
        index < _imageUrls.length) {
      _currentPage = index;
      _pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void pauseAutoPlay() {
    _timer?.cancel();
    _isAutoPlay = false;
    notifyListeners();
  }

  void resumeAutoPlay({Duration duration = const Duration(seconds: 3)}) {
    if (_imageUrls.length > 1) {
      _isAutoPlay = true;
      _startAutoPlay(duration);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }
}
