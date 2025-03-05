import 'dart:async';
import 'dart:convert';
import 'package:Lisofy/Warehouse/Partner/partner_registration_screen.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/photo_provider.dart';
import 'package:Lisofy/Warehouse/User/getuserlocation.dart';
import 'package:Lisofy/Warehouse/User/models/user_data_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';


class UserVerifyOtp extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const UserVerifyOtp.userVerifyOtp({super.key, required this.verificationId,required this.phoneNumber});
  @override
  State<UserVerifyOtp> createState() => UserVerifyOtpState();
}

class UserVerifyOtpState extends State<UserVerifyOtp> {
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

      String url = 'https://xpacesphere.com/api/Register/Registration?mobile=${widget.phoneNumber}';
      final response = await http.post(Uri.parse(url));
      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = jsonDecode(response.body);

          if (!responseData.containsKey('message')) {
            throw Exception("Invalid API response: Missing 'message' key.");
          }

          if (responseData['message'] == "Register Successfully") {
            await _storeUserData(true);
            trackButtonClick('OtpVerifyButton');
            _navigateTo(context, PartnerRegistrationScreen(phone: widget.phoneNumber));
          } else if (responseData['message'] == "Data retrieved successfully") {
            if (responseData['data'] != null && responseData['data'] is List) {
              if (kDebugMode) {
                print("Data Type: ${responseData['data'].runtimeType}");
              }

              List<UserData> userData = (responseData['data'] as List)
                  .map((e) => UserData.fromJson(e))
                  .toList();

              if (userData.isNotEmpty) {
                await _storeUserDetails(context,userData.first);
                _navigateTo(context, const GetUserLocation());
              } else {
                throw Exception("User data list is empty.");
              }
            } else {
              throw Exception("Invalid API response: 'data' is missing or not a List.");
            }
          } else {
            setError('Unexpected response message: ${responseData['message']}');
          }
        } catch (e) {
          if (kDebugMode) {
            print("JSON Parsing Exception: $e");
          }
          setError("Error processing API response: ${e.toString()}");
        }
      } else {
        setError('Unexpected server response: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      setError('Invalid OTP or server error. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  void setError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
  Future<void> _storeUserDetails(BuildContext context, UserData user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserLoggedIn', true);
    await prefs.setString('phone', widget.phoneNumber);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.mailid);
    await prefs.setString('profileImage', user.userProfile);

    if (kDebugMode) {
      print("ImageUrl: ${user.userProfile}");
    }
    Provider.of<ProfileProvider>(context, listen: false)
        .setProfileImageUrl("https://xpacesphere.com${user.userProfile}");

    if (kDebugMode) {
      print("Updated Profile URL: https://xpacesphere.com${user.userProfile}");
    }
  }

  Future<void> _storeUserData(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isUserLoggedIn', isLoggedIn);
    await prefs.setString('phone', widget.phoneNumber);
  }
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
          (Route<dynamic> route) => false,
    );
  }
  Timer? _timer;
  int _start = 30;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    startTimer();
    listenForCode();
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
    //cancel();
  }
  /// Listen for OTP automatically
  void listenForCode() async {
    await SmsAutoFill().listenForCode();
  }
  /// This method gets triggered when an OTP is received
  void codeUpdated(String? code) {
    setState(() {
      _otpController.text = code ?? "";
    });
    if (_otpController.text.isNotEmpty) {
      if (kDebugMode) {
        print("Received OTP: $_otpController");
      }
    }
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
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                                          if (kDebugMode) {
                                            print(value);
                                          }
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
                                        onCompleted: (value) {
                                          FocusScope.of(context).unfocus();
                                          _verifyOtp();
                                        },
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.002),
                                    if (_errorMessage != null)
                                      Text(
                                        _errorMessage!,
                                        style: const TextStyle(color: Colors.red),
                                      ),
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
                                    FocusScope.of(context).unfocus();
                                    _verifyOtp();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(double.infinity, screenHeight * 0.06),
                                  ),
                                  child: const Text('Verify & Proceed'),
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

  void trackButtonClick(String buttonName) async {
    await FirebaseAnalytics.instance.logEvent(
      name: 'button_click',
      parameters: {
        'VerifyOtp': buttonName,
      },
    );
  }

}
