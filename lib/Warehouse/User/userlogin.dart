import 'package:Lisofy/Warehouse/User/UserProvider/auth_user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';



class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
@override
  void initState() {
    super.initState();
    _fetchPhoneNumber();
    _phoneController.addListener(() {
      if (_phoneController.text.length == 10) {
        FocusScope.of(context).unfocus();
      }
    });
  }
  Future<void> _fetchPhoneNumber() async {
    try {
      String? phoneNumber = await SmsAutoFill().hint;
      if (phoneNumber != null && phoneNumber.startsWith('+91')) {
        _phoneController.text = phoneNumber.substring(3).trim();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching phone number: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthUserProvider>(context);
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
                                      0.045),
                              child: Text(
                                "Sign in / Login",
                                style: TextStyle(
                                  fontSize: screenWidth *
                                      0.05,
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
                                    0.045,
                                top: screenHeight *
                                    0.01,
                              ),
                              child: Text(
                                "Welcome back to the app",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth *
                                      0.04,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: screenWidth *
                                      0.06),
                              child: Image.asset(
                                "assets/images/faceid.png",
                                height: screenHeight *
                                    0.12,
                                width: screenHeight *
                                    0.12,
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
                          right: screenWidth * 0.005),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                            screenWidth * 0.04),
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth *
                                        0.065,
                                    vertical: screenHeight *
                                        0.015,
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '(+91) India'),
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder
                                          .none,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth *
                                          0.04,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth *
                                          0.05),
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    maxLength: 10,
                                    decoration: InputDecoration(
                                      errorText: authProvider.errorMessage,
                                      hintText:
                                          'Enter your mobile number',
                                      hintStyle: TextStyle(
                                        color: Colors.blue,
                                        fontSize: screenWidth *
                                            0.03,
                                      ),
                                      border: InputBorder
                                          .none,
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blue),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .blue),
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
                                       },
                                       style: ElevatedButton.styleFrom(
                                         foregroundColor: Colors.white,
                                         backgroundColor: Colors.blue,
                                         minimumSize: Size(
                                             double.infinity,
                                             screenHeight *
                                                 0.06),
                                       ),
                                       child: authProvider.isLoading?const SpinKitCircle(
                                         color: Colors.white,
                                         size: 50.0,
                                       )
                                         :const Text('Get OTP'),
                                     ),
                                   );
                                 }),
                                SizedBox(
                                    height: screenHeight * 0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical:
                                              10.0),
                                      width: 100.0,
                                      height: 2,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: screenHeight * 0.02),
                                    const Text(
                                      "or",
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: screenHeight * 0.02),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      width: 100.0,
                                      height: 2,
                                      color: Colors.blue,
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.05),
                                SizedBox(
                                    height: screenHeight * 0.05),
                                InkWell(
                                  child: Container(
                                    height: 25,
                                    width: screenWidth * 0.28,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffD4E3FF),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: const Center(
                                      child: Text(
                                        "Skip for Now >>",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                  },
                                ),
                                SizedBox(
                                    height: screenHeight *
                                        0.025),
                                Text(
                                  "By continuing, you agree to our Terms and Conditions",
                                  style: TextStyle(
                                    fontSize: screenWidth *
                                        0.025,
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
