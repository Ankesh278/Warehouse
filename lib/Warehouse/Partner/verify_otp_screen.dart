import 'dart:async';
import 'package:Lisofy/Warehouse/Partner/partner_registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class VerifyOtpScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyOtpScreen({super.key, required this.verificationId, required this.phoneNumber});

  @override
  VerifyOtpScreenState createState() => VerifyOtpScreenState();
}

class VerifyOtpScreenState extends State<VerifyOtpScreen> {
  String? _errorMessage;
  bool isLoading=false;

  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<void> _verifyOtp() async {
    setState(() {
      isLoading = true;
    });

    String otp = _otpController.text.trim();
    if (otp.isEmpty || otp.length < 6) {
      setState(() {
        isLoading = false;
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
      String url = 'http://xpacesphere.com/api/Register/Registration?mobile=${widget.phoneNumber}';
      final response = await http.post(Uri.parse(url));
      if (kDebugMode) {
        print("Registration api       $url");
      }
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('phone', widget.phoneNumber);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PartnerRegistrationScreen(phone: '',)),
              (Route<dynamic> route) => false,
        );
      } else if (response.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('phone', widget.phoneNumber);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PartnerRegistrationScreen(phone: '',)),
              (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _errorMessage = 'Unexpected server response: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _errorMessage = 'Invalid OTP or server error. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
                              icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
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
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top:10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 70, left: 40, right: 40),
                                child: Column(
                                  children: [
                                    Center(
                                      child: PinCodeTextField(
                                        controller: _otpController,
                                        appContext: context,
                                        length: 6,
                                        onChanged: (value) {},
                                        onCompleted: (value) {
                                          _verifyOtp();
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
                                        boxShadows: const [
                                          BoxShadow(
                                            color: Colors.white,
                                            blurRadius: 4,
                                          ),
                                        ],
                                        enableActiveFill: true,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    if (_errorMessage != null)
                                      Text(
                                        _errorMessage!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                    SizedBox(height: screenHeight * 0.002),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '$_start seconds',
                                          style: const TextStyle(color: Colors.blue),
                                        ),
                                        TextButton(
                                          onPressed: _isButtonDisabled
                                              ? null
                                              : () {
                                            startTimer();
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
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                                  ),
                                  child: isLoading?const SpinKitCircle(
                                    color: Colors.white,
                                    size: 50.0,
                                  ):
                                    const Text('Verify & Proceed'),
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.017),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                                    width: 100.0,
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(width: screenHeight * 0.02),
                                  const Text(
                                    "or",
                                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: screenHeight * 0.02),
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                                    width: 100.0,
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.017),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock, size: screenWidth * 0.025, color: Colors.blue),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text(
                                    "Sign in with Password",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: screenWidth * 0.03,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.1),
                              Text(
                                "By signing in you agree to our",
                                style: TextStyle(color: Colors.blue, fontSize: screenWidth * 0.03),
                              ),
                              SizedBox(height: screenHeight * 0.01),
                              Text(
                                "Terms and Conditions",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.03,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.05),
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
