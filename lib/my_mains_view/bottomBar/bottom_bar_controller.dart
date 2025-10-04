import 'package:flutter/material.dart';

class BottomBarController extends ChangeNotifier {
  List<TabIconData>? _tabIconsList;
  int _selectedIndex = 0;

  List<TabIconData>? get tabIconsList => _tabIconsList;
  int get selectedIndex => _selectedIndex;

  void initializeTabs(List<TabIconData>? tabIconsList) {
    _tabIconsList = tabIconsList;
    if (_tabIconsList != null && _tabIconsList!.isNotEmpty) {
      _tabIconsList![0].isSelected = true;
    }
    notifyListeners();
  }

  void selectTab(int index) {
    if (_tabIconsList == null || index < 0 || index >= _tabIconsList!.length) {
      return;
    }

    // Remove selection from all tabs
    for (var tab in _tabIconsList!) {
      tab.isSelected = false;
    }

    // Select the new tab
    _tabIconsList![index].isSelected = true;
    _selectedIndex = index;
    notifyListeners();
  }

  void setRemoveAllSelection(TabIconData? tabIconData) {
    if (_tabIconsList == null || tabIconData == null) return;

    // Remove selection from all tabs
    for (var tab in _tabIconsList!) {
      tab.isSelected = false;
    }

    // Select the specified tab
    tabIconData.isSelected = true;
    _selectedIndex = tabIconData.index;
    notifyListeners();
  }
}

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.selectedImagePath = '',
    this.index = 0,
    this.isSelected = false,
    this.title = '',
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  String title;
  bool isSelected;
  int index;

  AnimationController? animationController;
}
