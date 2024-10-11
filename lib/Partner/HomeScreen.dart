
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Partner/AddWarehouse.dart';
import 'package:warehouse/Partner/HelpPage.dart';
import 'package:warehouse/Partner/MyProfilePage.dart';
import 'package:warehouse/Partner/NotificationScreen.dart';
import 'package:warehouse/Partner/Provider/warehouseProvider.dart';
import 'package:warehouse/Partner/WarehouseUpdate.dart';
import 'package:warehouse/Partner/models/warehousesModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key,  this.name='Guest'});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WarehouseResponse> futureWarehouseResponse;
  final TextEditingController _searchcontroller=TextEditingController();

  final String warehouseName = 'WarehouseX';
  final String benefitsText =
      'WarehouseX offers the best solutions for storing your goods securely and efficiently.';
  final String appInfoText = 'Download WarehouseX app for amazing offers!';
  bool light = true;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }



  String? qrData; // This will hold the data to generate the QR code





  @override
  void initState() {
    print("Init State executed");
    // TODO: implement initState
    super.initState();
    futureWarehouseResponse = fetchWarehouseData();


  }
  String _limitDigits(int count) {
    if (count >= 1000) {
      return '999+';
    } else {
      return count.toString();
    }
  }


  Future<WarehouseResponse> fetchWarehouseData() async {
    print("fetch data executed");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone")!;
    if (phone.startsWith("+91")) {
      phone = phone.replaceFirst("+91", "");
    }

    print("Phone>>"+phone.toString());

    if (phone == null) {
      throw Exception('Phone number is not stored in SharedPreferences');
    }

    try {
      final response = await http.get(
        Uri.parse('http://xpacesphere.com/api/Wherehousedt/Wherehousedata?mobile=$phone'),
      );
      print("Api response code"+response.statusCode.toString());
      print("Api response body"+response.body.toString());

      if (response.statusCode == 200) {
        return WarehouseResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load warehouse data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch warehouse data: $e');
    }
  }

@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchcontroller.dispose();
  }
  Future<void> _shareAppInfo() async {
    try {
      // Load assets
      final ByteData logoData = await rootBundle.load('assets/images/house.png');
      final ByteData warehouseImageData =
      await rootBundle.load('assets/images/house1.png');

      // Get temp directory and save the images as files
      final tempDir = await getTemporaryDirectory();
      final File logoFile = File('${tempDir.path}/house.png');
      final File warehouseImageFile =
      File('${tempDir.path}/house1.png');

      await logoFile.writeAsBytes(logoData.buffer.asUint8List());
      await warehouseImageFile.writeAsBytes(warehouseImageData.buffer.asUint8List());

      // Use shareXFiles to share the files and additional text
      await Share.shareXFiles(
        [
          XFile(logoFile.path),
          XFile(warehouseImageFile.path),
        ],
        text: 'WarehouseX\nThe best warehouse business in town!\nContact us for more details.',
        subject: 'WarehouseX Business Info',
      );
    } catch (e) {
      print('Error sharing app info: $e');
    }
  }
  void _showQrDialog(String data) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Warehouse'),
          content: SizedBox(
            height: 200, // Adjust height as needed
            width: 200, // Adjust width as needed
            child: QrImageView(
              data: data, // The data to encode in the QR code
              version: QrVersions.auto, // Automatically selects the best QR version
              size: 150.0, // Size of the QR code
            ),
          ),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
  // Function to get address from latitude and longitude
  Future<String> _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks[0]; // Get the first placemark
      return '${placemark.street}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}'; // Format the address
    } catch (e) {
      print('Error getting address: $e');
      return 'Unknown Location'; // Return a fallback in case of error
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildHomePage(screenWidth, screenHeight),
                _buildNotificationPage(screenWidth, screenHeight),
                _buildAccountPage(screenWidth, screenHeight),
              ],
            ),
          ),
          Container(
            color: Colors.blue,
            height: 35, // Set the height of the custom bottom navigation bar
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.home_filled),
                    color: _selectedIndex == 0 ? Colors.white : Colors.grey[300],
                    onPressed: () => _onItemTapped(0),
                  ),
                ),
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none, // Allow the bell icon to overflow if necessary
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        bottom: 15, // Adjust the bottom position to elevate the icon
                        child: Container(
                          width: 40,  // Set the width of the circle background
                          height: 40, // Set the height of the circle background
                          decoration: BoxDecoration(
                            color: _selectedIndex==1?Colors.blue:const Color(0xffD9D9D9), // Circle background color
                            shape: BoxShape.circle, // Make the background circular
                            border: Border.all(
                              color: Colors.white, // White border color
                              width: 1, // Border width of 1 pixel
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications, // Bell icon
                              color: _selectedIndex==1?Colors.white:Colors.blue, // Set the icon color to blue
                              size: 24, // Adjust the size of the icon
                            ),
                            onPressed: () => _onItemTapped(1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: IconButton(
                    icon: ImageIcon(
                      _selectedIndex==2?const AssetImage("assets/images/MaleUsercolored.png"):const AssetImage('assets/images/MaleUser.png'),
                      color: _selectedIndex == 2 ? Colors.white : Colors.grey[300],
                    ),
                    onPressed: () => _onItemTapped(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage(double screenWidth, double screenHeight) {
    final warehouseProvider = Provider.of<WarehouseProvider>(context);

    return Container(
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
                  top: screenHeight * 0.0,
                  left: screenWidth * 0.015,
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.03),
                              child: Text(
                                "Hello",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.030),
                              child: Text(
                                widget.name.isNotEmpty
                                    ? (widget.name.length > 7
                                    ? '${widget.name.substring(0, 7)}...' // Truncate after 7 characters
                                    : widget.name) // Show full name if it's 7 or fewer characters
                                    : 'Guest',
                                maxLines: 1, // Limit to one line
                                overflow: TextOverflow.ellipsis, // Ellipsis if the text overflows
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                            )


                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: screenWidth * 0.55,
                          height: screenHeight * 0.1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              height: 35,
                              child: TextFormField(
                                controller: _searchcontroller,
                                decoration: InputDecoration(
                                  hintText: 'Search by location',
                                  hintStyle: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                  ),
                                  suffixIcon: const Icon(Icons.search, color: Colors.blue, size: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpPage()));
                           // Navigator.push(context, MaterialPageRoute(builder: (context)=>const Warehouseitemdesign()));

                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Manage your warehouse quickly!",
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end
                            children: [
                              Container(
                                padding: EdgeInsets.zero,
                                height: 30,
                                width: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: TextButton(
                                    child: const Text(
                                      "Add New",
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.normal, color: Colors.blue),
                                    ),
                                    onPressed: () {

                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddWareHouse()));
                                      // Handle add new button press
                                    },
                                  ),
                                ),
                              ),
                              // Increased space between buttons
                              Container(
                                margin: const EdgeInsets.only(right: 18),
                                height: 30, // Adjusted height to align with the "Add New" button
                                width: 30, // Adjusted width
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Rounded corners for consistency
                                ),
                                child: Center(
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20, // Adjusted icon size for better alignment
                                    ),
                                    onPressed: () {
                                      // Handle add button press
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AddWareHouse()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
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
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: FutureBuilder<WarehouseResponse>(
                  future: futureWarehouseResponse,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: SpinKitCircle(
                        color: Colors.blue,
                        size: 50.0,
                      ));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final warehouseList = snapshot.data!.data; // Access the list of warehouses

                      return warehouseList.isEmpty
                          ? Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Image.asset("assets/images/house.png", height: 150, width: 223)),
                              const Center(
                                child: Text(
                                  "Start by adding your first warehouse",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 15),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Add warehouse details to attract potential customers",
                                    style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12, color: Colors.grey),
                                  ),
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                                  child: DottedBorder(
                                    child: Container(
                                      color: Colors.blue,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add Warehouse',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => AddWareHouse()), // Navigate to AddWarehouse screen
                                  );
                                },
                              ),
                              Center(child: Image.asset("assets/images/man.png")),
                              const SizedBox(height: 10),
                              const Center(
                                child: Text(
                                  "We are happy to help you!",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Center(
                                child: Text(
                                  "Need Assistance >>",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : ListView.builder(

                        itemCount: warehouseList.length,
                        itemBuilder: (context, index) {
                          final warehouse = warehouseList[index];
                          // Assuming `isAvailable` is the property that indicates switch state
                          print("availability"+warehouse.isavilable.toString());
                          bool isavail = warehouseProvider.warehouseStatus[warehouse.id] ?? warehouse.isavilable;


                         // bool isavail=warehouse.isavilable;

                          // print("carpetarea"${warehouse.whouseCarpetArea});
                          return GestureDetector(
                            onTap: (){

                              Navigator.push(context, MaterialPageRoute(builder: (context)=>Warehouseupdate( warehouse: warehouse,)));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    decoration:
                                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                    margin: EdgeInsets.only(top: screenHeight * 0.01, left: 10),
                                    padding: const EdgeInsets.all(15),
                                    child: DottedBorder(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  warehouse.whouseName.isNotEmpty
                                                      ? (warehouse.whouseName.length > 7
                                                      ? '${warehouse.whouseName.substring(0, 7)}...' // Truncate after 7 characters
                                                      : warehouse.whouseName) // Show full name if it's 7 or fewer characters
                                                      : 'N/A', // Provide a fallback if the name is empty
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),

                                                const Spacer(),
                                                InkWell(child: Image.asset("assets/images/Share.png")
                                                ,onTap:  (){
                                                  _shareAppInfo();
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                InkWell(child: Image.asset("assets/images/QrCode.png"),
                                                onTap: (){
                                                  // Set QR data to the specific warehouse information
                                                  String data = 'Warehouse Name: ${warehouse.whouseName}\nLocation: ${warehouse.whouseAddress}\nContact: ${warehouse.mobile}'; // Customize this
                                                  _showQrDialog(data); // Show the QR dialog
                                                },
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  warehouseProvider.warehouseStatus[warehouse.id.toString()] ?? warehouse.isavilable
                                                      ? ". Vaccant" // Display text based on availability
                                                      : ". Rented", // Optional, in case you want different text when unavailable
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: warehouseProvider.warehouseStatus[warehouse.id.toString()] ?? warehouse.isavilable
                                                        ? Colors.red // Red when available (true)
                                                        : Colors.green, // Grey when unavailable (false)
                                                    fontSize: 10,
                                                  ),
                                                ),

                                                const SizedBox(width: 20),
                                                const Text(
                                                  "  | WHNOW-UP-GAU-27142",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(width: screenWidth * 0.05 ),
                                                Text(
                                                  warehouse.whouseCarpetArea != null
                                                      ? (warehouse.whouseCarpetArea.toString().length > 6
                                                      ? '${warehouse.whouseCarpetArea.toString().substring(0, 6)}... sq.ft'
                                                      : '${warehouse.whouseCarpetArea} sq.ft')
                                                      : 'N/A',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),

                                                Spacer(),
                                                Text(
                                                  warehouse.whouseRent != null
                                                      ? (warehouse.whouseRent.toString().length > 6
                                                      ? '₹ ${warehouse.whouseRent.toString().substring(0, 6)}...'
                                                      : '₹ ${warehouse.whouseRent}')
                                                      : '₹ N/A',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                ),

                                                SizedBox(width: screenWidth * 0.1)
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Carpet Area (Sq.ft)",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize: 10),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "  | Rent per Sq.ft / Month",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.grey,
                                                      fontSize: 10),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 4,
                                                  child: Container(
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffF0F4FD),
                                                      border: Border.all(color: const Color(0xffF0F4FD)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "View Request | ${_limitDigits(0)}", // Limit to 3 digits
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  flex: 3,
                                                  child: Container(
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffF0F4FD),
                                                      border: Border.all(color: const Color(0xffF0F4FD)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Bids | ${_limitDigits(0)}", // Limit to 3 digits
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Flexible(
                                                  flex: 4,
                                                  child: Container(
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xffF0F4FD),
                                                      border: Border.all(color: const Color(0xffF0F4FD)),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        "Contracts | ${_limitDigits(0)}", // Limit to 3 digits
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          ,
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text("Is warehouse available?"),
                                              Row(
                                                children: [
                                                  const Text("No",style: TextStyle(color: Colors.grey,fontSize: 11,fontWeight: FontWeight.w500),),
                                                  // Switch button with Provider
                                                  Switch(
                                                    hoverColor: Colors.white,
                                                    activeTrackColor: Colors.green,
                                                    focusColor: Colors.white,
                                                    activeColor: Colors.white, // Green color when switch is on
                                                    inactiveThumbColor: Colors.grey, // Grey color when switch is off
                                                    value: warehouseProvider.warehouseStatus[warehouse.id.toString()] ?? warehouse.isavilable,
                                                    onChanged: (bool value) {
                                                      // Immediately reflect the change in the UI
                                                      warehouseProvider.initializeStatus(warehouse.id.toString(), value);

                                                      // Call the provider method to update the status on the server
                                                      warehouseProvider.updateWarehouseStatus(warehouse.id.toString(), value).catchError((error) {
                                                        // Optionally revert the change if the API call fails
                                                        warehouseProvider.initializeStatus(warehouse.id.toString(), !value);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text('Failed to update warehouse status!')),
                                                        );
                                                      });
                                                    },
                                                  ),
                                                  const Text("Yes",style: TextStyle(fontSize: 11,color: Colors.grey,fontWeight: FontWeight.w500),),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(child: Text('No Data Found'));
                    }
                  },
                ),

              ),
            ),
          ],
        ),
      ),
    );

  }



  Widget _buildNotificationPage(double screenWidth, double screenHeight) {
    return NotificationScreen(); // Replace with your actual Notification screen content
  }

  Widget _buildAccountPage(double screenWidth, double screenHeight) {
    return MyProfilePage();
  }




  Future<void> updateWarehouseStatus(String warehouseId, bool status) async {
    final url = Uri.parse('http://xpacesphere.com/api/Wherehousedt/UpdIsAvailable');  // Updated to HTTPS

    try {
      // Send the HTTP POST request
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},  // Setting the header for JSON data
        body: json.encode({
          'Id': warehouseId,         // The Id parameter, should match the correct field name
          'isavailable': status      // The isavailable status
        }),
      );

      // Check for success or failure
      if (response.statusCode == 200) {
        print('Warehouse status updated successfully');
      } else {
        print('Failed to update warehouse status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error updating warehouse status: $e');
    }
  }







}

class DottedBorder extends StatelessWidget {
  final Widget child;

  const DottedBorder({required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(),
      child: child,
    );
  }
}

class DottedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double dashWidth = 4.0;
    const double dashSpace = 4.0;
    double startX = 0;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw dotted border
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.height) {
      canvas.drawLine(
        Offset(size.width, startX),
        Offset(size.width, startX + dashWidth),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.width) {
      canvas.drawLine(
        Offset(size.width - startX, size.height),
        Offset(size.width - startX - dashWidth, size.height),
        paint,
      );
      startX += dashWidth + dashSpace;
    }

    startX = 0; // Reset startX for the next side
    while (startX < size.height) {
      canvas.drawLine(
        Offset(0, size.height - startX),
        Offset(0, size.height - startX - dashWidth),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
