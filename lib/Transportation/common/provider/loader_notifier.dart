import 'package:flutter/material.dart';

class LoaderNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  /// Show loader
  void showLoader() {
    _isLoading = true;
    notifyListeners();
  }

  /// Hide loader
  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }
}
