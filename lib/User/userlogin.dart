import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/User/UserProvider/auth_user_provider.dart';
// import 'package:sim_data/sim_data.dart';


class userlogin extends StatefulWidget {
  const userlogin({super.key});

  @override
  State<userlogin> createState() => _userloginState();
}

class _userloginState extends State<userlogin> {
  final _formKey = GlobalKey<FormState>();
  String? _detectedPhoneNumber;

  final TextEditingController _phoneController = TextEditingController();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _fetchPhoneNumber();
    _phoneController.addListener(() {
      if (_phoneController.text.length == 10) {
        // Dismiss the keyboard when 10 digits are entered
        FocusScope.of(context).unfocus();
      }
    });
  }


  // Future<void> _fetchPhoneNumber() async {
  //   try {
  //     final simData = await SimDataPlugin.getSimData();
  //     if (simData.cards.isNotEmpty) {
  //       setState(() {
  //         _detectedPhoneNumber = simData.cards[0].serialNumber;
  //         print("Numberr"+_detectedPhoneNumber.toString());
  //        // _phoneController.text = _detectedPhoneNumber ?? '';
  //       });
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Failed to fetch phone number: $e');
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthUserProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen blue background
          Container(
            color: Colors.blue,
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: Column(
                children: [
                  // Blue top section
                  Container(
                    color: Colors.blue,
                    height: screenHeight * 0.285, // Adjusted for responsiveness
                    child: Padding(
                      padding: EdgeInsets.only(
                        top:
                            screenHeight * 0.015, // Adjusted for responsiveness
                        left: screenWidth * 0.03, // Adjusted for responsiveness
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_sharp,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: screenWidth *
                                      0.045), // Adjusted for responsiveness
                              child: Text(
                                "Sign in / Login",
                                style: TextStyle(
                                  fontSize: screenWidth *
                                      0.05, // Adjusted for responsiveness
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(
                                left: screenWidth *
                                    0.045, // Adjusted for responsiveness
                                top: screenHeight *
                                    0.01, // Adjusted for responsiveness
                              ),
                              child: Text(
                                "Welcome back to the app",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth *
                                      0.04, // Adjusted for responsiveness
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: screenWidth *
                                      0.06), // Adjusted for responsiveness
                              child: Image.asset(
                                "assets/images/faceid.png",
                                height: screenHeight *
                                    0.12, // Adjusted for responsiveness
                                width: screenHeight *
                                    0.12, // Adjusted for responsiveness
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // White bottom section
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          right: screenWidth *
                              0.005), // Adjusted for responsiveness
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            screenWidth * 0.04), // Adjusted for responsiveness
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Country code and mobile number
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth *
                                        0.065, // Adjusted for responsiveness
                                    vertical: screenHeight *
                                        0.015, // Adjusted for responsiveness
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '(+91) India'),
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder
                                          .none, // Remove the default border
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue), // Bottom border color
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue), // Bottom border color when focused
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth *
                                          0.04, // Adjusted for responsiveness
                                    ), // Color of the text
                                  ),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth *
                                          0.05), // Adjusted for responsiveness
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      errorText: authProvider.errorMessage,
                                      hintText:
                                          'Enter your mobile number', // Hint inside the text box
                                      hintStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: screenWidth *
                                            0.03, // Adjusted for responsiveness
                                      ), // Customize hint text color
                                      border: InputBorder
                                          .none, // Remove the default border
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue), // Bottom border color
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue), // Bottom border color when focused
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile number must be 10 digits';
                                      }
                                      if (!RegExp(r'^[0-9]+$')
                                          .hasMatch(value)) {
                                        return 'Please enter only digits';
                                      }
                                      return null;
                                    },
                                  ),
                                ),

                                SizedBox(
                                    height: screenHeight *
                                        0.04),
                                 Consumer<AuthUserProvider>(builder: (context,authProvider,child){
                                   return Container(
                                     height: screenHeight *
                                         0.06,
                                     margin: EdgeInsets.symmetric(
                                         horizontal: screenWidth *
                                             0.03),
                                     child: ElevatedButton(
                                       onPressed: () {
                                         if (_formKey.currentState!.validate()) {
                                           String phoneNumber = '+91${_phoneController.text}';
                                           authProvider.verifyPhoneNumber(phoneNumber, context);
                                         }
                                         // Navigator.push(
                                         //     context,
                                         //     MaterialPageRoute(
                                         //         builder: (context) =>
                                         //             userverifyotp()));
                                         // Handle OTP request
                                       },
                                       child: authProvider.isLoading?const SpinKitCircle(
                                         color: Colors.white,
                                         size: 50.0,
                                       )
                                         :const Text('Get OTP'),
                                       style: ElevatedButton.styleFrom(
                                         foregroundColor: Colors.white,
                                         backgroundColor: Colors.blue,
                                         minimumSize: Size(
                                             double.infinity,
                                             screenHeight *
                                                 0.06), // Adjusted for responsiveness
                                       ),
                                     ),
                                   );
                                 }),
                                SizedBox(
                                    height: screenHeight *
                                        0.015), // Adjusted for responsiveness
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // Space around the line
                                      width: 100.0,
                                      height: 2, // Thickness of the line
                                      color: Colors.blue, // Color of the line
                                    ),
                                    SizedBox(width: screenHeight * 0.02),
                                    Text(
                                      "or",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: screenHeight * 0.02),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical:
                                              10.0), // Space around the line
                                      width: 100.0,
                                      height: 2, // Thickness of the line
                                      color: Colors.blue, // Color of the line
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                // Adjusted for responsiveness
                                // You can replace "google" text with the intended widget
                                // InkWell(
                                //   child: Container(
                                //     width: screenWidth * 0.75,
                                //     height: screenHeight * 0.05,
                                //     margin: EdgeInsets.symmetric(
                                //         horizontal: screenWidth * 0.03),
                                //     decoration: BoxDecoration(
                                //       border: Border.all(color: Colors.blue),
                                //       borderRadius: BorderRadius.circular(5),
                                //     ),
                                //     child: Center(
                                //       child: Row(
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.center,
                                //         children: [
                                //           Image.asset(
                                //               "assets/images/Google.png"),
                                //           const Text(
                                //             "Continue with Google",
                                //             style: TextStyle(fontSize: 12),
                                //           )
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                //   onTap: () {
                                //     authProvider.signInWithGoogle(context);
                                //   },
                                // ),
                                SizedBox(
                                    height: screenHeight *
                                        0.05), // Adjusted for responsiveness
                                InkWell(
                                  child: Container(
                                    height: 25,
                                    width: screenWidth * 0.28,
                                    decoration: BoxDecoration(
                                        color: Color(0xffD4E3FF),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                      child: Text(
                                        "Skip for Now >>",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    //onTapp skip for now
                                  },
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.025), // Adjusted for responsiveness
                                Text(
                                  "By continuing, you agree to our Terms and Conditions",
                                  style: TextStyle(
                                    fontSize: screenWidth *
                                        0.025, // Adjusted for responsiveness
                                    color: Colors.blue,
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
