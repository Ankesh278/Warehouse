import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warehouse/User/ExpressInterestScreen.dart';
import 'package:warehouse/User/UserProvider/InterestProvider.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';


class wareHouseDetails extends StatefulWidget {

   final  warehouses;

  const wareHouseDetails({super.key, this.warehouses});
  @override
  State<wareHouseDetails> createState() => _wareHouseDetailsState();
}

class _wareHouseDetailsState extends State<wareHouseDetails> {



   late PageController _pageControllerSlider;
  late Timer _timer;
  int _currentIndex = 0;
  final List<String> _uploadedImages = [];
   final List<String> _defaultImages = [
     'assets/images/slider3.jpg', // First Image URL
     'assets/images/slider2.jpg', // Second Image URL
   ];

   late String _address = "Fetching address...";
   String? selectedLocation;
   bool isLoading=false;
   late LatLng finalAddress = const LatLng(0.0, 0.0); // Set default value
   LatLng? _latLng;
   @override
  void initState() {
    super.initState();


    // Fetch shortlist status on page load
    Provider.of<CartProvider>(context, listen: false)
        .fetchShortlistStatus(widget.warehouses.id, widget.warehouses.mobile);

    //Address
    _getAddressFromLatLng(widget.warehouses.latitude.toString(),widget.warehouses.longitude.toString());
    //warehouseImage
    String filePath = widget.warehouses.filePath;
    processMediaFilePath(filePath);

    _pageControllerSlider = PageController(initialPage: _currentIndex);
    // Auto-slide after every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _uploadedImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      // Animate to the next page
      _pageControllerSlider.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

   Future<void> _getAddressFromLatLng(String latitudeStr, String longitudeStr) async {
     try {
       // Parse the latitude and longitude strings into doubles
       double latitude = double.parse(latitudeStr.trim());
       double longitude = double.parse(longitudeStr.trim());

       // Set the LatLng
       _latLng = LatLng(latitude, longitude);

       // Get the address from the latitude and longitude
       List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
       if (placemarks.isNotEmpty) {
         Placemark place = placemarks[0];

         setState(() {
           _address = ' ${place.locality}, ${place.administrativeArea}, ${place.country}';
           print(_address);
         });
       }
     } catch (e) {
       print("Error getting address: $e");
     }
   }



   void processMediaFilePath(String filePath) {
    List<String> filePaths = filePath.split(',');

    List<String> photos = [];


    for (var path in filePaths) {
      if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png')) {
        photos.add(path);
      }
    }

    setState(() {
      _uploadedImages.addAll(photos);
    });
    // If there are no uploaded images, use default images
    if (_uploadedImages.isEmpty) {
      setState(() {
        _uploadedImages.addAll(_defaultImages); // Default image path
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    _pageControllerSlider?.dispose(); // Dispose of the PageController
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<CartProvider>(context);
    final isShortlisted = cartProvider.isShortlisted(widget.warehouses.id);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const SizedBox(width: 7,height: 30,),
                                InkWell(child: const Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 18,),
                                  onTap: (){
                                  Navigator.pop(context);
                                  },

                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    // Toggle shortlist state
                                    cartProvider.toggleWarehouse(widget.warehouses.id, widget.warehouses.mobile,context);
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 25,
                                    margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.04),
                                    child: isShortlisted?const Icon(Icons.favorite_outlined,color: Colors.red,):const Icon(Icons.favorite_border,color: Colors.white,)
                                  ),
                                ),

                                InkWell(
                                  onTap: (){
                                    const String baseUrl = 'https://xpacesphere.com';
                                    ShareWarehouseHelper.shareWarehouse(
                                        warehouseName: widget.warehouses.whouseName,
                                        warehouseLocation: finalAddress.toString(),
                                        warehouseDetailsUrl: "https://xpacesphere.com/",
                                        warehousePhotoUrl: "$baseUrl${_uploadedImages[0]}",
                                        context: context,
                                    );
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 25,
                                    margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.04),
                                    decoration: const BoxDecoration(
                                        color: Colors.blue
                                    ),
                                    child: Image.asset("assets/images/Shareicon.png")
                                  ),
                                ),

                              ],
                            )
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
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.28,
                                    width: screenWidth,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.25,
                                          width: screenWidth,
                                          child: PageView.builder(
                                            controller: _pageControllerSlider,
                                            itemCount: _uploadedImages.length,
                                            onPageChanged: (int index) {
                                              setState(() {
                                                _currentIndex = index;
                                              });
                                            },
                                            itemBuilder: (context, index) {
                                              const String baseUrl = 'https://xpacesphere.com';
                                              return Container(
                                                margin: const EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20),
                                                  border: Border.all(color: Colors.white, width: 0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20),
                                                  child: Image.network(
                                                    Uri.encodeFull('$baseUrl${_uploadedImages[index]}'),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Image.asset(
                                                        ImageAssets.defaultImage, // Path to your default image
                                                        width: double.infinity,
                                                        height: 110,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(_uploadedImages.length, (index) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                              child: AnimatedContainer(
                                                duration: const Duration(milliseconds: 500),
                                                width: _currentIndex == index ? 20 : 20,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: _currentIndex == index ? Colors.blue : Colors.grey,
                                                  borderRadius: BorderRadius.circular(3),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                    height: screenHeight*0.05,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 15,),
                                        Container(
                                          constraints: const BoxConstraints(maxWidth: 40),
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text("₹ ${widget.warehouses.whouseRent}",
                                              style: const TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                        const Text(" Rent sq.ft",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                                        const Spacer(),
                                        Tooltip(
                                          message: "The price range is based on the owner's expectations",
                                          child: Container(
                                            height: screenHeight * 0.05,
                                            width: screenWidth * 0.10,
                                            decoration: const BoxDecoration(
                                              color: Colors.blue,
                                            ),
                                            child: const Icon(
                                              Icons.help_center_outlined,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: screenHeight*0.12,
                                        width: screenWidth*0.37,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: Colors.grey,width: 1.5),
                                          shape: BoxShape.rectangle
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    widget.warehouses.warehouseCarpetArea.toString(), // Limit to 3 decimal places
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4.0),
                                              child: Text("Available area",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            const SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    widget.warehouses.whouseToken.toString(), // Limit to 3 decimal places
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4.0),
                                              child: Text("Security deposit",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight*0.12,
                                        width: screenWidth*0.37,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey,width: 1.5),
                                            shape: BoxShape.rectangle
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 50), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    widget.warehouses.whouseType1, // Limit to 3 decimal places
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4.0),
                                              child: Text("Warehouse Type",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            const SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    widget.warehouses.whouseType2, // Limit to 3 decimal places
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(left: 4.0),
                                              child: Text("Floor type",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 13,),
                                  const Align(
                                   alignment: Alignment.centerLeft,
                                   child: Padding(
                                     padding: EdgeInsets.only(left: 15.0),
                                     child: Text("Address",style: TextStyle(
                                       fontSize: 13,
                                       fontWeight: FontWeight.w500
                                     ),),
                                   ),
                                 ),
                                  const SizedBox(height: 13,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15),
                                    height: screenHeight*0.07,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey,width: 1.5),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                constraints: const BoxConstraints(maxWidth: 130), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    _address, // Limit to 3 decimal places
                                                    style: const TextStyle( fontWeight: FontWeight.w500,fontSize: 13),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: screenWidth*0.5), // Adjust maxWidth as needed
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                  child: Text(
                                                    widget.warehouses.distance.toStringAsFixed(3)+" km away from your current Location", // Limit to 3 decimal places
                                                    style: const TextStyle( fontWeight: FontWeight.w400, color: Colors.grey,fontSize: 12),
                                                    textAlign: TextAlign.start, // Align text as needed
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0,top: 3,bottom: 3),
                                          child: InkWell(
                                            onTap: (){
                                              _openMap(widget.warehouses.latitude, widget.warehouses.longitude);

                                            },
                                              child: ClipOval(
                                                child: Image.asset(
                                                  ImageAssets.map, // Replace with your image asset path
                                                  height: 50.0, // Set the height of the circular image
                                                  width: 40.0,  // Set the width of the circular image
                                                  fit: BoxFit.cover, // Ensures the image covers the circular area
                                                ),
                                              ),),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 13,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15),
                                    height: screenHeight*0.12,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey,width: 1.5),
                                        borderRadius: BorderRadius.circular(5)
                                    ),

                                  ),
                                  const SizedBox(height: 7,),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 17.0),
                                      child: Text("Amenities",style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(padding: const EdgeInsets.only(left: 10),
                                    child: Container(
                                      height: screenHeight*0.08,
                                      width: screenWidth*0.27,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3),
                                          border: Border.all(color: Colors.grey,width: 1.5),
                                          shape: BoxShape.rectangle,
                                        color: Colors.blue
                                      ),
                                      child: const Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text("40 KWA",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                                          Text("Electricity",style: TextStyle(color: Colors.white,fontSize: 8),)

                                        ],
                                      ),
                                    ),
                                    ),
                                  ),
                                  const SizedBox(height: 7,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: screenHeight*0.08,
                                        width: screenWidth*0.27,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey,width: 1.5),
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/Toilet.png"),
                                            const Text("Toilet | 2",style: TextStyle(color: Colors.white,fontSize: 8),)

                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight*0.08,
                                        width: screenWidth*0.27,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey,width: 1.5),
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/DumpTruck.png"),
                                            const Text("Truck slot | 2",style: TextStyle(color: Colors.white,fontSize: 8),)

                                          ],
                                        ),
                                      ),
                                      Container(
                                        height: screenHeight*0.08,
                                        width: screenWidth*0.27,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey,width: 1.5),
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/Office.png"),
                                            const Text("Office space",style: TextStyle(color: Colors.white,fontSize: 8),)

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: 7,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(padding: const EdgeInsets.only(left: 10),
                                      child: Container(
                                        height: screenHeight*0.08,
                                        width: screenWidth*0.27,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.grey,width: 1.5),
                                            shape: BoxShape.rectangle,
                                            color: Colors.blue
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.asset("assets/images/QuadBike.png"),
                                            const Text("Bike parking slot",style: TextStyle(color: Colors.white,fontSize: 8),)

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.05,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: screenHeight*0.0415,
                                        width: screenWidth*0.34,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.blue),
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.calendar_today_outlined,color: Colors.blue,size: 16,),
                                            SizedBox(width: 4,),
                                            Text("Schedule a visit",style: TextStyle(color: Colors.blue,fontSize: 10),)
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: screenHeight*0.0415,
                                          width: screenWidth*0.34,
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                              border: Border.all(color: Colors.blue),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 10,),
                                              Text("Express Interest",style: TextStyle(color: Colors.white,fontSize: 10),),
                                              Spacer(),
                                              Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 16,),
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpressInterestScreen(id:widget.warehouses.id)));
                                        },
                                      ),
                                    ],
                                  )






                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

   Future<void> _openMap(double lat, double lng) async {
     final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
     if (await canLaunch(url)) {
       await launch(url);
     } else {
       throw 'Could not launch $url';
     }
   }

}



class ShareWarehouseHelper {
  /// Check for location permissions and fetch current location
  static Future<String> getLocationUrl() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          "Location permissions are permanently denied, cannot access location.");
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition();
    return "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
  }

  /// Share Warehouse Details
  static Future<void> shareWarehouse({
    required String warehouseName,
    required String warehouseLocation,
    required String warehouseDetailsUrl,
    required String warehousePhotoUrl,
    required BuildContext context,
  }) async {
    try {
      // Get the user's current location URL
      String locationUrl = await getLocationUrl();

      // Prepare the sharing message
      String message = '''
📦 Check out this Warehouse!

🏢 Name: $warehouseName
📍 Location: $warehouseLocation
🌐 Warehouse Details: $warehouseDetailsUrl

📸 Photo: $warehousePhotoUrl
🗺️ Location URL: $locationUrl
      ''';

      // Share the message
      Share.share(message);
    } catch (e) {
      // Show an error message if location or sharing fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
















