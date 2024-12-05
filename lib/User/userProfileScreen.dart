import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warehouse/Localization/Languages.dart';
import 'package:warehouse/User/NotificationSetting.dart';
import 'package:warehouse/User/UserProvider/photoProvider.dart';
import 'package:warehouse/User/websiteViewer.dart';
import 'package:warehouse/User/userlogin.dart';
import 'package:http_parser/http_parser.dart';

class userProfileScreen extends StatefulWidget {
  const userProfileScreen({super.key});

  @override
  State<userProfileScreen> createState() => _userProfileScreenState();
}

class _userProfileScreenState extends State<userProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String phone='';
  late String Name='';
   String userFile="";
   String email="";
   String name="";
  @override
  void initState() {
    super.initState();
    getSharedPreference();
  }
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController additionalPhoneController = TextEditingController();
  final TextEditingController emialController = TextEditingController();

  Future<void> _logoutAndRedirect(BuildContext context) async {
    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Sign out from Firebase Authentication (for phone auth)
      FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;
      if (currentUser != null) {
        await auth.signOut();
      }

      // Clear SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('email');
      await prefs.remove('phone');
      await prefs.remove('Name');
      await prefs.setBool('isUserLoggedIn', false);

      // Navigate to the Login Page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => userlogin()), // Replace with your login page
            (route) => false,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error during logout: $e");
      }
      // Optionally, show an error message or handle the error
    }
  }
  // Function to show the confirmation dialog with Yes/No buttons
  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      barrierDismissible: false, // Disable dismiss on tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Log Out",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red, // Red title for log out warning
            ),
          ),
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Are you sure you want to log out?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Stay logged in
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.green, // Green color for "No" button
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Log out
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red color for "Yes" button
              ),
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 40,left: 15),
                        alignment: Alignment.topLeft,
                        color: Colors.blue,
                        height: screenHeight * 0.28,
                        child: const Text(
                          "",
                          style: TextStyle(
                              color: Colors.white, fontSize: 14),
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
                            padding: const EdgeInsets.all(0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: screenHeight*0.14,),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    color: Colors.blue,
                                    width: double.infinity,
                                    height: screenHeight*0.18,
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(left: 8.0,top: 5),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("Looking for Rent your Properties?",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w800),)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0,top: 5),
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/images/CheckMark.png"),
                                                  const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("Verified Property and Owner",style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.normal),)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0,top: 5),
                                              child: Row(
                                                children: [
                                                  Image.asset("assets/images/CheckMark.png"),
                                                  const Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("Larger Collection of Warehouses",style: TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.normal),)),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 15.0,top: 12),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  height: 25,
                                                  width: screenWidth*0.5,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(7),
                                                  ),
                                                  child: const Center(child: Text("Post your Property FREE",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w800,fontSize: 12),)),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Image.asset("assets/images/Ellipse.png",),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 6.0),
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Image.asset("assets/images/house1.png")),
                                        )
                                      ],
                                    )
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.blue),
                                    ),
                                    child: Row(

                                      children: [

                                        Container(
                                          height: 34,
                                          width: 34,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: const Icon(Icons.wifi_calling_3_outlined,color: Colors.blue,),

                                        ),
                                        const SizedBox(width: 15),
                                        InkWell(
                                          child: const Text(
                                            "Call for Assistance",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          onTap: () async {
                                            final call = Uri.parse('tel:+91 7007221530');
                                            if (await canLaunchUrl(call)) {
                                            launchUrl(call);
                                            } else {
                                            throw 'Could not launch $call';
                                            }
                                          },
                                        ),

                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0,top: 10),
                                    child: Text("Account",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      _showUploadDocumentDialog(context);
                                      // if (userFile == null || userFile.isEmpty) {
                                      //   // Call the upload dialog if userFile is empty or null
                                      //
                                      // } else {
                                      //   // Show a toast indicating the file is already uploaded
                                      //   Fluttertoast.showToast(
                                      //     msg: "Already uploaded.",
                                      //     toastLength: Toast.LENGTH_SHORT,
                                      //     gravity: ToastGravity.BOTTOM,
                                      //   );
                                      // }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(Icons.file_present_outlined,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Contract Documents",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey,),
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  InkWell(
                                    onTap: (){

                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Icon(Icons.diamond_outlined,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Subscriptions",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey,),
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 20),
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: const Row(

                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(Icons.share,color: Colors.grey,),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Referral",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0,top: 10,bottom: 5),
                                    child: Text("General",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  InkWell(
                                    onTap: (){
                                      _sendEmail(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(Icons.support_agent,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Help and Support",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ),
                                 // SizedBox(height: screenHeight*0.02,),
                                  // Container(
                                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                                  //   height: 35,
                                  //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.white,
                                  //     borderRadius: BorderRadius.circular(6),
                                  //     border: Border.all(color: Colors.grey),
                                  //   ),
                                  //   child: const Row(
                                  //
                                  //     children: [
                                  //       Padding(
                                  //         padding: EdgeInsets.only(left: 4.0),
                                  //         child: Icon(Icons.punch_clock_outlined,color: Colors.grey,),
                                  //       ),
                                  //       SizedBox(width: 15),
                                  //       Text(
                                  //         "Change Password",
                                  //         style: TextStyle(
                                  //           fontSize: 12,
                                  //           color: Colors.black,
                                  //           fontWeight: FontWeight.w300,
                                  //         ),
                                  //       ),
                                  //       Spacer(),
                                  //       Padding(
                                  //         padding: EdgeInsets.only(right: 8.0),
                                  //         child: Align(
                                  //           alignment: Alignment.centerRight,
                                  //           child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                  //         ),
                                  //       )
                                  //
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: screenHeight*0.02,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NotificationSetting()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(Icons.edit_notifications_sharp,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Notification Setting",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 20.0,top: 10,bottom: 5),
                                    child: Text("General",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const WebViewScreen(
                                              url: 'https://xpacesphere.com/Privacy%20Policy%20for%20Xpace%20Sphere.html',
                                              title:"Privacy and Policy"
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(Icons.policy_outlined,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Privacy Policy",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const WebViewScreen(
                                            url: 'https://xpacesphere.com/Terms%20of%20use.html',
                                           title:"Terms and Conditions"
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Row(

                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(Icons.collections_bookmark_outlined,color: Colors.grey,),
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Terms & Conditions",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child:  Icon(Icons.arrow_forward_ios,size: 15,color:Colors.grey),
                                            ),
                                          )


                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.03,),
                                  Center(
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.logout_rounded, color: Colors.red),
                                            const SizedBox(width: 10),
                                            const Text(
                                              "Log out",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red, // Red text for logout
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(right: 0.0),
                                              child: Align(
                                                alignment: Alignment.centerRight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white, // Background color for the dropdown
                                                    borderRadius: BorderRadius.circular(12), // Rounded corners
                                                    border: Border.all(color: Colors.blue, width: 2), // Border color and width
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey.withOpacity(0.5), // Soft shadow
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: const Offset(0, 3), // Shadow position
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 0), // Padding inside the dropdown
                                                  child: DropdownButton<Locale>(
                                                    icon: const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.blue, // Change icon color to blue
                                                      size: 24, // Adjust icon size
                                                    ),
                                                    value: languageProvider.locale,
                                                    onChanged: (Locale? newLocale) {
                                                      if (newLocale != null) {
                                                        languageProvider.setLocale(newLocale);
                                                      }
                                                    },
                                                    underline: Container(), // Remove the default underline
                                                    dropdownColor: Colors.white, // Dropdown background color
                                                    isDense: true, // Makes the dropdown more compact
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.bold,
                                                    ), // Text style for selected item
                                                    items: LanguageProvider.supportedLocales.map((Locale locale) {
                                                      return DropdownMenuItem(
                                                        value: locale,
                                                        child: Row(
                                                          children: [
                                                            const Icon(Icons.language, color: Colors.blueAccent, size: 18), // Optional icon before text
                                                           // SizedBox(width: 8), // Space between icon and text
                                                            Text(
                                                              languageProvider.getLanguageName(locale), // Display full language name
                                                              style: const TextStyle(
                                                                color: Colors.black,
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        // Show the confirmation dialog before logout
                                        bool shouldLogout = await _showLogoutConfirmationDialog(context);
                                        if (shouldLogout) {
                                          // Call the logout function
                                          await _logoutAndRedirect(context);
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(left: 20.0,top: 0,bottom: 0),
                                      child:Row(
                                        children: [
                                          Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(color: Colors.black)
                                            ),
                                            child: const Center(child: Icon(Icons.add)),
                                          ),
                                          const SizedBox(width: 15,),
                                          const Text("Follow us on : ",style: TextStyle(fontWeight: FontWeight.w500),),
                                          const SizedBox(width: 15,),
                                          InkWell(child: Image.asset("assets/images/Facebook.png"),
                                          onTap: (){
                                           _openFacebookProfile();
                                          },
                                          ),
                                          const SizedBox(width: 15,),
                                          InkWell(child: Image.asset("assets/images/Instagram.png"),
                                          onTap: (){
                                            _openInstagramProfile();
                                          },
                                          ),
                                          const SizedBox(width: 15,),
                                          InkWell(child: Image.asset("assets/images/TwitterX.png"),
                                          onTap: (){
                                            _openTwitterProfile();
                                          },
                                          )
                                        ],
                                      )
                                  ),
                                  SizedBox(height: screenHeight*0.04,),
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
          // Red container on top of both blue and white sections
          Positioned(
            top: screenHeight * 0.15, // Adjust this to move the container vertically based on screen size
            left: screenWidth * 0.15, // Center the container horizontally based on screen width
            child: Container(
              height: screenHeight * 0.23, // Responsive height based on screen height
              width: screenWidth * 0.7, // Responsive width based on screen width
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    spreadRadius: 1,
                    blurRadius: 15,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white),
              ),
              child: Column(
                children: [
                  const Spacer(),
                  Text(
                    Name.isNotEmpty ? Name : 'Guest',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_calling_3_outlined,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          phone.isNotEmpty ? phone : '',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showEditDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 13, right: 13),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: const Center(
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return Positioned(
                top: screenHeight * 0.08,
                left: screenWidth / 2 - 45,
                child: GestureDetector(
                  onTap: () => _pickImage(context),
                  child: Stack(
                    children: [
                      Container(
                        width: 90, // CircleAvatar size + border
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue, // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.blue,
                          backgroundImage: profileProvider.profileImage != null
                              ? FileImage(profileProvider.profileImage!) // Show picked image from gallery
                              : profileProvider.profileImageUrl != null
                              ? NetworkImage(profileProvider.profileImageUrl!) // Show uploaded image from URL
                              : const AssetImage("assets/images/userround.png")
                          as ImageProvider, // Default image
                        ),
                      ),
                      const Positioned(
                        bottom: 5, // Positioning relative to the border
                        right: 5,
                        child: CircleAvatar(
                          radius: 12, // Small circle size for the camera icon
                          backgroundColor: Colors.white, // Background color for the small circle
                          child: Icon(
                            Icons.camera_alt,
                            size: 14, // Icon size
                            color: Colors.blue, // Icon color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, child) {
              return Positioned(
                top: screenHeight * 0.08,
                left: screenWidth / 2 - 45,
                child: Stack(
                  children: [
                    Container(
                      width: 90, // CircleAvatar size + border
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blue, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.blue,
                        backgroundImage: profileProvider.profileImage != null
                            ? FileImage(profileProvider.profileImage!) // Show picked image from gallery
                            : profileProvider.profileImageUrl != null
                            ? NetworkImage(profileProvider.profileImageUrl!) // Show uploaded image from URL
                            : const AssetImage("assets/images/userround.png")
                        as ImageProvider, // Default image
                      ),
                    ),
                    Positioned(
                      bottom: 3, // Positioning relative to the border
                      right: 5,
                      child: InkWell(
                        onTap:() =>_pickImage(context),
                        child: const CircleAvatar(
                          radius: 8, // Small circle size for the camera icon
                          backgroundColor: Colors.blue, // Background color for the small circle
                          child: Icon(
                            Icons.camera_alt,
                            size: 14, // Icon size
                            color: Colors.white, // Icon color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }

  Future<void> getSharedPreference() async {
    if (kDebugMode) {
      print("Shared call ho gya");
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (kDebugMode) {
      print("intialize v ho gya");
    }

    // Use a fallback value or handle null cases
    Name =prefs.getString("name") ?? "Default Name"; // Provide a default value
    phone =prefs.getString("phone") ?? "Default Phone";
    // Remove the '+91' prefix if it exists
    if (phone.startsWith("+91")) {
      phone = phone.substring(3);  // Remove the first 3 characters ("+91")
    }
    phoneController.text=phone;
    nameController.text=Name;
    _fetchProfileImage();

    setState(() {

    });// Provide a default value
  }
  // Call the fetchProfileImage method when the widget is initialized
  Future<void> _fetchProfileImage() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      await fetchProfileImage(profileProvider,phone);  // Fetch and update provider
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile image: $e");
      }
    }
  }


  Future<void> fetchProfileImage(ProfileProvider profileProvider, String phone) async {
    final response = await http.get(
      Uri.parse('https://xpacesphere.com/api/Register/GetRegistr?mobile=$phone'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (kDebugMode) {
        print("Response data: $data");
      }  // Logs the entire response body

      // Log the status code and full response
      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Full Response: ${response.body}");
      }

      // Check if the 'data' array is not empty and contains the 'userProfile' key
      if (data.containsKey('data') && data['data'].isNotEmpty) {
        final userData = data['data'][0]; // Access the first item in the 'data' array
        final String relativeImageUrl = userData['userProfile'];
        if (kDebugMode) {
          print("Relative Image URL: $relativeImageUrl");
        }

         userFile= userData['userfile'] ?? "";
         name= userData['name'] ?? "";
         email= userData['Mailid'] ?? "";
        print("USERFILE"+userFile);

        SharedPreferences pref=await SharedPreferences.getInstance();
       pref.setString("email", email);
       pref.setString("name", name);
        // Concatenate the base URL with the relative image URL
        final String fullImageUrl = 'https://xpacesphere.com$relativeImageUrl';
        if (kDebugMode) {
          print("Full Image URL: $fullImageUrl");
        }

        // Update the profile provider with the full image URL
        profileProvider.setProfileImageUrl(fullImageUrl);
      } else {
        if (kDebugMode) {
          print("No user data or userProfile found in the response.");
        }
      }
    } else {
      if (kDebugMode) {
        print('Failed to load profile image with status code: ${response.statusCode}');
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      final imageFile = File(pickedFile.path);

      // Log for debugging
      if (kDebugMode) {
        print('Picked image: ${imageFile.path}');
      }

      // Update the image in the Provider immediately
      profileProvider.setProfileImage(imageFile);
      if (kDebugMode) {
        print('Updated profile image in provider.');
      }

      // Start uploading the image to the server in the background
      _uploadImage(imageFile, phone).then((uploadedImageUrl) {
        if (uploadedImageUrl != null) {
          // If upload is successful, update the image URL in the provider
          profileProvider.setProfileImageUrl(uploadedImageUrl);
          if (kDebugMode) {
            print('Uploaded image URL: $uploadedImageUrl');
          }
        }
      }).catchError((error) {
        // Handle error if upload fails
        if (kDebugMode) {
          print("Error uploading image: $error");
        }
      });
    }
  }





  Future<String?> _uploadImage(File imageFile, String phone) async {
    final uri = Uri.parse('https://xpacesphere.com/api/Register/UPDRegistr');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['Mobile'] = phone // Add the phone number field to the request
      ..files.add(await http.MultipartFile.fromPath(
        'UserProfile', // form-data field name
        imageFile.path,
        contentType: MediaType('image', 'jpeg'), // Set content type if necessary
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Read the response body
        final responseBody = await response.stream.bytesToString();
        print("Response Code: ${response.statusCode}");
        print("Response Body: $responseBody");

        final responseData = json.decode(responseBody);
        if (responseData['status'] == 'success') {

          return responseData['imageUrl'];
        } else {
          if (kDebugMode) {
            print("Error: ${responseData['message']}");
          }
          return null;
        }
      } else {
        if (kDebugMode) {
          print("Image upload failed with status: ${response.statusCode}");
        }
        final responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          print("Error response body: $responseBody");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
      return null;
    }
  }



  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 1,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: const Text(
                'Edit Profile',
                style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: phoneController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: additionalPhoneController,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            labelText: 'Additional Phone Number',
                            labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextField(
                          controller: emialController,
                          keyboardType: TextInputType.emailAddress,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            labelText: 'Add email address',
                            labelStyle: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100), // Ensure some space for scrolling past the form
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              await _submitFormWithAnimation(
                                context,
                                nameController,
                                phoneController,
                                additionalPhoneController,
                                emialController,
                              );
                            },
                            child: const Text('Submit', style: TextStyle(color: Colors.white)),
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
      },
    );
  }


  Future<void> _submitFormWithAnimation(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController phoneController,
      TextEditingController additionalPhoneController,
      TextEditingController emailController,
      ) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Submit form and get the result
    final uri = Uri.parse('https://xpacesphere.com/api/Register/UPDRegistr');
    final request = http.MultipartRequest('PUT', uri)
      ..fields['Name'] = nameController.text
      ..fields['Mobile'] = phoneController.text
      ..fields['OPMobile'] = additionalPhoneController.text
      ..fields['Mailid'] = emailController.text;

    bool success = false;

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Response Status Code: ${response.statusCode}");
        }
        success = true; // Successful submission
        SharedPreferences pref= await SharedPreferences.getInstance();
        pref.setString("name", nameController.text.toString());
        pref.setString("email", emailController.text.toString());
      } else {
        if (kDebugMode) {
          print("Error Message: $responseBody");
        }
        success = false; // Submission failed
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error submitting form: $e");
      }
      success = false; // Submission failed
    }

    // Close the loading dialog after a small delay
    if (mounted) {
      Navigator.of(context).pop();
    }

    // Show success/error dialog after form submission
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: success
                            ? const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 80,
                          key: ValueKey('success'),
                        )
                            : const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 80,
                          key: ValueKey('error'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        success
                            ? "Profile updated successfully!"
                            : "Failed to update profile.",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            additionalPhoneController.clear();
                            emialController.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(); // Close the form dialog first
                            setState(() {

                            });
                          }
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }
  }











  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'yankesh278@gmail.com',
      query: 'subject=Help%20Request',
    );

    try {
      // Attempt to open the mail client
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);

        // Show confirmation message after the email is opened
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Our team will connect with you soon."),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw 'Could not launch email app';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to open email app. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  void _showUploadDocumentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF1F8E9), Color(0xFFFFFDE7), Color(0xFFFBE9E7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 1,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: const Text(
                  'Upload Document',
                  style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Please upload your document.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Picking the file
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'pdf', 'docx'],
                          );

                          if (result != null) {
                            PlatformFile file = result.files.first;
                            String? filePath = file.path;

                            if (filePath != null) {
                              print('Selected file path: $filePath');
                              print('Mobile number: $phone');

                              // Display a loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) =>  const Center(
                                  child: SpinKitCircle(
                                    color: Colors.blue,
                                  ),
                                ),
                              );

                              // Upload the document
                              var request = http.MultipartRequest(
                                'POST',
                                Uri.parse('https://xpacesphere.com/api/Wherehousedt/UploadDocuments'),
                              );
                              request.fields['mobile'] = phone;
                              request.files.add(await http.MultipartFile.fromPath('UserFile', filePath));

                              print('API Endpoint: ${request.url}');
                              print('Request Fields: ${request.fields}');
                              print('File Upload: ${filePath}');

                              var response = await request.send();

                              Navigator.of(context).pop(); // Close the loading indicator

                              if (response.statusCode == 200) {
                                var responseBody = await response.stream.bytesToString();
                                print('Response (200): $responseBody');
                                Navigator.of(context).pop(); // Close the loading indicator
                                Fluttertoast.showToast(
                                  msg: "Document uploaded successfully!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } else {
                                var errorBody = await response.stream.bytesToString();
                                print('Error Response (${response.statusCode}): $errorBody');

                                Fluttertoast.showToast(
                                  msg: "Failed to upload document. Please try again.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            } else {
                              print('No file path available.');
                              Fluttertoast.showToast(
                                msg: "No file selected.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          } else {
                            // User canceled the file picker
                            print('File selection canceled.');
                            Fluttertoast.showToast(
                              msg: "File selection canceled.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        } catch (e, stacktrace) {
                          Navigator.of(context).pop(); // Close the loading indicator
                         /// print('An error occurred: $e', error: e, stackTrace: stacktrace);
                          Fluttertoast.showToast(
                            msg: "An error occurred. Please try again.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 4,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.blue,width: 3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload,color:Colors.black,size: 20,),
                          Text(
                            'Upload Document',
                            style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "No document uploaded",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          Navigator.of(context).pop();
                        },
                        child: const Text('Submit', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }









}
// Function to launch Instagram app or web page
void _openInstagramProfile() async {
  const String instagramUrl = 'instagram://user?username=a_tinyhunter';
  const String fallbackUrl = 'https://www.instagram.com/a_tinyhunter/';

  try {
    bool launched = await launchUrl(Uri.parse(instagramUrl), mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Instagram app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
  }
}
// Function to launch Facebook app or web page
void _openFacebookProfile() async {
  const String facebookAppUrl = 'fb://profile/100009158840334';
  const String fallbackUrl = 'https://www.facebook.com/profile.php?id=100009158840334';

  try {
    bool launched = await launchUrl(Uri.parse(facebookAppUrl), mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Facebook app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
  }
}
// Function to launch Twitter app or web page
void _openTwitterProfile() async {
  const String twitterAppUrl = 'twitter://user?screen_name=AnkeshYada78626';
  const String fallbackUrl = 'https://twitter.com/AnkeshYada78626';

  try {
    bool launched = await launchUrl(Uri.parse(twitterAppUrl), mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Twitter app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl), mode: LaunchMode.externalApplication);
  }
}
