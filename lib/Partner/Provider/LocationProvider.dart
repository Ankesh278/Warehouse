import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationProvider with ChangeNotifier {
  String _location = "Unknown"; // Initial location value
  LatLng? _latLng;

  // Getter for location
  String get location => _location;
  LatLng? get latLng => _latLng;

  // Method to update location
  void updateLocation(String newLocation, LatLng newLatLng) {
    _location = newLocation;
    _latLng = newLatLng;
    notifyListeners(); // Notify listeners to update the UI
  }
}
