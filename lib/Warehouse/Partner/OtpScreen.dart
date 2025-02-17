import 'package:Lisofy/Warehouse/Partner/Provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';



class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
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
                    height: screenHeight * 0.285,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.015,
                        left: screenWidth * 0.03,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Sign in",
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Welcome back to the app",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.04,
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.065, // Adjusted for responsiveness
                                        vertical: screenHeight * 0.015, // Adjusted for responsiveness
                                      ),
                                      child: TextField(
                                        controller: TextEditingController(text: '(+91) India'),
                                        readOnly: true,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none, // Remove the default border
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue), // Bottom border color
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue), // Bottom border color when focused
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: screenWidth * 0.04, // Adjusted for responsiveness
                                        ), // Color of the text
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                      child: TextFormField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        decoration: InputDecoration(
                                          hintText: 'Enter your mobile number',
                                          hintStyle: TextStyle(
                                            color: Colors.blue,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                          border: InputBorder.none,
                                          enabledBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                          focusedBorder: const UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue),
                                          ),
                                          counterText: "",
                                          errorText: authProvider.errorMessage,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your mobile number';
                                          }
                                          if (value.length != 10) {
                                            return 'Mobile number must be 10 digits';
                                          }
                                          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                            return 'Please enter only digits';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.04),
                                    Consumer<AuthProvider>(
                                      builder: (context, authProvider, child) {
                                        return Container(
                                          height: screenHeight * 0.06,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                String phoneNumber = '+91${_phoneController.text}';
                                                authProvider.verifyPhoneNumber(phoneNumber, context);
                                              }
                                            },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                ),
                                               // padding: EdgeInsets.symmetric(vertical: 12.0),
                                              ),
                                            child:   authProvider.isLoading
                                                ? const SpinKitCircle(
                                              color: Colors.white,
                                              size: 50.0,
                                            )

                                            :  const Text('Get OTP',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    ,
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
                              // InkWell(
                              //   child: Container(
                              //     width: screenWidth * 0.75,
                              //     height: screenHeight * 0.05,
                              //     decoration: BoxDecoration(
                              //       border: Border.all(color: Colors.blue),
                              //       borderRadius: BorderRadius.circular(5),
                              //     ),
                              //     child: Center(
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Image.asset("assets/images/Google.png"),
                              //           const Text("Continue with Google", style: TextStyle(fontSize: 12)),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              //   onTap: () {
                              //     authProvider.signInWithGoogle(context);
                              //   },
                              // ),
                             // SizedBox(height: screenHeight * 0.05),

                            ],
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
