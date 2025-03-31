import 'package:Lisofy/Warehouse/Partner/home_screen.dart';
import 'package:Lisofy/Warehouse/User/customPainter/custom_painter.dart';
import 'package:Lisofy/resources/ImageAssets/ImagesAssets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
class PostYourPropertyScreen extends StatefulWidget {
  const PostYourPropertyScreen({super.key});
  @override
  State<PostYourPropertyScreen> createState() => _PostYourPropertyScreenState();
}
class _PostYourPropertyScreenState extends State<PostYourPropertyScreen> {
  late ScrollController _scrollController;
  bool _isFabVisible = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isFabVisible = true;
        });
      }
    });
  }
  void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  width: screenWidth,
                  color: Colors.blue.shade100,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Image.asset(ImageAssets.backgroundUpper),
                      Center(
                        child: Column(
                          children: [
                            const Spacer(),
                            const Text("Lease & rent warehouse",style: TextStyle(color: Colors.yellowAccent,fontWeight: FontWeight.w900,fontSize: 17),),
                            const Text("List your property for rent",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w700),),
                            Image.asset(ImageAssets.warehouseAds,width: screenWidth*0.55,),
                            const Text("Lease & rent warehouse",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14),),
                            SizedBox(height: screenHeight*0.005,)
                          ],
                        ),
                      )
                    ],
                  )
                ),
              ),
              // Second Section (4/9 of screen)
              Expanded(
                flex: 4,
                child: Container(
                    width: screenWidth,
                    color: const Color(0xffC7D4F6),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight*0.01,),
                        const Text("List your property",style: TextStyle(color: Color(0xff171D8F),fontSize: 17,fontWeight: FontWeight.bold),),
                        Text("in just few simple steps",style: TextStyle(color: Colors.black.withValues(alpha: 0.4),fontSize: 12),),
                        SizedBox(height: screenHeight*0.008,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("List in your property in the Lisofy\nPartner app",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),),
                                SizedBox(height: screenHeight*0.008,),
                                Row(
                                  children: [
                                    DownArrow(height: screenHeight*0.07,width: screenWidth*0.06,color: Colors.blue,),
                                    const Text("Basic information\nSize capacity\nFacility & feature\nPricing & leasing team",style: TextStyle(color: Color(0xff2E2E2E),fontWeight: FontWeight.w300,fontSize: 10),)
                                  ],
                                )
                              ],
                            ),
                            Image.asset(ImageAssets.phoneHand)
                          ],),
                        SizedBox(height: screenHeight*0.005,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Enter your property details",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),),
                                SizedBox(height: screenHeight*0.008,),
                                Row(
                                  children: [
                                    DownArrow(height: screenHeight*0.07,width: screenWidth*0.06,color: Colors.blue,),
                                    const Text("Name\nLocation\nProperty type\nSafety measures    ",style: TextStyle(color: Color(0xff2E2E2E),fontWeight: FontWeight.w300,fontSize: 10),)
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:screenHeight*0.0),
                              child: Image.asset(ImageAssets.taskList),
                            )
                          ],),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                const Text("Manage at your ease",style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w700),),
                                SizedBox(height: screenHeight*0.008,),
                                const Row(
                                  children: [
                                    Text("Seamless inventory tracking\noptimized supply chain",style: TextStyle(color: Color(0xff2E2E2E),fontWeight: FontWeight.w300,fontSize: 10),)
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding:  EdgeInsets.only(top:screenHeight*0.03),
                              child: Image.asset(ImageAssets.locality),
                            )
                          ],),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            IntrinsicWidth(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.007,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: const Color(0xffFFD1D1),
                                  borderRadius: BorderRadius.circular(screenWidth * 0.01),
                                ),
                                child: const Text(
                                  "List it for free, Lisofy will not charge anything",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Positioned(
                              top: -screenHeight * 0.03,
                              left: -screenWidth*0.04,
                              child: Image.asset(
                                ImageAssets.free,
                                width: screenWidth * 0.1,
                                height: screenHeight * 0.05,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: screenWidth,
                  color: const Color(0xffCCCCCC),
                  alignment: Alignment.center,
                  child:  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth*0.05),
                          child: const Text("Widely trusted by- ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 16),),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10,0,10,10),
                          child: Text("NeedTo Assist, Logistics Manger (Delhi/NCR), highly recomends Lisofy as one of the best warehouse and supply "
                              "chain solution providers. Their platfroms has significantly improved our logistics operations stramlining inventry"
                              " managemet and ensuring faster and fulfillment. Seamless integration with our existing system and their responsive "
                              "customer support make a real difference. Lisofy innovative solutions have have enhanced our efficiency and "
                              "reliability making and it a must-have for buiness looking to optimize their supply chain process"
                            ,style: TextStyle(fontSize: 11,fontWeight: FontWeight.w500),),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: _isFabVisible ? 1.0 : 0.0,
        child: Visibility(
          visible: _isFabVisible,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:  EdgeInsets.only(bottom: screenHeight*0.005),
              child: Container(
                width: screenWidth * 0.5,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Text(
                    "Post Your Property",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
