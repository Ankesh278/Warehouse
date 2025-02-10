import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class PhotoProvider extends ChangeNotifier {
  File? _pancardPhoto;
  File? _selfieOfOwnerPhoto;
  File? _aadharCardFrontPhoto;
  File? _aadharCardBackPhoto;


  File? get frontPhoto => _pancardPhoto;
  File? get backPhoto => _selfieOfOwnerPhoto;
  File? get aadharPhotoFront => _aadharCardFrontPhoto;
  File? get aadharPhotoBack => _aadharCardBackPhoto;


  // Update the front photo
  void updatePanPhoto(File? photo) {
    _pancardPhoto = photo;
    notifyListeners();
  }

  // Update the back photo
  void selfieOfOwnerPhotoUpdate(File? photo) {
    _selfieOfOwnerPhoto = photo;
    notifyListeners();
  }

  void aadharCardPhotoFront(File? photo) {
    _aadharCardFrontPhoto = photo;
    notifyListeners();
  }

  void aadharCardPhotoback(File? photo) {
    _aadharCardBackPhoto = photo;
    notifyListeners();
  }

  // Check if photos are uploaded
  bool get arepancardPhotosUploaded => _pancardPhoto != null;
  bool get areselfiePhotosUploaded => _selfieOfOwnerPhoto != null;
  bool get areFrontAadharUploaded => _aadharCardFrontPhoto != null;
  bool get areBackAadharUploaded => _aadharCardBackPhoto != null;


  // Upload all available photos (one by one)
  Future<void> uploadPhotos(String phone) async {
    try {
      final uri = Uri.parse('https://xpacesphere.com/api/Register/OwnerRegistr'); // Replace with your API endpoint
      var request = http.MultipartRequest('POST', uri);

      // Create a map of the photos with their respective field names
      final photos = {
        'PanCard': _pancardPhoto,
        'Selfie': _selfieOfOwnerPhoto,
        'AadharCard': _aadharCardFrontPhoto,
        'AadharCard': _aadharCardBackPhoto,
        'MobileNumber': phone,
      };

      // Loop through each photo and upload if it exists
      for (var entry in photos.entries) {
        final fieldName = entry.key;
        final photo = entry.value;

        if (photo is File) { // Ensure photo is a File before using .path
          var file = await http.MultipartFile.fromPath(
              fieldName, photo.path, contentType: MediaType('image', 'jpeg')
          );
          request.files.add(file);
        } else if (photo is String) { // Handle phone number separately
          request.fields[fieldName] = photo;
        }
      }


      // If there are any files to upload, send the request
      if (request.files.isNotEmpty) {
        var response = await request.send();
print("Api response "+response.stream.toString());
print("Api response "+response.statusCode.toString());
        if (response.statusCode == 200) {
          print('Upload successful');
        } else {
          print('Upload failed with status code: ${response.statusCode}');
        }
      } else {
        print('No photos to upload');
      }
    } catch (e) {
      print('Error occurred during upload: $e');
    }
  }
}
