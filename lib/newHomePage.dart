import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Localization/Languages.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/User/userHomePage.dart';
import 'package:warehouse/User/userProfileScreen.dart';
import 'package:warehouse/User/userShortlistedintrested.dart';
import 'package:warehouse/generated/l10n.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';
class newHomePage extends StatefulWidget {
  final longitude;
  final latitude;
  const newHomePage({super.key,required this.latitude,required this.longitude});

  @override
  State<newHomePage> createState() => _newHomePageState();
}

class _newHomePageState extends State<newHomePage>with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }
  int _currentIndex = 0;
  int _trnasportIndex = 0;
  int _manpowertIndex = 0;
  int _agricultureIndex = 0;
  int sliderControllerIndex = 0;
  final List<String> _images = [
    'assets/images/slider3.jpg', // First Image URL
    'assets/images/slider2.jpg', // Second Image URL
  ];

  late PageController _pageControllerSlider;
  late PageController _trnasportConmtroller;
  late PageController _manpowerController;
  late PageController _agricultureController;
  late PageController sliderController;
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  bool isSortApplied = false;
  bool isNearbyEnabled = false;
  bool isPriceEnabled = false;
  bool isPriceEnabledmaxtomin = false;
  bool isAreaMinToMax = false;
  bool isAreaMaxToMin = false;


  @override
  void initState() {
    super.initState();

    // Initialize PageControllers
    _pageControllerSlider = PageController(initialPage: _currentIndex);
    _trnasportConmtroller = PageController(initialPage: _trnasportIndex);
    _manpowerController = PageController(initialPage: _manpowertIndex);
    _agricultureController = PageController(initialPage: _agricultureIndex);
    sliderController = PageController(initialPage: sliderControllerIndex);

    // Auto-slide after every 10 seconds for the slider
    _startAutoSlide(_pageControllerSlider, () {
      if (_currentIndex < _images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    }, 10, const Duration(milliseconds: 5000), Curves.easeInOutCubicEmphasized);

    // Auto-slide for transport
    _startAutoSlide(_trnasportConmtroller, () {
      if (_trnasportIndex < _images.length - 1) {
        _trnasportIndex++;
      } else {
        _trnasportIndex = 0;
      }
    }, 15, const Duration(milliseconds: 300), Curves.slowMiddle);

    // Auto-slide for manpower
    _startAutoSlide(_manpowerController, () {
      if (_manpowertIndex < _images.length - 1) {
        _manpowertIndex++;
      } else {
        _manpowertIndex = 0;
      }
    }, 15, const Duration(milliseconds: 300), Curves.slowMiddle);

    // Auto-slide for agriculture
    _startAutoSlide(_agricultureController, () {
      if (_agricultureIndex < _images.length - 1) {
        _agricultureIndex++;
      } else {
        _agricultureIndex = 0;
      }
    }, 10, const Duration(milliseconds: 5000), Curves.easeInOutCubicEmphasized);

    // Auto-slide for slider controller
    _startAutoSlide(sliderController, () {
      if (sliderControllerIndex < _images.length - 1) {
        sliderControllerIndex++;
      } else {
        sliderControllerIndex = 0;
      }
    }, 10, const Duration(milliseconds: 5000), Curves.easeOut);

    // Animation Controller to control the border animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeats indefinitely

    // Tween Animation for the glowing light to move along the border
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

// Helper method to start auto-slide
  void _startAutoSlide(PageController controller, Function onNext, int seconds, Duration duration, Curve curve) {
    Timer.periodic(Duration(seconds: seconds), (Timer timer) {
      onNext(); // Update the index
      // Animate to the next page
      controller.animateToPage(
        controller.page!.toInt(), // Use current page directly
        duration: duration,
        curve: curve,
      );
    });
  }




  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    _pageControllerSlider.dispose();
    _trnasportConmtroller.dispose();
    _manpowerController.dispose();
    _agricultureController.dispose();
    sliderController.dispose();

    super.dispose();
  }

  // List of images (replace with your own image URLs or asset paths)
  List<String> horizontalSliderImages = [
    'assets/images/wareicon.png',
    'assets/images/truckicon.png',
    'assets/images/fieldicon.png',
    'assets/images/fieldd.png',
    'assets/images/newcrop.png',
  ];

  int horizontalSliderImagesIndex = 0; // Starting index for the images

  // Function to shift images to the left
  void _shiftImagesLeft() {
    // Check if we can move to the next set of images
    if (horizontalSliderImagesIndex + 3 < horizontalSliderImages.length) {
      setState(() {
        horizontalSliderImagesIndex++;
      });
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
               // _userShortListedIntrestedPage(screenWidth, screenHeight),
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
                // Expanded(
                //   child: Stack(
                //     clipBehavior: Clip.none, // Allow the bell icon to overflow if necessary
                //     alignment: Alignment.center,
                //     children: [
                //       Positioned(
                //         bottom: 15, // Adjust the bottom position to elevate the icon
                //         child: Container(
                //           width: 40,  // Set the width of the circle background
                //           height: 40, // Set the height of the circle background
                //           decoration: BoxDecoration(
                //             color: _selectedIndex==1?Colors.blue:const Color(0xffD9D9D9), // Circle background color
                //             shape: BoxShape.circle, // Make the background circular
                //             border: Border.all(
                //               color: Colors.white, // White border color
                //               width: 1, // Border width of 1 pixel
                //             ),
                //           ),
                //           child: IconButton(
                //             icon: Icon(
                //               Icons.file_download_outlined, // Bell icon
                //               color: _selectedIndex==1?Colors.white:Colors.blue, // Set the icon color to blue
                //               size: 24, // Adjust the size of the icon
                //             ),
                //             onPressed: () => _onItemTapped(1),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                Expanded(
                  child: IconButton(
                    icon: ImageIcon(
                      _selectedIndex==2?const AssetImage("assets/images/Gear2.png"):const AssetImage('assets/images/Gear.png'),
                      color: _selectedIndex == 2 ? Colors.white : Colors.grey[300],
                    ),
                    onPressed: () => _onItemTapped(1),
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
                                        child: Text(
                                          S.of(context).became_partner,
                                          style: const TextStyle(
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
                        // GestureDetector(
                        //   onTap: () {
                        //     // Navigate to the next page
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => searchLocationUser()),
                        //     );
                        //   },
                        //   child: Container(
                        //     width: screenWidth * 0.55,
                        //     height: screenHeight * 0.09,
                        //     child: Align(
                        //       alignment: Alignment.center,
                        //       child: Container(
                        //         height: 35,
                        //         child: TextFormField(
                        //           enabled: false, // Disable typing here, only show the field
                        //           decoration: InputDecoration(
                        //             hintText: 'Search by location',
                        //             hintStyle: const TextStyle(color: Colors.blueGrey, fontSize: 12),
                        //             filled: true,
                        //             fillColor: Colors.white,
                        //             contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        //             border: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(5),
                        //               borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //             ),
                        //             enabledBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(5),
                        //               borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //             ),
                        //             focusedBorder: OutlineInputBorder(
                        //               borderRadius: BorderRadius.circular(5),
                        //               borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        //             ),
                        //             suffixIcon: const Icon(Icons.search, color: Colors.blue, size: 18),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        //
                        // const SizedBox(width: 3),
                        // InkWell(
                        //   child: Container(
                        //     height: 30,
                        //     width: 30,
                        //     margin: const EdgeInsets.only(right: 15),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       border: Border.all(
                        //         color: Colors.grey,
                        //         width: 1.0,
                        //       ),
                        //       borderRadius: BorderRadius.circular(5),
                        //     ),
                        //     child: const Center(
                        //       child: Icon(
                        //         Icons.notifications,
                        //         color: Colors.blue,
                        //         size: 18,
                        //       ),
                        //     ),
                        //   ),
                        //   onTap: (){
                        //     Navigator.push(context, MaterialPageRoute(builder: (context)=>userNotificationScreen()));
                        //     //   Navigator.push(context, MaterialPageRoute(builder: (context)=>const Warehouseitemdesign()));
                        //
                        //   },
                        // ),
                      ],
                    ),
                    const Spacer(),



                    // Container(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       const Text(
                    //         "498 warehouses near Noida ",
                    //         style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal, color: Colors.white),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the end
                    //         children: [
                    //           Container(
                    //             padding: EdgeInsets.zero,
                    //             height: 28,
                    //             width: 60,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(5),
                    //               color: Colors.white,
                    //               border: Border.all(
                    //                 color: Colors.grey,
                    //                 width: 1.0,
                    //               ),
                    //             ),
                    //             child: Center(
                    //               child: TextButton(
                    //                 child: const Text(
                    //                   "Sort ↑↓",
                    //                   style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Colors.blue),
                    //                 ),
                    //                 onPressed: () {
                    //                   // Handle add new button press
                    //                   showModalBottomSheet(
                    //                     context: context,
                    //                     shape: const RoundedRectangleBorder(
                    //                       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    //                     ),
                    //                     isScrollControlled: true, // Allows the modal to take full height
                    //                     builder: (BuildContext context) {
                    //                       return StatefulBuilder( // Use StatefulBuilder for managing modal state
                    //                         builder: (BuildContext context, StateSetter setModalState) {
                    //                           return FractionallySizedBox(
                    //                             heightFactor: 0.46, // Modal takes up 46% of the screen height, adjust as needed
                    //                             child: Padding(
                    //                               padding: const EdgeInsets.all(16.0),
                    //                               child: Column(
                    //                                 mainAxisAlignment: MainAxisAlignment.center,
                    //                                 crossAxisAlignment: CrossAxisAlignment.stretch,
                    //                                 children: [
                    //                                   // Sort Container, always visible
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 12),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.blue,
                    //                                       border: Border.all(color: Colors.grey),
                    //                                       borderRadius: BorderRadius.circular(10),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         const Text(
                    //                                           'Sort By',
                    //                                           style: TextStyle(fontSize: 14, color: Colors.white),
                    //                                         ),
                    //                                         IconButton(
                    //                                           icon: Icon(
                    //                                             Icons.clear,
                    //                                             color: isSortApplied ? Colors.white : Colors.grey,
                    //                                           ),
                    //                                           onPressed: isSortApplied
                    //                                               ? () {
                    //                                             setModalState(() {
                    //                                               isAreaMinToMax = false;
                    //                                               isAreaMaxToMin = false;
                    //                                               isNearbyEnabled = false;
                    //                                               isPriceEnabled = false;
                    //                                               isPriceEnabledmaxtomin = false;
                    //                                               isSortApplied = false;
                    //                                             });
                    //                                           }
                    //                                               : null,
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //
                    //                                   // Nearby Container
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.white,
                    //                                       borderRadius: BorderRadius.circular(8),
                    //                                       border: Border.all(color: Colors.grey),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         Text(
                    //                                           'Near By',
                    //                                           style: isNearbyEnabled
                    //                                               ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                    //                                               : const TextStyle(fontSize: 12, color: Colors.grey),
                    //                                         ),
                    //                                         Checkbox(
                    //                                           checkColor: Colors.white,
                    //                                           activeColor: Colors.green,
                    //                                           value: isNearbyEnabled,
                    //                                           onChanged: (bool? value) {
                    //                                             setModalState(() {
                    //                                               isNearbyEnabled = value!;
                    //                                               isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                    //                                             });
                    //                                           },
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //
                    //                                   // Price (Min to Max) Container
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.white,
                    //                                       borderRadius: BorderRadius.circular(8),
                    //                                       border: Border.all(color: Colors.grey),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         Text(
                    //                                           'Price (Min to max)',
                    //                                           style: isPriceEnabled
                    //                                               ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                    //                                               : const TextStyle(fontSize: 12, color: Colors.grey),
                    //                                         ),
                    //                                         Checkbox(
                    //                                           checkColor: Colors.white,
                    //                                           activeColor: Colors.green,
                    //                                           value: isPriceEnabled,
                    //                                           onChanged: (bool? value) {
                    //                                             setModalState(() {
                    //                                               isPriceEnabled = value!;
                    //                                               isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                    //                                             });
                    //                                           },
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //
                    //                                   // Price (Max to Min) Container
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.white,
                    //                                       borderRadius: BorderRadius.circular(8),
                    //                                       border: Border.all(color: Colors.grey),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         Text(
                    //                                           'Price (Max to min)',
                    //                                           style: isPriceEnabledmaxtomin
                    //                                               ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                    //                                               : const TextStyle(fontSize: 12, color: Colors.grey),
                    //                                         ),
                    //                                         Checkbox(
                    //                                           checkColor: Colors.white,
                    //                                           activeColor: Colors.green,
                    //                                           value: isPriceEnabledmaxtomin,
                    //                                           onChanged: (bool? value) {
                    //                                             setModalState(() {
                    //                                               isPriceEnabledmaxtomin = value!;
                    //                                               isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                    //                                             });
                    //                                           },
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //
                    //                                   // Area (Min to Max) Container
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.white,
                    //                                       borderRadius: BorderRadius.circular(8),
                    //                                       border: Border.all(color: Colors.grey),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         Text(
                    //                                           'Area (Min to max)',
                    //                                           style: isAreaMinToMax
                    //                                               ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                    //                                               : const TextStyle(fontSize: 12, color: Colors.grey),
                    //                                         ),
                    //                                         Checkbox(
                    //                                           checkColor: Colors.white,
                    //                                           activeColor: Colors.green,
                    //                                           value: isAreaMinToMax,
                    //                                           onChanged: (bool? value) {
                    //                                             setModalState(() {
                    //                                               isAreaMinToMax = value!;
                    //                                               isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                    //                                             });
                    //                                           },
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //
                    //                                   // Area (Max to Min) Container
                    //                                   Container(
                    //                                     height: screenHeight * 0.05,
                    //                                     padding: const EdgeInsets.symmetric(horizontal: 16),
                    //                                     margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    //                                     decoration: BoxDecoration(
                    //                                       color: Colors.white,
                    //                                       borderRadius: BorderRadius.circular(8),
                    //                                       border: Border.all(color: Colors.grey),
                    //                                     ),
                    //                                     child: Row(
                    //                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //                                       children: [
                    //                                         Text(
                    //                                           'Area (Max to min)',
                    //                                           style: isAreaMaxToMin
                    //                                               ? const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600)
                    //                                               : const TextStyle(fontSize: 12, color: Colors.grey),
                    //                                         ),
                    //                                         Checkbox(
                    //                                           checkColor: Colors.white,
                    //                                           activeColor: Colors.green,
                    //                                           value: isAreaMaxToMin,
                    //                                           onChanged: (bool? value) {
                    //                                             setModalState(() {
                    //                                               isAreaMaxToMin = value!;
                    //                                               isSortApplied = isNearbyEnabled || isPriceEnabled || isPriceEnabledmaxtomin || isAreaMinToMax || isAreaMaxToMin;
                    //                                             });
                    //                                           },
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ),
                    //                                 ],
                    //                               ),
                    //                             ),
                    //                           );
                    //                         },
                    //                       );
                    //                     },
                    //                   );
                    //                 },
                    //               ),
                    //             ),
                    //           ),
                    //
                    //           InkWell(
                    //             child: Container(
                    //               margin: const EdgeInsets.only(right: 18),
                    //               height: 26, // Adjusted height to align with the "Add New" button
                    //               width: 60, // Adjusted width
                    //               decoration: BoxDecoration(
                    //                 color: Colors.blue,
                    //                 border: Border.all(
                    //                   color: Colors.white,
                    //                   width: 1.0,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(5), // Rounded corners for consistency
                    //               ),
                    //               child: Center(
                    //                   child: Text("Filter",style: TextStyle(color: Colors.white),)
                    //               ),
                    //             ),
                    //             onTap: (){
                    //               showAdvancedFiltersBottomSheet(context);
                    //
                    //
                    //             },
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: screenWidth * 0.00),
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
                     // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child:InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>userHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                },
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.075,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                        border: Border.all(color: Colors.grey)
                                      ),
                                      child: Image.asset(ImageAssets.warehouseIco),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(S.of(context).warehousing,style: TextStyle(color: Colors.black,fontSize: 8),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.075,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Image.asset(ImageAssets.SemiTruck),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(S.of(context).transportation,style: TextStyle(color: Colors.black,fontSize: 7),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.075,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Image.asset(ImageAssets.group),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(S.of(context).manpower,style: TextStyle(color: Colors.black,fontSize: 8),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.075,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Image.asset(ImageAssets.Tractor),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(S.of(context).agricultural,style: TextStyle(color: Colors.black,fontSize: 8),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: screenHeight*0.075,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.blue,
                                          border: Border.all(color: Colors.grey)
                                      ),
                                      child: Image.asset(ImageAssets.threedots),
                                    ),
                                     Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(S.of(context).more,style: TextStyle(color: Colors.black,fontSize: 8),),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight*0.18, // Adjust to the height you want
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
                                      border: Border.all(color: Colors.grey, width: 3), // Blue border
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
                            ],
                          ),
                        ),
                         Text(S.of(context).seall,style: TextStyle(color: Colors.blue,fontSize: 10),),
                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight*0.18, // Adjust to the height you want
                          width: screenWidth,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _trnasportConmtroller,
                                itemCount: _images.length,
                                onPageChanged: (int index) {
                                  setState(() {
                                    _trnasportIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(0), // Margin around the image
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey, width: 3), // Blue border
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
                            ],
                          ),
                        ),
                         Text(S.of(context).seall,style: TextStyle(color: Colors.blue,fontSize: 10),),
                        SizedBox(height: screenHeight*0.025,),
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Use Flexible for the images
                                for (int i = 0; i < 3; i++)
                                  if (horizontalSliderImagesIndex + i < horizontalSliderImages.length)
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0), // Adjust horizontal padding
                                        child: AspectRatio(
                                          aspectRatio: 1, // Maintain equal width and height
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey,width: 1),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Image.asset(
                                              horizontalSliderImages[horizontalSliderImagesIndex + i],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                // Arrow button to shift images to the left
                                Container(
                                  width: screenWidth*0.1,
                                  child: Center(
                                    child: IconButton(
                                      icon: const Icon(Icons.arrow_circle_right_outlined, size: 20),
                                      onPressed: _shiftImagesLeft,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight*0.18, // Adjust to the height you want
                          width: screenWidth,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _manpowerController,
                                itemCount: _images.length,
                                onPageChanged: (int index) {
                                  setState(() {
                                    _manpowertIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(0), // Margin around the image
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey, width: 3), // Blue border
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
                            ],
                          ),
                        ),
                         Text(S.of(context).seall,style: TextStyle(color: Colors.blue,fontSize: 10),),
                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight*0.18, // Adjust to the height you want
                          width: screenWidth,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _agricultureController,
                                itemCount: _images.length,
                                onPageChanged: (int index) {
                                  setState(() {
                                    _agricultureIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(0), // Margin around the image
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey, width: 3), // Blue border
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
                            ],
                          ),
                        ),
                         Text(S.of(context).seall,style: TextStyle(color: Colors.blue,fontSize: 10),),
                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight*0.18, // Adjust to the height you want
                          width: screenWidth,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: sliderController,
                                itemCount: _images.length,
                                onPageChanged: (int index) {
                                  setState(() {
                                    sliderControllerIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.all(0), // Margin around the image
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey, width: 3), // Blue border
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
                            ],
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
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Rounded top border
      ),
      child: Column(
        children: [
          Container(
            height: 35,
            margin: EdgeInsets.symmetric(horizontal: screenWidth*0.15,vertical: 8),
            decoration: BoxDecoration(color: Colors.blue,borderRadius: BorderRadius.circular(8),border: Border.all(color: Colors.grey)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("Advanced Filters",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
                ),
                IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.clear,color: Colors.white,size: 20,))
              ],
            ),
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
                        margin: const EdgeInsets.all(5),
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
                          margin: const EdgeInsets.all(8),
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
                                    selectedOptions[option] = value!;
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
                      const Spacer(),
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
// CustomPainter to animate the light/glitter effect along the button border
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
