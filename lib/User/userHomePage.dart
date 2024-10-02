import 'dart:async';

import 'package:flutter/material.dart';
import 'package:warehouse/Partner/AddWarehouse.dart';
import 'package:warehouse/Partner/MyProfilePage.dart';
import 'package:warehouse/Partner/NotificationScreen.dart';
import 'package:warehouse/Partner/WarehouseItemDesign.dart';
import 'package:warehouse/User/searchLocationUser.dart';
import 'package:warehouse/User/userNotificationScreen.dart';
import 'package:warehouse/User/userProfileScreen.dart';
import 'package:warehouse/User/userShortlistedintrested.dart';
import 'package:warehouse/User/wareHouseDetails.dart';

class userHomePage extends StatefulWidget {
  @override
  State<userHomePage> createState() => _userHomePageState();
}

class _userHomePageState extends State<userHomePage> {
  int _selectedIndex = 0;
  PageController _pageController = PageController();

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

  @override
  void initState() {
    super.initState();
    _pageControllerSlider = PageController(initialPage: _currentIndex);

    // Auto-slide after every 3 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      // Animate to the next page
      _pageControllerSlider.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    _pageControllerSlider?.dispose(); // Dispose of the PageController
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
                          child: Container(
                            width: screenWidth * 0.55,
                            height: screenHeight * 0.1,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
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
                                Icons.notifications,
                                color: Colors.blue,
                                size: 18,
                              ),
                            ),
                          ),
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>userNotificationScreen()));
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const Warehouseitemdesign()));

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
                            "498 warehouses near Noida ",
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
                                                heightFactor: 0.46, // Modal takes up 46% of the screen height, adjust as needed
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
                                                                color: isSortApplied ? Colors.white : Colors.grey,
                                                              ),
                                                              onPressed: isSortApplied
                                                                  ? () {
                                                                setModalState(() {
                                                                  isAreaMinToMax = false;
                                                                  isAreaMaxToMin = false;
                                                                  isNearbyEnabled = false;
                                                                  isPriceEnabled = false;
                                                                  isPriceEnabledmaxtomin = false;
                                                                  isSortApplied = false;
                                                                });
                                                              }
                                                                  : null,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Nearby Container
                                                      Container(
                                                        height: screenHeight * 0.05,
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
                                                              'Near By',
                                                              style: isNearbyEnabled
                                                                  ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                                  : const TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              activeColor: Colors.green,
                                                              value: isNearbyEnabled,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  isNearbyEnabled = value!;
                                                                  isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Price (Min to Max) Container
                                                      Container(
                                                        height: screenHeight * 0.05,
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
                                                              'Price (Min to max)',
                                                              style: isPriceEnabled
                                                                  ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                                  : const TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              activeColor: Colors.green,
                                                              value: isPriceEnabled,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  isPriceEnabled = value!;
                                                                  isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Price (Max to Min) Container
                                                      Container(
                                                        height: screenHeight * 0.05,
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
                                                              'Price (Max to min)',
                                                              style: isPriceEnabledmaxtomin
                                                                  ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                                  : const TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              activeColor: Colors.green,
                                                              value: isPriceEnabledmaxtomin,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  isPriceEnabledmaxtomin = value!;
                                                                  isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Area (Min to Max) Container
                                                      Container(
                                                        height: screenHeight * 0.05,
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
                                                              'Area (Min to max)',
                                                              style: isAreaMinToMax
                                                                  ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                                  : const TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              activeColor: Colors.green,
                                                              value: isAreaMinToMax,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  isAreaMinToMax = value!;
                                                                  isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // Area (Max to Min) Container
                                                      Container(
                                                        height: screenHeight * 0.05,
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
                                                              'Area (Max to min)',
                                                              style: isAreaMaxToMin
                                                                  ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                                                                  : const TextStyle(fontSize: 12, color: Colors.grey),
                                                            ),
                                                            Checkbox(
                                                              checkColor: Colors.white,
                                                              activeColor: Colors.green,
                                                              value: isAreaMaxToMin,
                                                              onChanged: (bool? value) {
                                                                setModalState(() {
                                                                  isAreaMaxToMin = value!;
                                                                  isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                  height: 28, // Adjusted height to align with the "Add New" button
                                  width: 60, // Adjusted width
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5), // Rounded corners for consistency
                                  ),
                                  child: Center(
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
                  child: SingleChildScrollView(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenHeight*0.25, // Adjust to the height you want
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
                                    margin: EdgeInsets.all(0), // Margin around the image
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
                                        borderRadius: BorderRadius.circular(4)
                                      ),
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 500),
                                        margin: EdgeInsets.symmetric(horizontal: 0),
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
                        SizedBox(height: screenHeight*0.015,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: screenHeight*0.25,
                              width: screenWidth*0.45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.9),
                                    spreadRadius: 0.5, // How much the shadow spreads
                                    blurRadius: 0.5, // The blur effect
                                    offset: Offset(0, 2), // Only shift the shadow downwards
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15), // Set this value to half the width/height to make it circular
                                      child: Image.asset(
                                        'assets/images/slider2.jpg',
                                        width: double.infinity, // Define width
                                        height: 110, // Define height
                                        fit: BoxFit.cover, // Ensures the image covers the whole container
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(children: [
                                          Text("₹ 15.00-18.000",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                                          Text("  per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                                        ],),
                                        Row(children: [
                                          Text("Type: ",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.grey),),
                                          Text("Shed",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w600,color: Colors.black),),

                                        ],)

                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                          SizedBox(width: 5,),
                                          Image.asset("assets/images/Scaleup.png",height: 20,width: 20,),
                                          Text("₹45000.00",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                                          Text(" per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                                        ],),


                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(children: [
                                          Icon(Icons.location_on,size: 12,),
                                          Text("6.0 kms away",style: TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: Colors.grey),),

                                        ],),
                                        Row(children: [
                                          Image.asset("assets/images/people.png",height: 20,width: 17,),
                                          SizedBox(width: 5,),
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.black,width: 2)
                                            ),
                                            child: Center(child: Text("P",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 13),)),
                                          )

                                        ],)

                                      ],
                                    ),


                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      color: Colors.white,
                                      child: Icon(Icons.file_download_outlined,color: Colors.blue,),
                                    )
                                  ),
                                )
                                ],
                              )
                            ),
                            InkWell(
                              child: Container(
                                  height: screenHeight*0.25,
                                  width: screenWidth*0.45,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.9),
                                        spreadRadius: 0.5, // How much the shadow spreads
                                        blurRadius: 0.5, // The blur effect
                                        offset: Offset(0, 2), // Only shift the shadow downwards
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(15), // Set this value to half the width/height to make it circular
                                          child: Image.asset(
                                            'assets/images/slider2.jpg',
                                            width: double.infinity, // Define width
                                            height: 110, // Define height
                                            fit: BoxFit.cover, // Ensures the image covers the whole container
                                          ),
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(children: [
                                              Text("₹ 15.00-18.000",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                                              Text("  per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                                            ],),
                                            Row(children: [
                                              Text("Type: ",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w400,color: Colors.grey),),
                                              Text("Shed",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w600,color: Colors.black),),

                                            ],)

                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              SizedBox(width: 5,),
                                              Image.asset("assets/images/Scaleup.png",height: 20,width: 20,),
                                              Text("₹45000.00",style: TextStyle(fontSize: 7,fontWeight: FontWeight.w800),),
                                              Text(" per sq.ft",style: TextStyle(fontSize: 5,fontWeight: FontWeight.w400,color: Colors.black),),

                                            ],),


                                          ],
                                        ),
                                        SizedBox(height: 5,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(children: [
                                              Icon(Icons.location_on,size: 12,),
                                              Text("6.0 kms away",style: TextStyle(fontSize: 8,fontWeight: FontWeight.w400,color: Colors.grey),),

                                            ],),
                                            Row(children: [
                                              Image.asset("assets/images/people.png",height: 20,width: 17,),
                                              SizedBox(width: 5,),
                                              Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(4),
                                                    border: Border.all(color: Colors.black,width: 2)
                                                ),
                                                child: Center(child: Text("P",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 13),)),
                                              )

                                            ],)

                                          ],
                                        ),


                                      ],
                                    ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
                                              color: Colors.white,
                                              child: Icon(Icons.file_download_outlined,color: Colors.blue,),
                                            )
                                        ),
                                      )
                                    ],
                                  )
                              ),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>wareHouseDetails()));
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
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
        return AdvancedFiltersBottomSheet();
      },
    );
  }
}

