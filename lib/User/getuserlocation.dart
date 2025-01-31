import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/User/userHelpPage.dart';
import 'package:warehouse/new_home_page.dart';
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
    setState(() {
      loading = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      setState(() {
        loading = false;
      });

      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        setState(() {
          loading = false;
        });
        return;
      }
    }

    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        loading = false;
        _coordinates =
        'Latitude: ${position?.latitude}, Longitude: ${position?.longitude}';
      });

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setDouble('latitude', position!.latitude);
      await pref.setDouble('longitude', position!.longitude);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => NewHomePage(
                longitude: position?.longitude,
                latitude: position?.latitude,
              )));
    } catch (e) {
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
          ? const Center(child: SpinKitCircle(color: Colors.blue,))
          : buildLocationUI(screenHeight, screenWidth),
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
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
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
                              borderRadius:
                              BorderRadius.circular(5),
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
                                        userHelpPage()));
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: screenHeight * 0.07, left: 5),
                      child: const Row(
                        mainAxisAlignment:
                        MainAxisAlignment.start,
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
                margin:
                EdgeInsets.only(right: screenWidth * 0.005),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 15),
                          child: SizedBox(
                            height: screenHeight * 0.05,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Search Near Me ',
                                suffixStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black),
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
                                        BorderRadius.circular(
                                            18),
                                        color: Colors.lightBlue,
                                      ),
                                      child: const ImageIcon(
                                        AssetImage(
                                          "assets/images/Location.png",
                                        ),
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
                        SizedBox(height: screenHeight * 0.03),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0),
                              width: 100.0,
                              height: 2,
                              color: Colors.blue,
                            ),
                            SizedBox(width: screenHeight * 0.02),
                            const Text(
                              "or",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: screenHeight * 0.02),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0),
                              width: 100.0,
                              height: 2,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.08),
                        Row(
                          children: [
                            SizedBox(width: screenWidth * 0.1),
                            const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Enter Location Manually",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight:
                                      FontWeight.w600),
                                )),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.001),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 15),
                            child: SizedBox(
                              height: screenHeight * 0.05,
                              child: TextField(
                                decoration: InputDecoration(
                                  labelText:
                                  'E.g. Indirapuram, Bengaluru, India',
                                  labelStyle: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          18)),
                                  suffixIcon: InkWell(
                                    child: Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey),
                                        borderRadius:
                                        BorderRadius.circular(
                                            18),
                                        color: Colors.lightBlue,
                                      ),
                                      child: const ImageIcon(
                                        AssetImage(
                                          "assets/images/Location.png",
                                        ),
                                        color: Colors.white,
                                      ),
                                    ),
                                    onTap: () {
                                      // Manually enter location logic
                                    },
                                  ),
                                ),
                              ),
                            )),
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
    )
    )
    ]
    );
  }
}









// class DottedBorder extends StatelessWidget {
//   final Widget child;
//
//   const DottedBorder({super.key, required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: DottedBorderPainter(),
//       child: child,
//     );
//   }
// }

// class DottedBorderPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2.0;
//
//     const double dashWidth = 4.0;
//     const double dashSpace = 4.0;
//     double startX = 0;
//
//     final path = Path()
//       ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
//
//     // Draw dotted border
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(startX, 0),
//         Offset(startX + dashWidth, 0),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//
//     startX = 0; // Reset startX for the next side
//     while (startX < size.height) {
//       canvas.drawLine(
//         Offset(size.width, startX),
//         Offset(size.width, startX + dashWidth),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//
//     startX = 0; // Reset startX for the next side
//     while (startX < size.width) {
//       canvas.drawLine(
//         Offset(size.width - startX, size.height),
//         Offset(size.width - startX - dashWidth, size.height),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//
//     startX = 0; // Reset startX for the next side
//     while (startX < size.height) {
//       canvas.drawLine(
//         Offset(0, size.height - startX),
//         Offset(0, size.height - startX - dashWidth),
//         paint,
//       );
//       startX += dashWidth + dashSpace;
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }





// class CarpetAreaTextFormField extends StatelessWidget {
//   const CarpetAreaTextFormField({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: 'Enter carpet area',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|sqft',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField2 extends StatelessWidget {
//   const CarpetAreaTextFormField2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 33,
//       decoration: BoxDecoration(
//           color: Colors.grey.shade200,
//           borderRadius: BorderRadius.circular(6)
//       ),
//
//       child: TextFormField(
//
//         decoration: InputDecoration(
//           hintText: '0',
//           hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//           contentPadding: const EdgeInsets.only(left: 8,bottom: 10), // Adjust vertical padding
//           border: InputBorder.none,
//
//
//           suffix: Container(
//             padding: const EdgeInsets.only(left: 8.0,right: 6), // Space between the text and the input
//             child: const Text(
//               '|sqft',
//               style: TextStyle(color: Colors.grey, fontSize: 13),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField3 extends StatelessWidget {
//   const CarpetAreaTextFormField3({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: '₹|ex.35',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|per month',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField4 extends StatelessWidget {
//   const CarpetAreaTextFormField4({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: '₹|ex.2',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|per month',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField5 extends StatelessWidget {
//   const CarpetAreaTextFormField5({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: const InputDecoration(
//         hintText: 'ex.2',
//         hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         // suffix: Container(
//         //   padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
//         //   child: Text(
//         //     '|per month',
//         //     style: TextStyle(color: Colors.grey, fontSize: 13),
//         //   ),
//         // ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField6 extends StatelessWidget {
//   const CarpetAreaTextFormField6({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: 'ex.3',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|per month',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField7 extends StatelessWidget {
//   const CarpetAreaTextFormField7({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: 'ex.18',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|per month',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }
// class CarpetAreaTextFormField8 extends StatelessWidget {
//   const CarpetAreaTextFormField8({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(
//         hintText: 'ex.18',
//         hintStyle: const TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
//         // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
//         border: InputBorder.none,
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(color: Colors.blue, width: 1.0),
//         ),
//         suffix: Container(
//           padding: const EdgeInsets.only(left: 8.0), // Space between the text and the input
//           child: const Text(
//             '|per month',
//             style: TextStyle(color: Colors.grey, fontSize: 13),
//           ),
//         ),
//       ),
//     );
//   }
// }








