import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DistanceCalculator {
  LatLng parseLatLng(String whouseAddress) {
    final regex = RegExp(r'LatLng\(([^,]+), ([^)]+)\)');
    final match = regex.firstMatch(whouseAddress);

    if (match != null) {
      double latitude = double.parse(match.group(1)!);
      double longitude = double.parse(match.group(2)!);
      return LatLng(latitude, longitude);
    } else {
      throw Exception("Invalid format for whouse_address");
    }
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  double calculateDistance(LatLng location1, LatLng location2) {
    return Geolocator.distanceBetween(
      location1.latitude,
      location1.longitude,
      location2.latitude,
      location2.longitude,
    );
  }

  // Function to get distance from current location to warehouse location
  Future<double> getDistanceFromCurrentToWarehouse(String whouseAddress) async {
    LatLng warehouseLatLng = parseLatLng(whouseAddress);
    Position currentPosition = await getCurrentLocation();
    LatLng currentLatLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    return calculateDistance(currentLatLng, warehouseLatLng);
  }
  Future<String> getAddressFromLatLng(String latLngString) async {
    try {
      LatLng latLng = parseLatLng(latLngString);
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.subLocality}, ${place.locality},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
      } else {
        return "Address not found";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
