import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/User/getuserlocation.dart';
import 'package:warehouse/User/userHomePage.dart';
import 'package:warehouse/newHomePage.dart';

class userverifyotp extends StatefulWidget {
  final String verificationId; // This will be passed from _submitForm
  final String phoneNumber; // This will be passed from _submitForm

  userverifyotp({required this.verificationId, required this.phoneNumber});
  @override
  State<userverifyotp> createState() => _userverifyotpState();
}

class _userverifyotpState extends State<userverifyotp> {
  String? _errorMessage;

  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _verifyOtp() async {
    String otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      setState(() {
        _errorMessage = 'Please enter a 6-digit OTP.';
      });
      return;
    }



    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUserLoggedIn', true);
      print("yahasethogya"+widget.phoneNumber);
      await prefs.setString("phone", widget.phoneNumber);
      print("sharedsebhi"+prefs.getString("phone")!);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => newHomePage()),
            (Route<dynamic> route) => false, // This removes all previous routes
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid OTP. Please enter the correct OTP.';
      });
    }
  }

  Timer? _timer;
  int _start = 30;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _isButtonDisabled = true;
    _start = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_start > 0) {
          _start--;
        } else {
          _isButtonDisabled = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                              icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              margin: EdgeInsets.only(left: screenWidth * 0.045),
                              child: Text(
                                "Confirm OTP",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
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
                                left: screenWidth * 0.045,
                                top: screenHeight * 0.01,
                              ),
                              child: Text(
                                "OTP has been sent to ${widget.phoneNumber}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.04,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(right: screenWidth * 0.06),
                              child: Image.asset(
                                "assets/images/faceid.png",
                                height: screenHeight * 0.12,
                                width: screenHeight * 0.12,
                              ),
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
                          padding: EdgeInsets.only(top:10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 70,left: 40,right: 40),
                                child: Column(
                                  children: [
                                    Center(
                                      child: PinCodeTextField(
                                        controller: _otpController,
                                        appContext: context,
                                        length: 6,
                                        onChanged: (value) {
                                          print(value);
                                        },
                                        pinTheme: PinTheme(
                                          errorBorderColor: Colors.red,
                                          shape: PinCodeFieldShape.box,
                                          borderRadius: BorderRadius.circular(5),
                                          fieldHeight: screenWidth * 0.12,
                                          fieldWidth: screenWidth * 0.12,
                                          activeFillColor: Colors.blue,
                                          selectedFillColor: Colors.blue,
                                          inactiveFillColor: Colors.grey.shade200,
                                          inactiveColor: Colors.grey.shade300,
                                          activeColor: Colors.blue,
                                          selectedColor: Colors.blue,
                                        ),
                                        keyboardType: TextInputType.number,
                                        animationType: AnimationType.slide,
                                        boxShadows: [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 4,
                                          ),
                                        ],
                                        enableActiveFill: true,
                                        onCompleted: (value) {
                                          _verifyOtp();
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => getuserlocation()));
                                          // // Handle OTP completion
                                        },
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    if (_errorMessage != null)
                                      Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$_start seconds',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        TextButton(
                                          onPressed: _isButtonDisabled
                                              ? null
                                              : () {
                                            startTimer();
                                            // Handle resend OTP logic here
                                          },
                                          child: Text(
                                            'Resend OTP',
                                            style: TextStyle(
                                              color: _isButtonDisabled
                                                  ? Colors.grey
                                                  : Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.07),
                              Container(
                                height: screenHeight * 0.06,
                                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _verifyOtp();
                                    // Handle OTP verification
                                  },
                                  child: Text('Verify & Proceed'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                                  ),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.017),

                              SizedBox(height: screenHeight * 0.1),
                              Text(
                                "By continuing, you agree to our Terms and Conditions",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.025,
                                  color: Colors.blue,
                                ),
                              ),
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
