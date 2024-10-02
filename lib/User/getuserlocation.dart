import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:warehouse/Partner/HelpPage.dart';
import 'package:warehouse/Partner/WarehouseImageScreen.dart';
import 'package:warehouse/User/userHelpPage.dart';
import 'package:warehouse/User/userHomePage.dart';

class getuserlocation extends StatefulWidget {
  @override
  State<getuserlocation> createState() => _getuserlocationState();
}

class _getuserlocationState extends State<getuserlocation> {



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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(width: 7),
                                    Text("Hello",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500)),
                                    Text("There",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),)
                                  ],
                                ),
                                Spacer(),

                                SizedBox(width: 5),
                                InkWell(
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    margin: EdgeInsets.only(right: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.question_mark,
                                        color: Colors.blue,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>userHelpPage()));
                                  },
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: screenHeight*0.07,left: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Get Personalised Recomendations Near You",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                                  child: Container(
                                    height: screenHeight*0.05,
                                    child: TextField(
                                      decoration: InputDecoration(
                                        labelText: 'Search Near Me ',suffixStyle: TextStyle(fontSize: 13,color: Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(18)
                                        ),
                                        suffixIcon: InkWell(
                                          child: Container(
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.grey),
                                              borderRadius: BorderRadius.circular(18),
                                              color: Colors.lightBlue, // Clue blue background color
                                              shape: BoxShape.rectangle, // Rounded container
                                            ),
                                           // padding: EdgeInsets.all(8),
                                            child: ImageIcon(AssetImage("assets/images/Location.png",),color: Colors.white,)
                                          ),
                                          onTap: (){

                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ),
                                SizedBox(height: screenHeight*0.03,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.0), // Space around the line
                                      width: 100.0,
                                      height: 2,// Thickness of the line
                                      color: Colors.blue, // Color of the line
                                    ),
                                    SizedBox(width: screenHeight * 0.02),
                                    Text("or",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                                    SizedBox(width: screenHeight * 0.02),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.0), // Space around the line
                                      width: 100.0,
                                      height: 2,// Thickness of the line
                                      color: Colors.blue, // Color of the line
                                    ),

                                  ],
                                ),
                                SizedBox(height: screenHeight*0.08,),
                                Row(
                                  children: [
                                    SizedBox(width: screenWidth*0.1,),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Enter Location Manually",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),)),
                                  ],
                                ),
                                SizedBox(height: screenHeight*0.001,),
                                Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
                                    child: Container(
                                      height: screenHeight*0.05,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: 'E.g. indirapuram,Bengaluru , India ',labelStyle: TextStyle(color: Colors.grey,fontSize: 11),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(18)
                                          ),
                                          suffixIcon: InkWell(
                                            child: Container(
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.grey),
                                                  borderRadius: BorderRadius.circular(18),
                                                  color: Colors.lightBlue, // Clue blue background color
                                                  shape: BoxShape.rectangle, // Rounded container
                                                ),
                                                // padding: EdgeInsets.all(8),
                                                child: ImageIcon(AssetImage("assets/images/Location.png",),color: Colors.white,),

                                            ),
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>userHomePage()));
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                SizedBox(height: screenHeight*0.05,),
                                Image.asset("assets/images/Pinonthemapwaving.png")
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








