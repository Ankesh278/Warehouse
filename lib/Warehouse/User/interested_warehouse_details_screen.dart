import 'dart:async';
import 'dart:math';
import 'package:Lisofy/Warehouse/User/UserProvider/InterestProvider.dart';
import 'package:Lisofy/Warehouse/User/warehouse_details.dart';
import 'package:Lisofy/distance_calculator.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:Lisofy/resources/ImageAssets/ImagesAssets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class InterestedWarehouseDetailsScreen extends StatefulWidget {
  final  warehouses;

  const InterestedWarehouseDetailsScreen({super.key, required this.warehouses});
  @override
  State<InterestedWarehouseDetailsScreen> createState() => _InterestedWarehouseDetailsScreenState();
}
class _InterestedWarehouseDetailsScreenState extends State<InterestedWarehouseDetailsScreen> {
  late PageController _pageControllerSlider;
  DistanceCalculator distanceCalculator=DistanceCalculator();
  late Timer _timer;
  int _currentIndex = 0;
  bool isLoading=false;
  bool _isExpanded = false;
  final List<String> _uploadedImages = [];
  final List<String> _defaultImages = [
    'assets/images/slider3.jpg',
    'assets/images/slider2.jpg',
  ];
  @override
  void initState() {
    super.initState();
    String filePath = widget.warehouses.filePath;
    processMediaFilePath(filePath);
    _pageControllerSlider = PageController(initialPage: _currentIndex);
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _uploadedImages.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageControllerSlider.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
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
    if (_uploadedImages.isEmpty) {
      setState(() {
        _uploadedImages.addAll(_defaultImages);
      });
    }
  }
  @override
  void dispose() {
    _timer.cancel();
    _pageControllerSlider.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context);
    final isShortlisted = cartProvider.isShortlisted(widget.warehouses.id);
    final List<Map<String, dynamic>> gridItems = [
      if (widget.warehouses.officeSpace)
        {
          'icon': ImageAssets.officeSpace,
          'label': 'Office Space',
        },
      if (widget.warehouses.dockLevelers)
        {
          'icon': ImageAssets.dockleveler,
          'label': 'Dock Levelers',
        },
      if (widget.warehouses.fireComplaints)
        {
          'icon': ImageAssets.fireNoc,
          'label': 'Fire NOC',
        },
      if (widget.warehouses.powerBackup)
        {
          'icon': ImageAssets.powerBackup,
          'label': 'Power Backup',
        },
      if (widget.warehouses.flexingModel)
        {
          'icon': ImageAssets.flexiModel,
          'label': 'Flexi Model',
        },
    ];
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
                                SizedBox(width: screenWidth*0.02,
                                  height: screenHeight*0.04,),
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
                                    cartProvider.toggleWarehouse(widget.warehouses.id, widget.warehouses.mobile,context);
                                  },
                                  child: Container(
                                      height: screenHeight*0.04,
                                      width: screenWidth*0.1,
                                      margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.04),
                                      child: isShortlisted?const Icon(Icons.favorite_outlined,color: Colors.red,):const Icon(Icons.favorite_border,color: Colors.white,)
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                      height: screenHeight*0.04,
                                      width: screenWidth*0.1,
                                      margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.04),
                                      decoration: const BoxDecoration(
                                          color: Colors.blue
                                      ),
                                      child: Image.asset("assets/images/Shareicon.png")
                                  ),
                                ),
                                Container(
                                  height: screenHeight*0.04,
                                  width: screenWidth*0.1,
                                  margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.1),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white
                                  ),
                                  child: const Center(child: Icon(Icons.file_download_outlined,color: Colors.blue,size: 16,)),
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
                                                  child: CachedNetworkImage(
                                                    imageUrl: Uri.encodeFull('$baseUrl${_uploadedImages[index]}'),
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: screenHeight*0.5,
                                                    placeholder: (context, url) => Shimmer.fromColors(
                                                      baseColor: Colors.grey.shade300,
                                                      highlightColor: Colors.grey.shade100,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: screenHeight*0.5,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    errorWidget: (context, url, error) => Container(
                                                      alignment: Alignment.center,
                                                      width: double.infinity,
                                                      height: screenHeight*0.5,
                                                      decoration: BoxDecoration(
                                                        color: Colors.red.shade100,
                                                        borderRadius: BorderRadius.circular(20),
                                                        border: Border.all(color: Colors.red.shade200, width: 2),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.broken_image_rounded, color: Colors.red.shade700, size: 50),
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
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10), // Space between slider and dots
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(_uploadedImages.length, (index) {
                                            return Container(
                                              margin: const EdgeInsets.symmetric(horizontal: 5), // Space between dots
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
                                            child: Text("₹ ${widget.warehouses.wHouseRentPerSQFT} ",
                                              style: const TextStyle(fontWeight: FontWeight.w700,color: Colors.black),
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ),
                                         Text(S.of(context).rent_per_sqft,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                                        const Spacer(),
                                        Container(
                                          height: screenHeight*0.05,
                                          width: screenWidth*0.13,
                                          decoration: const BoxDecoration(
                                              color: Colors.blue
                                          ),
                                          child: const Icon(Icons.help_center_outlined,color: Colors.white,),
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
                                                constraints: const BoxConstraints(maxWidth: 40),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    widget.warehouses.warehouseCarpetArea.toString(),
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(S.of(context).available_area,style: const TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            const SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 40),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    widget.warehouses.securityDeposit.toString(),
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(S.of(context).security_deposit,style: const TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
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
                                                constraints: const BoxConstraints(maxWidth: 50),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    widget.warehouses.wHouseType,
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              ),
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(S.of(context).warehouse_type,style: const TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            const SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Container(
                                                constraints: const BoxConstraints(maxWidth: 40),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    widget.warehouses.wHouseConstructionType,
                                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,color: Colors.black),
                                                    textAlign: TextAlign.start,
                                                  ),
                                                )),
                                            ),
                                             Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text(S.of(context).flooring_type,style: const TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 13,),
                                   Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 15.0),
                                      child: Text(S.of(context).address,style: const TextStyle(
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
                                          padding: const EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                constraints: const BoxConstraints(maxWidth: 150),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: FutureBuilder<String>(
                                                    future: distanceCalculator.getAddressFromLatLng(widget.warehouses.wHouseAddress), // Replace with actual coordinates
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return const Text("Loading address...", style: TextStyle(color: Colors.grey, fontSize: 12));
                                                      } else if (snapshot.hasError) {
                                                        return Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red, fontSize: 12));
                                                      } else {
                                                        return Text(snapshot.data!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14));
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                constraints: BoxConstraints(maxWidth: screenWidth*0.5),
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: FutureBuilder<double>(
                                                    future: distanceCalculator.getDistanceFromCurrentToWarehouse(widget.warehouses.wHouseAddress), // Replace with actual data
                                                    builder: (context, snapshot) {
                                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                                        return const Text("Calculating distance...", style: TextStyle(color: Colors.grey, fontSize: 12));
                                                      } else if (snapshot.hasError) {
                                                        return Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.red, fontSize: 12));
                                                      } else {
                                                        double distanceInKm = snapshot.data! / 1000;
                                                        return Text("${distanceInKm.toStringAsFixed(3)} km away from your current location",
                                                            style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 15));
                                                      }
                                                    },
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
                                              if (widget.warehouses.latitude != null && widget.warehouses.longitude != null) {
                                                _openMap(widget.warehouses.latitude!, widget.warehouses.longitude!);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Location information is missing.")),
                                                );
                                              }
                                            },
                                            child: ClipOval(
                                              child: Image.asset(
                                                ImageAssets.map,
                                                height: screenHeight*0.06,
                                                width: screenWidth*0.13,
                                                fit: BoxFit.cover,
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                       Text(
                                         S.of(context).amenities,
                                         style: const TextStyle(
                                           fontSize: 16,
                                           fontWeight: FontWeight.w800,
                                         ),
                                       ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _isExpanded = !_isExpanded;
                                          });
                                        },
                                        child: Text(
                                          _isExpanded ? S.of(context).view_less : S.of(context).view_more,
                                          style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w800,color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      WarehouseFeaturesRow(
                                        features: [
                                          {"icon": ImageAssets.electricity, "value": "${widget.warehouses.electricity} KWA"},
                                          {"icon": ImageAssets.toilets, "value": "Toilets | ${widget.warehouses.numberOfToilets}"},
                                          {"icon": ImageAssets.truckSlot, "value": "Truck Slot | ${widget.warehouses.truckParkingSlot}"},
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      WarehouseFeaturesRow(
                                        features: [
                                          {"icon": ImageAssets.fansNumber, "value": "Fans | ${widget.warehouses.numberOfFans}"},
                                          {"icon": ImageAssets.lightbulb, "value": "Lights | ${widget.warehouses.numberOfLights}"},
                                          {"icon": ImageAssets.bikeSlot, "value": "Bike Slot | ${widget.warehouses.bikeParkingSlot}"},
                                        ],
                                      ),
                                    ],
                                  ),
                                  AnimatedCrossFade(
                                    firstChild: const SizedBox.shrink(),
                                    secondChild: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: screenHeight*0.04),
                                        Wrap(
                                          spacing: screenWidth*0.1,
                                          runSpacing: screenWidth*0.10,
                                          children: gridItems.map((item) {
                                            return SizedBox(
                                              width: MediaQuery.of(context).size.width / 3.5 - 30,
                                              child: Column(
                                                children: [
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.all(15),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors.blue,
                                                          width: 2),
                                                      color:
                                                      const Color(0xffCCDCF9),
                                                    ),
                                                    child:
                                                    Image.asset(item['icon']),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    item['label'],
                                                    style: const TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: screenHeight*0.005),
                                      ],
                                    ),
                                    crossFadeState: _isExpanded
                                        ? CrossFadeState.showSecond
                                        : CrossFadeState.showFirst,
                                    duration: const Duration(milliseconds: 300),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.05,
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
                                        child:  Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            const Icon(Icons.calendar_today_outlined,color: Colors.blue,size: 16,),
                                            const SizedBox(width: 4,),
                                            Text(S.of(context).schedule_a_visit,style: const TextStyle(color: Colors.blue,fontSize: 10),)
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          height: screenHeight*0.0415,
                                          width: screenWidth*0.34,
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade100,
                                              border: Border.all(color: Colors.blue.shade100),
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(width: 10,),
                                              Text("Already Interested",style: TextStyle(color: Colors.white,fontSize: 10),),
                                              Spacer(),
                                              Icon(Icons.arrow_forward_ios_outlined,color: Colors.white,size: 16,),
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                         // Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpressInterestScreen(id:widget.warehouses.id)));
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
    final random = Random();

    // Generate random offsets (±1 to 2 km)
    double latOffset = (random.nextDouble() * 0.018) - 0.009; // ±1 to 2 km in latitude
    double lngOffset = (random.nextDouble() * 0.018) - 0.009; // ±1 to 2 km in longitude

    // Adjust the coordinates
    double newLat = lat + latOffset;
    double newLng = lng + lngOffset;
    final url = "https://www.google.com/maps/search/?api=1&query=$newLat,$newLng";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CarpetAreaTextFormField extends StatelessWidget {
  const CarpetAreaTextFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Enter carpet area',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: const Text(
            '|sqft',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField2 extends StatelessWidget {
  const CarpetAreaTextFormField2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6)
      ),

      child: TextFormField(

        decoration: InputDecoration(
          hintText: '0',
          hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
          contentPadding: const EdgeInsets.only(left: 8,bottom: 10),
          border: InputBorder.none,


          suffix: Container(
            padding: const EdgeInsets.only(left: 8.0,right: 6),
            child: const Text(
              '|sqft',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField3 extends StatelessWidget {
  const CarpetAreaTextFormField3({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: '₹|ex.35',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField4 extends StatelessWidget {
  const CarpetAreaTextFormField4({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: '₹|ex.2',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField5 extends StatelessWidget {
  const CarpetAreaTextFormField5({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'ex.2',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField6 extends StatelessWidget {
  const CarpetAreaTextFormField6({super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.3',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField7 extends StatelessWidget {
  const CarpetAreaTextFormField7({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.18',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField8 extends StatelessWidget {
  const CarpetAreaTextFormField8({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.18',
        hintStyle: const TextStyle(color: Colors.grey,fontSize: 12),
        border: InputBorder.none,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: const EdgeInsets.only(left: 8.0),
          child: const Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}








