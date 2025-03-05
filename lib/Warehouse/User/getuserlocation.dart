import 'package:Lisofy/Warehouse/User/user_help_page.dart';
import 'package:Lisofy/new_home_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetUserLocation extends StatefulWidget {
  const GetUserLocation({super.key});

  @override
  State<GetUserLocation> createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  String _coordinates = '';
  Position? position;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
    if (!mounted) return;
    setState(() {
      loading = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        if (!mounted) return;
        setState(() {
          loading = false;
        });
        return;
      }
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      if (!mounted) return;

      setState(() {
        loading = false;
        _coordinates =
        'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
      });

      final pref = await SharedPreferences.getInstance();
      await pref.setDouble('latitude', position.latitude);
      await pref.setDouble('longitude', position.longitude);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => NewHomePage(
            longitude: position.longitude,
            latitude: position.latitude,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        loading = false;
        _coordinates = 'Could not fetch location';
      });

      if (kDebugMode) {
        print("Error fetching location: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: loading
          ? _buildLoadingScreen()
          : buildLocationUI(screenHeight, screenWidth),
    );
  }

  /// **Loading UI with SpinKit and "Please wait..." text**
  Widget _buildLoadingScreen() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitCircle(color: Colors.blue, size: 50),
          SizedBox(height: 10),
          Text(
            "Please wait...",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildLocationUI(double screenHeight, double screenWidth) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.blue,
            width: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    height: screenHeight * 0.18,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.025,
                        left: screenWidth * 0.025,
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(width: 7),
                                  Text("Hello",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                  Text(
                                    "There",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                              const Spacer(),
                              const SizedBox(width: 5),
                              InkWell(
                                child: Container(
                                  height: 32,
                                  width: 32,
                                  margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.question_mark,
                                      color: Colors.blue,
                                      size: 18,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const UserHelpPage()));
                                },
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: screenHeight * 0.07, left: 5),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Get Personalized Recommendations Near You",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.005),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: SingleChildScrollView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15),
                                child: SizedBox(
                                  height: screenHeight * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Search Near Me ',
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(18),
                                      ),
                                      suffixIcon: InkWell(
                                        child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                              BorderRadius.circular(18),
                                              color: Colors.lightBlue,
                                            ),
                                            child: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                            )),
                                        onTap: () {
                                          setState(() {
                                            loading = true;
                                          });
                                          _getCurrentLocation();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              Image.asset(
                                  "assets/images/Pinonthemapwaving.png")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
