import 'dart:async';
import 'package:Lisofy/Animation/glitter_border.dart';
import 'package:Lisofy/Warehouse/User/partner_chooser_screen.dart';
import 'package:Lisofy/Warehouse/User/user_home_page.dart';
import 'package:Lisofy/Warehouse/User/user_profile_screen.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:Lisofy/resources/ImageAssets/ImagesAssets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class NewHomePage extends StatefulWidget {
  final dynamic longitude;
  final dynamic latitude;
  const NewHomePage({super.key,required this.latitude,required this.longitude});

  @override
  State<NewHomePage> createState() => NewHomePageState();
}

class NewHomePageState extends State<NewHomePage>with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }
  int _currentIndex = 0;
  int _transportIndex = 0;
  int _manpowerIndex = 0;
  int _agricultureIndex = 0;
  int sliderControllerIndex = 0;
  final List<String> _warehouseImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_6.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_5.jpg'
    ];
  final List<String> _transportImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_7.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_8.jpg'
  ];
  final List<String> _manPowerImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_13.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_14.jpg'
  ];
  final List<String> _advertisingImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_18.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_19.jpg'
  ];
  final List<String> _agriculturalImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_23.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_20.jpg'
  ];

  late PageController _pageControllerSlider;
  late PageController _transportController;
  late PageController _manpowerController;
  late PageController _agricultureController;
  late PageController _advertisingController;
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

    _pageControllerSlider = PageController(initialPage: _currentIndex);
    _transportController = PageController(initialPage: _transportIndex);
    _manpowerController = PageController(initialPage: _manpowerIndex);
    _agricultureController = PageController(initialPage: _agricultureIndex);
    _advertisingController = PageController(initialPage: sliderControllerIndex);
    _startAutoSlide(_pageControllerSlider, () {
      if (_currentIndex < _warehouseImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
    }, 3, const Duration(milliseconds: 3000), Curves.easeInOutCubicEmphasized);

    _startAutoSlide(_transportController, () {
      if (_transportIndex < _transportImages.length - 1) {
        _transportIndex++;
      } else {
        _transportIndex = 0;
      }
    }, 4, const Duration(milliseconds: 200), Curves.slowMiddle);

    _startAutoSlide(_manpowerController, () {
      if (_manpowerIndex < _manPowerImages.length - 1) {
        _manpowerIndex++;
      } else {
        _manpowerIndex = 0;
      }
    }, 5, const Duration(milliseconds: 400), Curves.slowMiddle);

    _startAutoSlide(_agricultureController, () {
      if (_agricultureIndex < _agriculturalImages.length - 1) {
        _agricultureIndex++;
      } else {
        _agricultureIndex = 0;
      }
    }, 4, const Duration(milliseconds: 3000), Curves.easeInOutCubicEmphasized);

    _startAutoSlide(_advertisingController, () {
      if (sliderControllerIndex < _advertisingImages.length - 1) {
        sliderControllerIndex++;
      } else {
        sliderControllerIndex = 0;
      }
    }, 3, const Duration(milliseconds: 2000), Curves.easeOut);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  void _startAutoSlide(
      PageController controller,
      VoidCallback onNext,
      int seconds,
      Duration duration,
      Curve curve,
      ) {
    Timer.periodic(Duration(seconds: seconds), (Timer timer) {
      if (!controller.hasClients) {
        timer.cancel();
        return;
      }
      onNext();
      controller.animateToPage(
        _currentIndex,
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
    _transportController.dispose();
    _manpowerController.dispose();
    _agricultureController.dispose();
    _advertisingController.dispose();
    super.dispose();
  }
  List<String> horizontalSliderImages = [
    'https://xpacesphere.com/Content/NewFolder/warehouse_10.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_11.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_12.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_16.jpg',
    'https://xpacesphere.com/Content/NewFolder/warehouse_17.jpg',
  ];
  int horizontalSliderImagesIndex = 0;
  void _shiftImagesLeft() {
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
    return PopScope(
        canPop: false,
        child: Scaffold(
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
                height: screenHeight*0.05,
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
        ));
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
              height: screenHeight * 0.1,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.015,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.all(screenWidth*0.03),
                      child: Image.asset(ImageAssets.appLogo),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: screenWidth*0.04,top: screenHeight*0.02),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  painter: GlitterBorderPainter(_animation.value),
                                  child: SizedBox(
                                    width: screenWidth*0.32,
                                    height: screenHeight*0.037,
                                    child: TextButton(
                                      onPressed: () async{
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const PartnerChooserScreen()));
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: const BorderSide(color: Colors.grey, width: 1),
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
                                        ).animate(delay: 500.ms,
                                          onPlay: (controller) => controller.repeat(),)
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
                    //
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: screenWidth * 0.00),
                decoration:  BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0),
                    topRight: Radius.circular(screenWidth*0.15),
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
                                padding:  EdgeInsets.all(screenWidth*0.03),
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(screenWidth*0.05),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withValues(alpha: 0.3),
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
                                          height: screenHeight*0.08,
                                          width: screenWidth*0.25,
                                          fit: BoxFit.contain,
                                        ),
                                         Text(
                                          S.of(context).warehousing,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding:  EdgeInsets.all(screenWidth*0.03),
                                child: Container(
                                  height: screenHeight*0.15,
                                  width: screenWidth*0.33,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(screenWidth*0.05),
                                    color: Colors.lightBlue.shade50,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(alpha: 0.6),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: (){
                                      Fluttertoast.showToast(
                                        msg: "Coming soon!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        backgroundColor: Colors.green,
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          ImageAssets.transportgif,
                                          height: screenHeight*0.08,
                                          width: screenWidth*0.25,
                                          fit: BoxFit.contain,
                                        ),
                                         Text(
                                          S.of(context).transportation,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                         SizedBox(height: screenHeight*0.005),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: Padding(
                                padding:  EdgeInsets.all(screenWidth*0.03),
                                child: InkWell(
                                  onTap: (){
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(screenWidth*0.05),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withValues(alpha: 0.3),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        Fluttertoast.showToast(
                                          msg: "Coming soon!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImageAssets.manpowergif,
                                            height: screenHeight*0.08,
                                            width: screenWidth*0.25,
                                            fit: BoxFit.contain,
                                          ),
                                           Text(
                                            S.of(context).manpower,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding:  EdgeInsets.all(screenWidth*0.03),
                                child: InkWell(
                                  onTap: (){
                                  },
                                  child: Container(
                                    height: screenHeight*0.15,
                                    width: screenWidth*0.33,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(screenWidth*0.05),
                                      color: Colors.lightBlue.shade50,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.withValues(alpha: 0.3),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        Fluttertoast.showToast(
                                          msg: "Coming soon!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ImageAssets.agriculturalgif,
                                            height: screenHeight*0.08,
                                            width: screenWidth*0.25,
                                            fit: BoxFit.contain,
                                          ),
                                           Text(
                                            S.of(context).agricultural,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight*0.025,),
                        ///Warehouse Slider
                        SizedBox(
                          height: screenHeight * 0.18,
                          width: screenWidth*0.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>UserHomePage(longitude:widget.longitude,latitude:widget.latitude)));
                                  },
                                child: PageView.builder(
                                  controller: _pageControllerSlider,
                                  itemCount: _warehouseImages.length,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey, width: 3),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: _warehouseImages[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) => Shimmer(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.red.shade200, width: 2),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 40,
                                              ),
                                              Text(
                                                'Image failed to load!',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.017,),
                        ///Transportation Slider
                         SizedBox(
                           height: screenHeight*0.18,
                           width: screenWidth*0.9,
                           child: Stack(
                             children: [
                               InkWell(
                                 onTap:(){
                                   Fluttertoast.showToast(
                                     msg: "Coming soon!",
                                     toastLength: Toast.LENGTH_SHORT,
                                     gravity: ToastGravity.BOTTOM,
                                     backgroundColor: Colors.green,
                                   );
                         },
                                 child: PageView.builder(
                                   controller: _transportController,
                                   itemCount: _transportImages.length,
                                   onPageChanged: (int index) {
                                     setState(() {
                                       _transportIndex = index;
                                     });
                                   },
                                   itemBuilder: (context, index) {
                                     return Container(
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.circular(6),
                                         border: Border.all(color: Colors.grey, width: 3),
                                       ),
                                       child: CachedNetworkImage(
                                         imageUrl: _transportImages[index],
                                         fit: BoxFit.cover,
                                         width: double.infinity,
                                         placeholder: (context, url) => Shimmer(
                                           child: Container(
                                             width: double.infinity,
                                             height: screenHeight*0.05,
                                             decoration: BoxDecoration(
                                               color: Colors.grey,
                                               borderRadius: BorderRadius.circular(3),
                                             ),
                                           ),
                                         ),
                                         errorWidget: (context, url, error) => Container(
                                           alignment: Alignment.center,
                                           padding: const EdgeInsets.all(10),
                                           decoration: BoxDecoration(
                                             color: Colors.red.shade100,
                                             borderRadius: BorderRadius.circular(3),
                                             border: Border.all(color: Colors.red.shade200, width: 2),
                                           ),
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             children: [
                                               Icon(
                                                 Icons.error_outline,
                                                 color: Colors.red.shade700,
                                                 size: 40,
                                               ),
                                               Text(
                                                 'Image failed to load!',
                                                 style: TextStyle(
                                                   fontSize: 16,
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.red.shade700,
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     );
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                        SizedBox(height: screenHeight*0.02,),
                        ///Horizontal Slider
                        Padding(
                          padding:  EdgeInsets.only(right: screenWidth*0.003),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for (int i = 0; i < 3; i++)
                                  if (horizontalSliderImagesIndex + i < horizontalSliderImages.length)
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey,width: 1),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Shimmer(
                                          child: CachedNetworkImage(
                                            imageUrl: horizontalSliderImages[horizontalSliderImagesIndex + i],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              color: Colors.grey.shade300,
                                            ),
                                            errorWidget: (context, url, error) => Container(
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.red.shade100,
                                                borderRadius: BorderRadius.circular(3),
                                                border: Border.all(color: Colors.red.shade200, width: 2),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.error_outline,
                                                    color: Colors.red.shade700,
                                                    size: 40,
                                                  ),
                                                  Text(
                                                    'Image failed to load!',
                                                    style: TextStyle(
                                                      fontSize: 6,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.red.shade300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                          ),
                                        ),
                                      ),
                                    ),
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
                        SizedBox(height: screenHeight*0.02,),
                        ///Manpower Slider
                        SizedBox(
                          height: screenHeight*0.18,
                          width: screenWidth*0.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                    Fluttertoast.showToast(
                                      msg: "Coming soon!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                    );
                                },
                                child: PageView.builder(
                                  controller: _manpowerController,
                                  itemCount: _manPowerImages.length,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      _manpowerIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey, width: 3),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: _manPowerImages[index],
                                        fit: BoxFit.fitWidth,
                                        width: double.infinity,
                                        placeholder: (context, url) => Shimmer(
                                          child: Container(
                                            width: double.infinity,
                                            height: screenHeight*0.05,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.red.shade200, width: 2),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 40,
                                              ),
                                              Text(
                                                'Image failed to load!',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        ///Agriculture Slider
                        SizedBox(
                          height: screenHeight*0.18,
                          width: screenWidth*0.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                    Fluttertoast.showToast(
                                      msg: "Coming soon!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                    );
                                },
                                child: PageView.builder(
                                  controller: _agricultureController,
                                  itemCount: _agriculturalImages.length,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      _agricultureIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey, width: 3),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: _agriculturalImages[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) => Shimmer(
                                          child: Container(
                                            width: double.infinity,
                                            height: screenHeight*0.07,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.red.shade200, width: 2),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 40,
                                              ),
                                              Text(
                                                'Image failed to load!',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.02,),
                        ///Advertising Slider
                        SizedBox(
                          height: screenHeight*0.18,
                          width: screenWidth*0.9,
                          child: Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                    Fluttertoast.showToast(
                                      msg: "Coming soon!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      backgroundColor: Colors.green,
                                    );
                                },
                                child: PageView.builder(
                                  controller: _advertisingController,
                                  itemCount: _advertisingImages.length,
                                  onPageChanged: (int index) {
                                    setState(() {
                                      sliderControllerIndex = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey, width: 3),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: _advertisingImages[index],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        placeholder: (context, url) => Shimmer(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(color: Colors.red.shade200, width: 2),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.error_outline,
                                                color: Colors.red.shade700,
                                                size: 40,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Image failed to load!',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red.shade700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
  Widget _buildAccountPage(double screenWidth, double screenHeight) {
    return const UserProfileScreen();
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



