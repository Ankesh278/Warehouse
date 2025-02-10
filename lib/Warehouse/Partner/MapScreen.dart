import 'package:Lisofy/Warehouse/Partner/Provider/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';



class LocationSelectionScreen extends StatefulWidget {
  @override
  _LocationSelectionScreenState createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get current location on initialization
  }

  Future<void> _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
    mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    _getAddressFromLatLng(currentLocation!); // Set address in the text box

    // Update the provider with the current location
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    locationProvider.updateLocation(
      addressController.text,
      currentLocation!,
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        setState(() {
          addressController.text = address;
        });
      }
    } catch (e) {
      print('Error fetching address: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _selectAddress() async {
    String address = addressController.text;
    List<Location> locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      setState(() {
        currentLocation = LatLng(locations[0].latitude, locations[0].longitude);
      });
      mapController?.animateCamera(CameraUpdate.newLatLng(currentLocation!));

      // Update the provider with the selected address
      final locationProvider = Provider.of<LocationProvider>(context, listen: false);
      locationProvider.updateLocation(address, currentLocation!);
    }
  }

  void _returnLocation() {
    if (currentLocation != null) {
      // Create a LocationData object with the current location and address
      LocationData locationData = LocationData(currentLocation!, addressController.text);
      Navigator.pop(context, locationData); // Pass the LocationData object back to the previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        actions: [
          IconButton(
            icon: Icon(Icons.check,color: Colors.blue,),
            onPressed: _returnLocation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                    if (currentLocation != null) {
                      _getCurrentLocation(); // Set current location on map
                    }
                  },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(28.596634, 77.404570), // Default location
                    zoom: 14,
                  ),
                  markers: currentLocation != null
                      ? {Marker(markerId: MarkerId('currentLocation'), position: currentLocation!)}
                      : {},
                  onTap: (position) {
                    setState(() {
                      currentLocation = position;
                    });
                    _getAddressFromLatLng(position); // Update the address when the user taps on the map
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: addressController,
                          decoration: InputDecoration(

                            labelText: 'Enter Address',
                            border: InputBorder.none,
                            hintText: 'Type your address here',
                            hintStyle: TextStyle(fontSize: 12)
                          ),
                          style: TextStyle(
                            color: Colors.blue, // Text color
                            fontSize: 10, // Font size
                            fontWeight: FontWeight.w700, // Normal font weight
                          ),
                          onSubmitted: (_) => _selectAddress(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _selectAddress,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0), // Text color
                elevation: 5, // Add elevation for a shadow effect
              ),
              child: Text(
                'Get Address',
                style: TextStyle(
                  fontSize: 18, // Larger font size for visibility
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

class LocationData {
  final LatLng latLng;
  final String address;

  LocationData(this.latLng, this.address);
}

// ElevatedCard Widget
class ElevatedCard extends StatelessWidget {
  final Widget child;

  ElevatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child,
      ),
    );
  }
}
