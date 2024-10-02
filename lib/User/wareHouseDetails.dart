import 'dart:async';
import 'package:flutter/material.dart';
import 'package:warehouse/User/ExpressInterestScreen.dart';


class wareHouseDetails extends StatefulWidget {
  @override
  State<wareHouseDetails> createState() => _wareHouseDetailsState();
}

class _wareHouseDetailsState extends State<wareHouseDetails> {

  final List<String> _images = [
    'assets/images/slider3.jpg', // First Image URL
    'assets/images/slider2.jpg',
    'assets/images/slider1.png',// Second Image URL
  ];

   late PageController _pageControllerSlider;
  late Timer _timer;
  int _currentIndex = 0;
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
                                SizedBox(width: 7,height: 30,),
                                InkWell(child: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.white,size: 18,),
                                  onTap: (){
                                  Navigator.pop(context);
                                  },

                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 30,
                                  width: 25,
                                  margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.04),
                                  decoration: BoxDecoration(
                                      color: Colors.blue
                                  ),
                                  child: Image.asset("assets/images/Shareicon.png")
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  margin: EdgeInsets.only(top: screenHeight*0.05,right: screenWidth*0.1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white
                                  ),
                                 
                                  child: Center(child: Icon(Icons.file_download_outlined,color: Colors.blue,size: 16,)),
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
                        decoration: BoxDecoration(
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
                                  Container(
                                    height: screenHeight * 0.28, // Adjust to give some space for dots below the slider
                                    width: screenWidth,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: screenHeight * 0.25, // Height for the PageView slider
                                          width: screenWidth,
                                          child: PageView.builder(
                                            controller: _pageControllerSlider,
                                            itemCount: _images.length,
                                            onPageChanged: (int index) {
                                              setState(() {
                                                _currentIndex = index;
                                              });
                                            },
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.all(0), // No margin around the image
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(20), // Circular border radius
                                                  border: Border.all(color: Colors.white, width: 0), // Optional border color
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(20), // Apply the same border radius here
                                                  child: Image.asset(
                                                    _images[index],
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    height: 250,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 10), // Space between slider and dots
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: List.generate(_images.length, (index) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(horizontal: 5), // Space between dots
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 500),
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
                                  SizedBox(height: 10,),
                                  Container(
                                    height: screenHeight*0.05,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 8,),
                                        Text("₹ 208.00 - 249.60 ",style: TextStyle(fontWeight: FontWeight.w700),),
                                        Text("Rent sq.ft",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey),),
                                        Spacer(),
                                        Container(
                                            height: screenHeight*0.05,
                                          width: screenWidth*0.13,
                                          decoration: BoxDecoration(
                                            color: Colors.blue
                                          ),
                                          child: Icon(Icons.help_center_outlined,color: Colors.white,),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
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
                                              child: Text("2000.00 sq.ft",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text("Available area",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Text("3 Months",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
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
                                              child: Text("RCC",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text("Warehouse Type",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                            SizedBox(height: 4,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0,top: 8),
                                              child: Text("VDF",style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.w500),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Text("Floor type",style: TextStyle(color: Colors.grey,fontSize: 10,fontWeight: FontWeight.w500),),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 13,),
                                  Align(
                                   alignment: Alignment.centerLeft,
                                   child: Padding(
                                     padding: const EdgeInsets.only(left: 15.0),
                                     child: Text("Address",style: TextStyle(
                                       fontSize: 13,
                                       fontWeight: FontWeight.w500
                                     ),),
                                   ),
                                 ),
                                  SizedBox(height: 13,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    height: screenHeight*0.07,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey,width: 1.5),
                                        borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 4.0),
                                          child: Column(
                                            children: [
                                              Text("New Delhi,North Delhi",style: TextStyle(fontWeight: FontWeight.w500),),
                                              Text("8.0 Km away from your current location",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: Colors.grey),),
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5.0),
                                          child: Image.asset("assets/images/Locationblack.png"),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 13,),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    height: screenHeight*0.12,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey,width: 1.5),
                                        borderRadius: BorderRadius.circular(5)
                                    ),

                                  ),
                                  SizedBox(height: 7,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 17.0),
                                      child: Text("Amenities",style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500
                                      ),),
                                    ),
                                  ),
                                  SizedBox(height: 15,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(padding: EdgeInsets.only(left: 10),
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
                                          Text("40 KWA",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                                          Text("Electricity",style: TextStyle(color: Colors.white,fontSize: 8),)

                                        ],
                                      ),
                                    ),
                                    ),
                                  ),
                                  SizedBox(height: 7,),
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
                                            Text("Toilet | 2",style: TextStyle(color: Colors.white,fontSize: 8),)

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
                                            Text("Truck slot | 2",style: TextStyle(color: Colors.white,fontSize: 8),)

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
                                            Text("Office space",style: TextStyle(color: Colors.white,fontSize: 8),)

                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 7,),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(padding: EdgeInsets.only(left: 10),
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
                                            Text("Bike parking slot",style: TextStyle(color: Colors.white,fontSize: 8),)

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
                                        child: Row(
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
                                          child: Row(
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpressInterestScreen()));
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





class CarpetAreaTextFormField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Enter carpet area',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|sqft',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField2 extends StatelessWidget {
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
          hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
          contentPadding: EdgeInsets.only(left: 8,bottom: 10), // Adjust vertical padding
          border: InputBorder.none,


          suffix: Container(
            padding: EdgeInsets.only(left: 8.0,right: 6), // Space between the text and the input
            child: Text(
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
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: '₹|ex.35',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: '₹|ex.2',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.2',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        // suffix: Container(
        //   padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
        //   child: Text(
        //     '|per month',
        //     style: TextStyle(color: Colors.grey, fontSize: 13),
        //   ),
        // ),
      ),
    );
  }
}
class CarpetAreaTextFormField6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.3',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.18',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}
class CarpetAreaTextFormField8 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'ex.18',
        hintStyle: TextStyle(color: Colors.grey,fontSize: 12), // Hint text color
        // contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Adjust vertical padding
        border: InputBorder.none,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0),
        ),
        suffix: Container(
          padding: EdgeInsets.only(left: 8.0), // Space between the text and the input
          child: Text(
            '|per month',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ),
    );
  }
}








