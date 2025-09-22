import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabControllerManager extends GetxController {
  TabController? tabController;
  final RxInt selectedIndex = 0.obs;
  bool _isDisposed = false;
  VoidCallback? _listener;

  TabControllerManager([this.tabController]) {
    if (tabController != null) {
      _setupListener();
    }
  }

  void setTabController(TabController controller) {
    if (_listener != null && tabController != null) {
      tabController!.removeListener(_listener!);
    }
    
    tabController = controller;
    _setupListener();
  }

  void _setupListener() {
    if (tabController != null) {
      _listener = () {
        if (!_isDisposed && tabController != null && selectedIndex.value != tabController!.index) {
          selectedIndex.value = tabController!.index;
        }
      };
      tabController!.addListener(_listener!);
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    if (_listener != null && tabController != null) {
      tabController!.removeListener(_listener!);
    }
    super.onClose();
  }

  void animateTo(int index) {
    if (!_isDisposed && tabController != null) {
      try {
        tabController!.animateTo(index);
      } catch (e) {
        print('Error animating to index $index: $e');
        // If TabController is disposed, reset it
        tabController = null;
      }
    }
  }

  void setIndex(int index) {
    if (!_isDisposed) {
      selectedIndex.value = index;
    }
  }

  bool get isControllerValid => tabController != null && !_isDisposed;
}