class AdvancedFiltersBottomSheet extends StatefulWidget {
  @override
  _AdvancedFiltersBottomSheetState createState() => _AdvancedFiltersBottomSheetState();
}

class _AdvancedFiltersBottomSheetState extends State<AdvancedFiltersBottomSheet> {
  String? selectedFilter;
  bool isShortlisted = true;
  bool isClearFilters = true;
  Map<String, List<String>> filterOptions = {
    'Construction Types': ['PEB', 'RCC', 'Shed'],
    'Product Types': ['Cold Storage', 'Others'],
    'Price (rent/sq.ft)': [],
    'Area (sq.ft)': [],
    'Amenities': [],
    'Compliances': [],
    'Services': [],
  };
  Map<String, bool> selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height / 1.9, // Half screen height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded top border
      ),
      child: Column(
        children: [
          Container(
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.15,vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Advanced Filters",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                ),
                IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.clear,color: Colors.white,size: 20,))
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8),border: Border.all(color: Colors.grey)),
          ),
          // Filters List
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  color: Colors.white,
                  child: ListView(
                    children: filterOptions.keys.map((filter) {
                      return Container(
                        height: 30,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedFilter == filter ? Colors.blue : Colors.white, // Change color on selection
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          child: Center(  // Ensure text is centered vertically and horizontally
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 12,
                                color: selectedFilter == filter ? Colors.white : Colors.black, // Change text color based on selection
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
                    child: selectedFilter != null
                        ? ListView(
                      padding: EdgeInsets.zero,
                      children: filterOptions[selectedFilter!]!.map((option) {
                        return Container(
                          height: 30,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.green,
                                value: selectedOptions[option] ?? false,
                                onChanged: (bool? value) {
                                  setState(() {
                                    selectedOptions[option!] = value!;
                                  });
                                },
                              ),
                              Expanded(
                                child: Text(
                                  option,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    )
                        : Center(child: Text('Select a filter')),
                  ),
                ),
              ],
            ),
          ),

      Padding(
        padding: EdgeInsets.only(bottom: 10),
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
                color: Colors.white, // Background color for the toggle container
              ),
              child: Row(
                children: [
                  // Clear All button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isClearFilters = true; // Toggle to Clear Filters
                        selectedOptions.clear(); // Clear Filters Logic
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth * 0.22, // Responsive width based on screen width
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005), // Adjust padding responsively
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Text(
                        "Clear All",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenHeight * 0.015, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                  // Spacer to push Apply Filters to the right
                  Spacer(),
                  // Apply Filters button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isClearFilters = false; // Toggle to Apply Filters
                        Navigator.pop(context); // Apply Filters Logic
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: screenWidth * 0.25, // Responsive width based on screen width
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.005), // Adjust padding responsively
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue,
                      ),
                      child: Text(
                        "Apply Filters",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenHeight * 0.015, // Responsive font size
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )

      ],
      ),
    );
  }
}

class DottedBorder extends StatelessWidget {
  final Widget child;

  DottedBorder({required this.child});

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

