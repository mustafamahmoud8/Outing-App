import 'package:flutter/material.dart';

class MainNavigationController extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void goToExplore() {
    _currentIndex = 1; // Explore tab is at index 1
    notifyListeners();
  }

  void goToHome() {
    _currentIndex = 0;
    notifyListeners();
  }
}
