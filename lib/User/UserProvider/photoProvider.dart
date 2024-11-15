import 'package:flutter/material.dart';
import 'dart:io';

class ProfileProvider extends ChangeNotifier {
  File? _profileImage;
  String? _profileImageUrl;

  // Getter methods
  File? get profileImage => _profileImage;
  String? get profileImageUrl => _profileImageUrl;

  // Setter for local image
  void setProfileImage(File image) {
    _profileImage = image;
    notifyListeners();  // Notify listeners when the image is updated
  }

  // Setter for image URL (after upload)
  void setProfileImageUrl(String? url) {
    _profileImageUrl = url;
    notifyListeners();  // Notify listeners when the URL is updated
  }
}
