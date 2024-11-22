import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Localization/Languages.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/User/PartnerChooserScreen.dart';
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
    }, 3, const Duration(milliseconds: 3000), Curves.easeInOutCubicEmphasized);

    // Auto-slide for transport
    _startAutoSlide(_trnasportConmtroller, () {
      if (_trnasportIndex < _images.length - 1) {
        _trnasportIndex++;
      } else {
        _trnasportIndex = 0;
      }
    }, 4, const Duration(milliseconds: 200), Curves.slowMiddle);

    // Auto-slide for manpower
    _startAutoSlide(_manpowerController, () {
      if (_manpowertIndex < _images.length - 1) {
        _manpowertIndex++;
      } else {
        _manpowertIndex = 0;
      }
    }, 5, const Duration(milliseconds: 400), Curves.slowMiddle);

    // Auto-slide for agriculture
    _startAutoSlide(_agricultureController, () {
      if (_agricultureIndex < _images.length - 1) {
        _agricultureIndex++;
      } else {
        _agricultureIndex = 0;
      }
    }, 4, const Duration(milliseconds: 3000), Curves.easeInOutCubicEmphasized);

    // Auto-slide for slider controller
    _startAutoSlide(sliderController, () {
      if (sliderControllerIndex < _images.length - 1) {
        sliderControllerIndex++;
      } else {
        sliderControllerIndex = 0;
      }
    }, 3, const Duration(milliseconds: 2000), Curves.easeOut);

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
              height: screenHeight * 0.125,
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
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>PartnerChooserScreen()));
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
                      ],
                    ),

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>userHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.warehousegif,
                                          height: 60, // Smaller icon
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 0),
                                         Text(
                                          S.of(context).warehousing,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: screenHeight*0.15,
                                  width: screenWidth*0.33,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.lightBlue.shade50,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(0.3),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        ImageAssets.transportgif,
                                        height: 60,
                                        width: 100,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 5),
                                       Text(
                                        S.of(context).transportation,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Spacing between rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>userHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.manpowergif,
                                          height: 60,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 5),
                                         Text(
                                          S.of(context).manpower,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: (){
                                   // Navigator.push(context, MaterialPageRoute(builder: (context)=>userHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withOpacity(0.3),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.agriculturalgif,
                                          height: 60,
                                          width: 100,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(height: 5),
                                         Text(
                                          S.of(context).agricultural,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),



                        SizedBox(height: screenHeight*0.025,),
                        SizedBox(
                          height: screenHeight * 0.18, // Adjust to the height you want
                          width: screenWidth,
                          child: Stack(
                            children: [
                              PageView.builder(
                                controller: _pageControllerSlider, // Make sure the controller is set
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
                         Text(S.of(context).seall,style: const TextStyle(color: Colors.blue,fontSize: 10),),
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
                         Text(S.of(context).seall,style: const TextStyle(color: Colors.blue,fontSize: 10),),
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
                                SizedBox(
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
                         Text(S.of(context).seall,style: const TextStyle(color: Colors.blue,fontSize: 10),),
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
                         Text(S.of(context).seall,style: const TextStyle(color: Colors.blue,fontSize: 10),),
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
