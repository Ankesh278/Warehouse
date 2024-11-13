import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/User/getuserlocation.dart';

class PartnerRegistrationScreen extends StatefulWidget {
  @override
  State<PartnerRegistrationScreen> createState() => _PartnerRegistrationScreenState();
}

class _PartnerRegistrationScreenState extends State<PartnerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
 // To manage form state
  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    Future<bool> _showExitDialog(BuildContext context) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Exit"),
          content: Text("Do you want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Stay in the app
              child: Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Exit the app
              child: Text("Yes"),
            ),
          ],
        ),
      ).then((value) => value ?? false);
    }

    return WillPopScope(
      onWillPop: () async {
        bool exit = await _showExitDialog(context);
        return exit; // Exit the app if true, stay on the screen if false
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.blue,
              width: double.infinity,
              height: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    // Blue top section with image
                    Container(
                      color: Colors.blue,
                      height: screenHeight * 0.285, // Adjusted for responsiveness
                      child: Stack(
                        children: [
                          // Positioned image on top of the blue section
                          Positioned(
                            top: 60,
                            right: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/images/image1.png', // Replace with your image path
                              height: screenHeight * 0.2, // Adjust as needed
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.015, // Adjusted for responsiveness
                              left: screenWidth * 0.03, // Adjusted for responsiveness
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // White bottom section
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.005), // Adjusted for responsiveness
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.1), // Adjusted for responsiveness
                          child: SingleChildScrollView(
                            child:Form(
                              key: _formKey, // Assign the form key for validation
                              child: Column(
                                children: [
                                  const SizedBox(height: 40),
                                  Container(
                                    height: 60,
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      keyboardType: TextInputType.name, // Set input type to name
                                      maxLength: 30, // Enforce maximum length of 30 characters
                                      decoration: const InputDecoration(
                                        labelText: 'First Name',
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: 'Enter your first name here',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'First Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 16.0),
                                  Container(
                                    height: 60,
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      keyboardType: TextInputType.name, // Set input type to name
                                      maxLength: 30, // Enforce maximum length of 30 characters
                                      decoration: const InputDecoration(
                                        labelText: 'Last Name',
                                        labelStyle: TextStyle(color: Colors.black),
                                        hintText: 'Enter your last name here',
                                        hintStyle: TextStyle(color: Colors.grey),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.blueGrey),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Last Name is required';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Container(
                                    height: 50, // Maintain the original size and design
                                    child: ElevatedButton(
                                      onPressed: () async {


                                        if (_formKey.currentState!.validate()) {
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setString("name", _firstNameController.text.toString());
                                          // Only proceed if form is valid
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(builder: (context) => GetUserLocation()),
                                                (Route<dynamic> route) => false, // Removes all previous routes
                                          );
                                        }
                                      },
                                      child: const Text('Confirm'),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blue,
                                        minimumSize: const Size(double.infinity, 50), // Maintain original design
                                      ),
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
      ),
    );
  }
}
