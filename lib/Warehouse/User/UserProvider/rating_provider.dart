import 'package:flutter/foundation.dart';
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
  bool isEditing=false;

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
          final latestFeedback = data['data'].last;

          _rating = (latestFeedback['rating'] as num?)?.toDouble() ?? 0.0;
          _comment = latestFeedback['review'] ?? "";
          _isSubmitted = _rating > 0.0 && _comment.isNotEmpty;
          commentController.text = _comment;
          debugPrint("Fetched Rating: $_rating");
          debugPrint("Fetched Comment: $_comment");
          debugPrint("Is Submitted: $_isSubmitted");
        } else {
          debugPrint("No feedback found.");
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
  void getEditing(bool edit){
    isEditing=edit;
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
    if (kDebugMode) {
      print("Api   $apiUrl");
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bodyData),
      );
      if (kDebugMode) {
        print("Response   ${response.body}");
      }
      if (kDebugMode) {
        print("Response   ${response.statusCode}");
      }

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
    if (_rating < 1.0 || _rating > 5.0 || mobile.isEmpty) {
      debugPrint("Update Failed: Rating must be between 1 and 5. Current: $_rating");
      return;
    }
    _isSubmitting = true;
    notifyListeners();

    const String apiUrl = "https://xpacesphere.com/api/Register/UpdateRating";
    final Map<String, String> bodyData = {
      "UserMobile": mobile,
      "RatingValue": _rating.toString(),
      "Review": _comment.trim(),
    };

    if (kDebugMode) {
      print("bodyData: $bodyData");
    }

    try {
      var request = http.MultipartRequest('PUT', Uri.parse(apiUrl));

      bodyData.forEach((key, value) {
        request.fields[key] = value;
      });

      // Send the request
      final response = await request.send();

      // Read response body
      final responseBody = await response.stream.bytesToString();
      debugPrint("Response Status Code: ${response.statusCode}");
      debugPrint("Response Body: $responseBody");

      try {
        final Map<String, dynamic> responseData = json.decode(responseBody);

        if (response.statusCode == 200 && responseData["status"] == 200) {
          _isSubmitted = true;
          debugPrint("Feedback Updated Successfully: ${responseData["message"]}");
        } else {
          debugPrint("Failed to Update Feedback: ${responseData["message"] ?? 'Unexpected response format'}");
        }
      } catch (e) {
        debugPrint("Failed to parse JSON response: $e");
        debugPrint("Raw Response: $responseBody");
      }
    } catch (e) {
      debugPrint("Error Updating Feedback: $e");
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  /// Reset state for editing feedback
  void enableEditing() {
    _isSubmitted = false;
    isEditing=true;
    notifyListeners();
  }
}
