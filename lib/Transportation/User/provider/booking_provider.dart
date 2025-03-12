import 'package:flutter/material.dart';

class BookingScreenProvider with ChangeNotifier {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  int get selectedIndex => _selectedIndex;
  PageController get pageController => _pageController;

  void setIndex(int index) {
    _selectedIndex = index;
    _pageController.jumpToPage(index);
    notifyListeners();
  }
}
