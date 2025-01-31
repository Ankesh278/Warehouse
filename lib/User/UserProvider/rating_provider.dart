import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatingProvider extends ChangeNotifier {
  double _rating = 0.0;
  String _comment = "";
  bool _isSubmitted = false;
  bool _isSubmitting = false;

  double get rating => _rating;
  String get comment => _comment;
  bool get isSubmitted => _isSubmitted;
  bool get isSubmitting => _isSubmitting;

  TextEditingController commentController = TextEditingController();

  /// Fetch existing rating & comment from API based on mobile number
  Future<void> fetchUserFeedback(String mobile) async {
    if (mobile.isEmpty) {
      debugPrint("Error: Mobile number is empty.");
      return;
    }

    final String apiUrl = "https://xpacesphere.com/api/Register/GetRegistr?mobile=$mobile";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('data') && data['data'].isNotEmpty) {
          final latestFeedback = data['data'].last; // Get the latest rating entry
          _rating = (latestFeedback['rating'] as num?)?.toDouble() ?? 0.0;
          _comment = latestFeedback['review'] ?? "";
          commentController.text = _comment;
          _isSubmitted = true;

          debugPrint("Fetched Rating: $_rating");
          debugPrint("Fetched Comment: $_comment");
        }
      } else {
        debugPrint("Failed to fetch feedback: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching feedback: $e");
    }

    notifyListeners();
  }

  /// Set rating
  void setRating(double rating) {
    _rating = rating;
    notifyListeners();
  }

  /// Set comment
  void setComment(String comment) {
    _comment = comment;
    commentController.text = comment;
    notifyListeners();
  }

  /// Submit New Feedback
  Future<void> submitFeedback(String mobile) async {
    if (_rating == 0.0 || mobile.isEmpty) {
      debugPrint("Submit Failed: Rating = $_rating, Mobile = $mobile");
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    const String apiUrl = "https://xpacesphere.com/api/Register/RatingReview";
    final Map<String, dynamic> bodyData = {
      "UserMobile": mobile,
      "RatingValue": _rating,
      "Review": _comment.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        _isSubmitted = true;
        debugPrint("Feedback Submitted Successfully");
      } else {
        debugPrint("Failed to Submit Feedback");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Update Existing Feedback (PUT Method)
  Future<void> updateFeedback(String mobile) async {
    if (!_isSubmitted) {
      debugPrint("No previous feedback found to update.");
      return;
    }
    if (_rating == 0.0 || mobile.isEmpty) {
      debugPrint("Update Failed: Rating = $_rating, Mobile = $mobile");
      return;
    }

    _isSubmitting = true;
    notifyListeners();

    const String apiUrl = "https://xpacesphere.com/api/Register/UpdateRating";
    final Map<String, dynamic> bodyData = {
      "UserMobile": mobile,
      "RatingValue": _rating,
      "Review": _comment.trim(),
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );

      if (response.statusCode == 200) {
        debugPrint("Feedback Updated Successfully");
      } else {
        debugPrint("Failed to Update Feedback");
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Reset state for editing feedback
  void enableEditing() {
    _isSubmitted = false;
    notifyListeners();
  }
}
