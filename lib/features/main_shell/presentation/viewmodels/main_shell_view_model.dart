/// **Architecture Layer**: Presentation (ViewModel)
/// **Purpose**: Manages the state and business logic for the associated Page.

import 'package:flutter/material.dart';

class MainShellViewModel extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
