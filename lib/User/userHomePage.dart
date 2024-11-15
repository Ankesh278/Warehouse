import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/User/UserProvider/sortingProvider.dart';
import 'package:warehouse/User/models/WarehouseModel.dart';
import 'package:warehouse/User/searchLocationUser.dart';
import 'package:warehouse/User/userNotificationScreen.dart';
import 'package:warehouse/User/userProfileScreen.dart';
import 'package:warehouse/User/userShortlistedintrested.dart';
import 'package:warehouse/User/wareHouseDetails.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';

class userHomePage extends StatefulWidget {
  final latitude;
  final longitude;
   const userHomePage({super.key, this.latitude, this.longitude});

  @override
  State<userHomePage> createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late Future<List<interestedModel>> futureWarehouses;
   int warehouseCount=0;
   String address="";



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }
  int _currentIndex = 0;
  final List<String> _images = [
    'assets/images/slider3.jpg', // First Image URL
    'assets/images/slider2.jpg', // Second Image URL
  ];

  late PageController _pageControllerSlider;
  late Timer _timer;

  bool isSortApplied = false;
  bool isNearbyEnabled = false;
  bool isPriceEnabled = false;
  bool isPriceEnabledmaxtomin = false;
  bool isAreaMinToMax = false;
  bool isAreaMaxToMin = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  List<String> constructionTypes = ['']; // Example construction types
  List<String> warehouseTypes = ['']; // Example warehouse types
  String rentRange = ''; // Example rent range
  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("Curetn${widget.latitude}");
    }
    if (kDebugMode) {
      print("Curetn${widget.longitude}");
    }
    ///Warehouse Fetching
    futureWarehouses = fetchWarehouses(widget.latitude, widget.longitude,constructionTypes,warehouseTypes,rentRange);
    _pageControllerSlider = PageController(initialPage: _currentIndex);
    // Auto-slide after every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _images.length - 1) {
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

    // Animation Controller to control the border animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeats indefinitely

    // Tween Animation for the glowing light to move along the border
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

  }


  Future<List<interestedModel>> fetchWarehouses(
      double latitude,
      double longitude,
      List<String> constructionTypes,
      List<String> warehouseTypes,
      String rentRange,
      ) async {
    const url = 'https://xpacesphere.com/api/Wherehousedt/GetNLocation';

    // Create the request body with the necessary parameters
    final Map<String, dynamic> body = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "constructiontypes": constructionTypes.map((e) => "'$e'").join(','),
      "warehousetypes": warehouseTypes.map((e) => "'$e'").join(','),
      "rentrange": rentRange,
    };

    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['data'] != null && responseData['data'].isNotEmpty) {
        List jsonResponse = responseData['data'];
        // Count the number of warehouses
        warehouseCount = jsonResponse.length;
        if (kDebugMode) {
          print("Number of warehouses: $warehouseCount");
        }

        return jsonResponse.map((data) => interestedModel.fromJson(data)).toList();
      } else {
        // Return an empty list if no data is available
        warehouseCount = 0;
        return [];
      }
    } else {
      // Handle other status codes if needed
      const Text("Something went wrong");
      throw Exception('Failed to load warehouses');
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageControllerSlider.dispose(); // Dispose of the PageController
    super.dispose();
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
                _userShortListedIntrestedPage(screenWidth, screenHeight),
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
                              Icons.file_download_outlined, // Bell icon
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
                      _selectedIndex==2?const AssetImage("assets/images/Gear2.png"):const AssetImage('assets/images/Gear.png'),
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
    final sortingProvider = Provider.of<SortingProvider>(context, listen: false);
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
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0,top: 5),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // CustomPaint for the glittering border effect
                                CustomPaint(
                                  painter: GlitterBorderPainter(_animation.value),
                                  child: SizedBox(
                                    width: screenWidth*0.32,
                                    height: screenHeight*0.037,
                                    child: TextButton(
                                      onPressed: () async{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                                        // SharedPreferences pref=await SharedPreferences.getInstance();
                                        // await pref.setBool('isUserLoggedIn', false);
                                        // await pref.setBool('isLoggedIn', true);
                                        // Navigator.of(context).pushAndRemoveUntil(
                                        //   MaterialPageRoute(builder: (context) => HomeScreen()), // Replace with your login page
                                        //       (route) => false,
                                        // );

                                        // Button action
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: const BorderSide(color: Colors.grey, width: 1), // Static grey border
                                        ),
                                      ),
                                      child: Animate(
                                          effects: const [FadeEffect(), ScaleEffect()],
                                          child: const Text(
                                            'Become a Part',
                                            style: TextStyle(
                                              fontSize: 9,
                                              color: Colors.blue,
                                            ),
                                          ).animate(delay: 500.ms, // this delay only happens once at the very start
                                            onPlay: (controller) => controller.repeat(), )
                                              .tint(color: Colors.purple)
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.045),
                              child: Text(
                                "Logo,",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Navigate to the next page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => searchLocationUser()),
                            );
                          },
                          child: SizedBox(
                            width: screenWidth * 0.55,
                            height: screenHeight * 0.09,
                            child: Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 35,
                                child: TextFormField(
                                  enabled: false, // Disable typing here, only show the field
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
                        ),

                        const SizedBox(width: 3),
                        InkWell(
                          child: Container(
                            height: 30,
                            width: 30,
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
                                Icons.notifications,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>userNotificationScreen()));

                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 0,),
                         Text(
                          "$warehouseCount warehouses near you.. ",
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end
                          children: [
                            Container(
                              padding: EdgeInsets.zero,
                              height: 28,
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
                                    "Sort ↑↓",
                                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.blue),
                                  ),
                                  onPressed: () {
                                    // Handle add new button press
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      isScrollControlled: true, // Allows the modal to take full height
                                      builder: (BuildContext context) {
                                        return StatefulBuilder( // Use StatefulBuilder for managing modal state
                                          builder: (BuildContext context, StateSetter setModalState) {
                                            return FractionallySizedBox(
                                              heightFactor: 0.57, // Modal takes up 46% of the screen height, adjust as needed
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    // Sort Container, always visible
                                                    Container(
                                                      height: screenHeight * 0.05,
                                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                                      margin: const EdgeInsets.symmetric(horizontal: 16),
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        border: Border.all(color: Colors.grey),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          const Text(
                                                            'Sort By',
                                                            style: TextStyle(fontSize: 14, color: Colors.white),
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.clear,
                                                              color: sortingProvider.selectedSortOption.isNotEmpty
                                                                  ? Colors.white
                                                                  : Colors.grey,
                                                            ),
                                                            onPressed: sortingProvider.selectedSortOption.isNotEmpty
                                                                ? () {
                                                              setModalState(() {
                                                                sortingProvider.selectedSortOption = '';
                                                                // Update isSortApplied based on sorting option
                                                                isSortApplied = false;
                                                              });
                                                              Navigator.pop(context);
                                                            }
                                                                : null,
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Sorting options
                                                    _buildSortOption(
                                                      context,
                                                      sortingProvider,
                                                      label: 'Near By',
                                                      optionValue: 'Nearby',
                                                    ),
                                                    _buildSortOption(
                                                      context,
                                                      sortingProvider,
                                                      label: 'Price (Min to Max)',
                                                      optionValue: 'PriceMinToMax',
                                                    ),
                                                    _buildSortOption(
                                                      context,
                                                      sortingProvider,
                                                      label: 'Price (Max to Min)',
                                                      optionValue: 'PriceMaxToMin',
                                                    ),
                                                    _buildSortOption(
                                                      context,
                                                      sortingProvider,
                                                      label: 'Area (Min to Max)',
                                                      optionValue: 'AreaMinToMax',
                                                    ),
                                                    _buildSortOption(
                                                      context,
                                                      sortingProvider,
                                                      label: 'Area (Max to Min)',
                                                      optionValue: 'AreaMaxToMin',
                                                    ),

                                                    // // Nearby Container
                                                    // Container(
                                                    //   height: screenHeight * 0.05,
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    //   margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.white,
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     border: Border.all(color: Colors.grey),
                                                    //   ),
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Near By',
                                                    //         style: isNearbyEnabled
                                                    //             ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                    //             : const TextStyle(fontSize: 12, color: Colors.grey),
                                                    //       ),
                                                    //       Checkbox(
                                                    //         checkColor: Colors.white,
                                                    //         activeColor: Colors.green,
                                                    //         value: isNearbyEnabled,
                                                    //         onChanged: (bool? value) {
                                                    //           setModalState(() {
                                                    //             sortingProvider.selectedSortOption = 'Nearby';
                                                    //
                                                    //             Navigator.pop(context);
                                                    //             // isNearbyEnabled = value!;
                                                    //             // isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                    //
                                                    //           });
                                                    //           Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    //
                                                    // // Price (Min to Max) Container
                                                    // Container(
                                                    //   height: screenHeight * 0.05,
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    //   margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.white,
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     border: Border.all(color: Colors.grey),
                                                    //   ),
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Price (Min to max)',
                                                    //         style: isPriceEnabled
                                                    //             ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                    //             : const TextStyle(fontSize: 12, color: Colors.grey),
                                                    //       ),
                                                    //       Checkbox(
                                                    //         checkColor: Colors.white,
                                                    //         activeColor: Colors.green,
                                                    //         value: isPriceEnabled,
                                                    //         onChanged: (bool? value) {
                                                    //           setModalState(() {
                                                    //             sortingProvider.selectedSortOption = 'PriceMinToMax';
                                                    //             Navigator.pop(context);
                                                    //             // isPriceEnabled = value!;
                                                    //             // isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                    //           });
                                                    //          // Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    //
                                                    // // Price (Max to Min) Container
                                                    // Container(
                                                    //   height: screenHeight * 0.05,
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    //   margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.white,
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     border: Border.all(color: Colors.grey),
                                                    //   ),
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Price (Max to min)',
                                                    //         style: isPriceEnabledmaxtomin
                                                    //             ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                    //             : const TextStyle(fontSize: 12, color: Colors.grey),
                                                    //       ),
                                                    //       Checkbox(
                                                    //         checkColor: Colors.white,
                                                    //         activeColor: Colors.green,
                                                    //         value: isPriceEnabledmaxtomin,
                                                    //         onChanged: (bool? value) {
                                                    //           setModalState(() {
                                                    //             sortingProvider.selectedSortOption = 'PriceMaxToMin';
                                                    //
                                                    //             Navigator.pop(context);
                                                    //             // isPriceEnabledmaxtomin = value!;
                                                    //             // isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                    //           });
                                                    //          // Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    //
                                                    // // Area (Min to Max) Container
                                                    // Container(
                                                    //   height: screenHeight * 0.05,
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    //   margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.white,
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     border: Border.all(color: Colors.grey),
                                                    //   ),
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Area (Min to max)',
                                                    //         style: isAreaMinToMax
                                                    //             ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                    //             : const TextStyle(fontSize: 12, color: Colors.grey),
                                                    //       ),
                                                    //       Checkbox(
                                                    //         checkColor: Colors.white,
                                                    //         activeColor: Colors.green,
                                                    //         value: isAreaMinToMax,
                                                    //         onChanged: (bool? value) {
                                                    //           setModalState(() {
                                                    //             sortingProvider.selectedSortOption = 'AreaMinToMax';
                                                    //
                                                    //             Navigator.pop(context);
                                                    //             // isAreaMinToMax = value!;
                                                    //             // isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                    //           });
                                                    //          // Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    //
                                                    // // Area (Max to Min) Container
                                                    // Container(
                                                    //   height: screenHeight * 0.05,
                                                    //   padding: const EdgeInsets.symmetric(horizontal: 16),
                                                    //   margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                                                    //   decoration: BoxDecoration(
                                                    //     color: Colors.white,
                                                    //     borderRadius: BorderRadius.circular(8),
                                                    //     border: Border.all(color: Colors.grey),
                                                    //   ),
                                                    //   child: Row(
                                                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    //     children: [
                                                    //       Text(
                                                    //         'Area (Max to min)',
                                                    //         style: isAreaMaxToMin
                                                    //             ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                    //             : const TextStyle(fontSize: 12, color: Colors.grey),
                                                    //       ),
                                                    //       Checkbox(
                                                    //         checkColor: Colors.white,
                                                    //         activeColor: Colors.green,
                                                    //         value: isAreaMaxToMin,
                                                    //         onChanged: (bool? value) {
                                                    //           setModalState(() {
                                                    //             sortingProvider.selectedSortOption = 'AreaMaxToMin';
                                                    //
                                                    //             Navigator.pop(context);
                                                    //             // isAreaMaxToMin = value!;
                                                    //             // isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                    //           });
                                                    //          // Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );




                                  },
                                ),
                              ),
                            ),

                            InkWell(
                              child: Container(
                                margin: const EdgeInsets.only(right: 18),
                                height: 26, // Adjusted height to align with the "Add New" button
                                width: 60, // Adjusted width
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(5), // Rounded corners for consistency
                                ),
                                child: const Center(
                                    child: Text("Filter",style: TextStyle(color: Colors.white),)
                                ),
                              ),
                              onTap: (){
                                showAdvancedFiltersBottomSheet(context);


                              },
                            ),
                          ],
                        )
                      ],
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
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.20, // Adjust to the height you want
                        width: screenWidth,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageControllerSlider,
                              itemCount: _images.length,
                              onPageChanged: (int index) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.all(0), // Margin around the image
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.blue, width: 3), // Blue border
                                  ),
                                  child: Image.asset(
                                    _images[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 250,
                                  ),
                                );
                              },
                            ),
                            Positioned(
                              bottom: 20, // Position the dots just above the bottom
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(_images.length, (index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 500),
                                      margin: const EdgeInsets.symmetric(horizontal: 0),
                                      width: _currentIndex == index ? 16 : 16,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: _currentIndex == index ? Colors.blue : Colors.grey,
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      /// Api data
                      Expanded( // Use Expanded here to allow GridView to take available space
                        child: FutureBuilder<List<interestedModel>>(
                          future: futureWarehouses,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: SpinKitCircle(
                                color: Colors.blue,
                              ));
                            } else if (snapshot.hasError) {
                              return Center(child: Column(
                                children: [
                                  Image.asset(ImageAssets.something),
                                  const Text("Please wait for sometime...",style: TextStyle(color: Colors.black,fontSize: 14),)
                                ],
                              ));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child:
                                  Stack(
                                    children: [
                                      Image.asset(ImageAssets.noWarehouse),
                                      const Center(child: Text("No Warehouse near you..."))
                                    ],
                                  )
                              );
                            } else {
                             // final warehouses = snapshot.data!;
                              return Consumer<SortingProvider>(
                                  builder: (context,sortingProvider,child){
                                    // Make a copy of the data to sort without re-triggering the FutureBuilder
                                    final List<interestedModel> warehouses = List.from(snapshot.data!);


                                    // Apply sorting based on the selected sort option
                                    if (sortingProvider.selectedSortOption == 'PriceMinToMax') {
                                      warehouses.sort((a, b) => a.whouseRent.compareTo(b.whouseRent));
                                    } else if (sortingProvider.selectedSortOption == 'PriceMaxToMin') {
                                      warehouses.sort((a, b) => b.whouseRent.compareTo(a.whouseRent));
                                    } else if (sortingProvider.selectedSortOption == 'AreaMinToMax') {
                                      warehouses.sort((a, b) => a.warehouseCarpetArea.compareTo(b.warehouseCarpetArea));
                                    } else if (sortingProvider.selectedSortOption == 'AreaMaxToMin') {
                                      warehouses.sort((a, b) => b.warehouseCarpetArea.compareTo(a.warehouseCarpetArea));
                                    }

                                    return GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: 0.8,
                                      ),
                                      itemCount: warehouses.length,
                                      itemBuilder: (context, index) {
                                        final warehouse = warehouses[index];
                                        return InkWell(
                                          child: Container(
                                            height: screenHeight * 0.25,
                                            width: screenWidth * 0.45,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(15),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.9),
                                                  spreadRadius: 0.5,
                                                  blurRadius: 0.5,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Stack(
                                              children: [
                                                Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(15),
                                                      child: Image.network(
                                                        "https://xpacesphere.com${warehouse.image}",
                                                        width: double.infinity,
                                                        height: screenHeight*0.15,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(children: [
                                                          Container(
                                                            constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                              child: Text(
                                                                warehouse.whouseRent.toString(), // Limit to 3 decimal places
                                                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700),
                                                                textAlign: TextAlign.start, // Align text as needed
                                                              ),
                                                            ),
                                                          ),
                                                          const Text(
                                                            "  per sq.ft",
                                                            style: TextStyle(fontSize: 5, fontWeight: FontWeight.w400, color: Colors.black),
                                                          ),
                                                        ]),
                                                        Row(children: [
                                                          const Text(
                                                            "Type: ",
                                                            style: TextStyle(fontSize: 7, fontWeight: FontWeight.w400, color: Colors.grey),
                                                          ),
                                                          Container(
                                                            constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                              child: Text(
                                                                warehouse.whouseType1, // Limit to 3 decimal places
                                                                style: const TextStyle(fontSize: 7, fontWeight: FontWeight.w600, color: Colors.black87),
                                                                textAlign: TextAlign.start, // Align text as needed
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Row(children: [
                                                          const SizedBox(width: 5),
                                                          Image.asset("assets/images/Scaleup.png", height: 20, width: 20),
                                                          Container(
                                                            constraints: const BoxConstraints(maxWidth: 40), // Adjust maxWidth as needed
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                              child: Text(
                                                                warehouse.warehouseCarpetArea.toString(), // Limit to 3 decimal places
                                                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800),
                                                                textAlign: TextAlign.start, // Align text as needed
                                                              ),
                                                            ),
                                                          ),
                                                          const Text(
                                                            " per sq.ft",
                                                            style: TextStyle(fontSize: 5, fontWeight: FontWeight.w400, color: Colors.black),
                                                          ),
                                                        ]),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Row(children: [
                                                          const Icon(Icons.location_on, size: 12),
                                                          Container(
                                                            constraints: const BoxConstraints(maxWidth: 80), // Adjust maxWidth as needed
                                                            child: FittedBox(
                                                              fit: BoxFit.scaleDown, // This will scale down the text if it overflows
                                                              child: Text(
                                                                "${warehouse.distance.toStringAsFixed(3)}km away", // Limit to 3 decimal places
                                                                style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w400, color: Colors.grey),
                                                                textAlign: TextAlign.start, // Align text as needed
                                                              ),
                                                            ),
                                                          ),

                                                        ]),
                                                        Row(children: [
                                                          Image.asset("assets/images/people.png", height: 20, width: 17),
                                                          const SizedBox(width: 5),
                                                          Container(
                                                            height: 20,
                                                            width: 20,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(4),
                                                              border: Border.all(color: Colors.black, width: 2),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                "P",
                                                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                        const SizedBox(width: 5,)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.circular(7)
                                                      ),
                                                      child: const Icon(Icons.file_download_outlined, color: Colors.blue),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => wareHouseDetails(warehouses:warehouse)));
                                          },
                                        );
                                      },
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }



  // Helper widget for each sorting option
  Widget _buildSortOption(
      BuildContext context,
      SortingProvider sortingProvider, {
        required String label,
        required String optionValue,
      }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: sortingProvider.selectedSortOption == optionValue
                ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                : const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Checkbox(
            checkColor: Colors.white,
            activeColor: Colors.green,
            value: sortingProvider.selectedSortOption == optionValue,
            onChanged: (bool? value) {
              if (value == true) {
                sortingProvider.selectedSortOption = optionValue;
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }


  Widget _userShortListedIntrestedPage(double screenWidth, double screenHeight) {
    return userShortlistedIntrested(); // Replace with your actual Notification screen content
  }

  Widget _buildAccountPage(double screenWidth, double screenHeight) {
    return userProfileScreen();
  }
  void showAdvancedFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const AdvancedFiltersBottomSheet();
      },
    );
  }
}



class AdvancedFiltersBottomSheet extends StatefulWidget {
  const AdvancedFiltersBottomSheet({super.key});

  @override
  _AdvancedFiltersBottomSheetState createState() => _AdvancedFiltersBottomSheetState();
}
class _AdvancedFiltersBottomSheetState extends State<AdvancedFiltersBottomSheet> {
  String? selectedFilter;
  bool isClearFilters = true;
  Map<String, List<String>> filterOptions = {
    'Construction Types': ['PEB', 'Cold Storage', 'RCC', 'Shed', 'Factory', 'Others'],
    'Warehouse Types': ['PEB', 'Cold Storage', 'RCC', 'SHED', 'Dark Store', 'Open Space', 'Industrial SHED', 'BTS', 'Multi Storey Building', 'Parking Land'],
    'Rent Range': [], // Empty list to indicate this will use a slider
  };

  Map<String, Map<String, bool>> selectedOptions = {
    'Construction Types': {},
    'Warehouse Types': {},
    'Rent Range': {},
  };
  double minRent = 0;
  double maxRent = 10000;
  RangeValues rentRange = const RangeValues(0, 10000);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height / 1.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header with Close Button
          Container(
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.15, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Advanced Filters",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.clear, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                // Filter Categories
                Container(
                  width: screenWidth / 2,
                  color: Colors.white,
                  child: ListView(
                    children: filterOptions.keys.map((filter) {
                      return Container(
                        height: 30,
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedFilter == filter ? Colors.blue : Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          child: Center(
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedFilter == filter ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                // Filter Options
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: selectedFilter == 'Rent Range'
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Select Rent Range (₹)", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          RotatedBox(
                            quarterTurns: -1,
                            child: RangeSlider(
                              min: minRent,
                              max: maxRent,
                              values: rentRange,
                              onChanged: (RangeValues newRange) {
                                setState(() {
                                  rentRange = newRange;
                                });
                              },
                              divisions: 10,
                              labels: RangeLabels(
                                '${rentRange.start.round()}',
                                '${rentRange.end.round()}',
                              ),
                            ),
                          ),
                          Text("₹${rentRange.start.round()} - ₹${rentRange.end.round()}"),
                        ],
                      ),
                    )
                        : selectedFilter != null
                        ? ListView(
                      padding: EdgeInsets.zero,
                      children: filterOptions[selectedFilter!]!.map((option) {
                        return Container(
                          height: 30,
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.green,
                                value: selectedOptions[selectedFilter]?[option] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedOptions[selectedFilter]![option] = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                        : const Center(child: Text('Select a filter')),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Action Buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: screenHeight * 0.05,
              width: screenWidth * 0.553,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.045,
                  right: screenWidth * 0.03,
                  bottom: screenWidth * 0.013,
                ),
                child: Container(
                  width: screenWidth * 0.25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      // Clear All button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isClearFilters = true;
                            selectedOptions = {
                              'Construction Types': {},
                              'Warehouse Types': {},
                              'Rent Range': {},
                            };
                            rentRange = const RangeValues(0, 10000);
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: screenWidth * 0.22,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Text(
                            "Clear All",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Apply Filters button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isClearFilters = false;
                            Navigator.pop(context);
                            // Here you would apply the filters
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: screenWidth * 0.25,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                          ),
                          child: Text(
                            "Apply Filters",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}





class DottedBorder extends StatelessWidget {
  final Widget child;

  const DottedBorder({super.key, required this.child});

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


class GlitterBorderPainter extends CustomPainter {
  final double progress; // Animation progress value (0.0 to 1.0)

  GlitterBorderPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Static border paint
    final Paint borderPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw the rectangular border
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      borderPaint,
    );

    // Glittering light paint
    final Paint lightPaint = Paint()
      ..color = Colors.amber.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    // Compute the length of the entire border (perimeter of the rectangle)
    final double totalPerimeter = 2 * (size.width + size.height);

    // Calculate the current position of the glitter based on the progress
    final double glitterPosition = progress * totalPerimeter;

    // Compute the position of the glitter light along the border
    Offset glitterOffset;
    if (glitterPosition <= size.width) {
      // Top edge
      glitterOffset = Offset(glitterPosition, 0);
    } else if (glitterPosition <= size.width + size.height) {
      // Right edge
      glitterOffset = Offset(size.width, glitterPosition - size.width);
    } else if (glitterPosition <= 2 * size.width + size.height) {
      // Bottom edge
      glitterOffset = Offset(2 * size.width + size.height - glitterPosition, size.height);
    } else {
      // Left edge
      glitterOffset = Offset(0, totalPerimeter - glitterPosition);
    }

    // Draw the glittering light as a small circle that moves along the border
    canvas.drawCircle(glitterOffset, 5, lightPaint); // Adjust the circle size for the glowing light
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Repaint whenever animation progress changes
  }
}

