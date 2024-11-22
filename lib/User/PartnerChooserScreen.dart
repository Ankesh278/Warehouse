
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/generated/l10n.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';

class PartnerChooserScreen extends StatefulWidget {
  @override
  State<PartnerChooserScreen> createState() => _PartnerChooserScreenState();
}

class _PartnerChooserScreenState extends State<PartnerChooserScreen> {

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
                      height: screenHeight * 0.13,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.02,
                          left: screenWidth * 0.025,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            Align(
                              alignment:Alignment.centerLeft,
                              child: InkWell(child: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                                onTap: (){
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const Spacer(),
                            const Text("Whose partner do you want to be?",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),)
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
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: const SingleChildScrollView(
                              child: Column(
                                children: [
                                  CustomTextFieldShape()
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






class CustomTextFieldShape extends StatefulWidget {
  const CustomTextFieldShape({super.key});

  @override
  State<CustomTextFieldShape> createState() => _CustomTextFieldShapeState();
}

class _CustomTextFieldShapeState extends State<CustomTextFieldShape> {
  int? selectedOption;

  void selectOption(int index) {
    setState(() {
      selectedOption = index;
    });

    if (index == 0) {
      // Navigate to HomeScreen if index is 0
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      // Show Coming Soon Popup with Animation
      _showComingSoonDialog(context);
    }
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissal by tapping outside
      builder: (BuildContext context) {
        return ComingSoonDialog(); // Custom dialog widget
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight*0.01),
          buildSelectableContainer(0, S.of(context).warehousing, ImageAssets.warehouseIco,ImageAssets.warehouseIcon),
          SizedBox(height: 10,),
          buildSelectableContainer(1, S.of(context).transportation, ImageAssets.SemiTruck,ImageAssets.transport),
          SizedBox(height: 10,),
          buildSelectableContainer(2, S.of(context).manpower, ImageAssets.group,ImageAssets.manpower),
          SizedBox(height: 10,),
          buildSelectableContainer(3, S.of(context).agricultural, ImageAssets.Tractor,ImageAssets.agricultural),
        ],
      ),
    );
  }

  Widget buildSelectableContainer(int index, String label, String imageAsset,String image) {
    bool isSelected = selectedOption == index;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            selectOption(index);
          },
          child: Stack(
            children: [
              // Background image
              Container(
                width: double.infinity,
                height: screenHeight * 0.17,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  image: DecorationImage(
                    image: AssetImage(imageAsset), // Background image
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), // Semi-transparent overlay
                      BlendMode.darken,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: const Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
              ),

              // Content on top of the image
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          image,
                          width: screenWidth * 0.28,
                          height: screenHeight * 0.12,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 4),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // Center space and label
                      const Spacer(),

                      // Right green tick box
                      // if (isSelected)
                      //   Container(
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(8.0),
                      //       border: Border.all(color: Colors.green),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Colors.green.withOpacity(0.4),
                      //           spreadRadius: 2,
                      //           blurRadius: 4,
                      //         ),
                      //       ],
                      //     ),
                      //     width: 50,
                      //     height: 50,
                      //     child: const Icon(
                      //       Icons.check,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

}

class ComingSoonDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Automatically close the dialog after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
    });

    return Dialog(
      backgroundColor: Colors.transparent,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(seconds: 2),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  width: 250,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.watch_later_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Coming Soon!',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Stay tuned for something amazing!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.7),
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
    );
  }
}

























