
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
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
                      height: screenHeight * 0.18,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.025,
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
                          padding: EdgeInsets.all(screenWidth * 0.08),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          buildSelectableContainer(0, "Warehousing", ImageAssets.warehouseIco),
          buildSelectableContainer(1, "Transportation", ImageAssets.SemiTruck),
          buildSelectableContainer(2, "Manpower", ImageAssets.group),
          buildSelectableContainer(3, "Agricultural", ImageAssets.Tractor),
        ],
      ),
    );
  }

  Widget buildSelectableContainer(int index, String label, String imageAsset) {
    bool isSelected = selectedOption == index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            selectOption(index);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: isSelected ? Colors.green : Colors.grey),
            ),
            child: Row(
              children: [
                // Left image
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  height: 50,
                  child: Image.asset(
                    imageAsset,
                    width: 54,
                    height: 34,
                  ),
                ),

                // Center space
                const Spacer(),

                // Right green tick box
                if (isSelected)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.green),
                    ),
                    width: 50,
                    height: 50,
                    child: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                if (!isSelected)
                  Container(
                    width: 50,
                    height: 50,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 4),
          child: Text(label),
        ),
        const SizedBox(height: 15),
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
        duration: Duration(seconds: 1),
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: value,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
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

























