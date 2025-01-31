import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:warehouse/Localization/languages.dart';
import 'package:warehouse/Partner/document_upload.dart';
import 'package:warehouse/User/NotificationSetting.dart';
import 'package:warehouse/User/UserProvider/photoProvider.dart';
import 'package:warehouse/User/UserProvider/rating_provider.dart';
import 'package:warehouse/User/websiteViewer.dart';
import 'package:warehouse/User/userlogin.dart';
import 'package:http_parser/http_parser.dart';
import 'package:warehouse/generated/l10n.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late String phone = '';
  late String Name = '';
  String userFile = "";
  String email = "";
  String name = "";
  @override
  void initState() {
    super.initState();
    getSharedPreference();
    Future.microtask(() {
      Provider.of<RatingProvider>(context, listen: false)
          .fetchUserFeedback(phone);
    });
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController additionalPhoneController =
      TextEditingController();
  final TextEditingController emialController = TextEditingController();
  final String phoneNumber = '+917007221530';
  final TextEditingController _messageController = TextEditingController();


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
        MaterialPageRoute(
            builder: (context) =>
                const userlogin()), // Replace with your login page
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
          title: Text(
            S.of(context).log_out,
            style: const TextStyle(
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
                        padding: const EdgeInsets.only(top: 40, left: 15),
                        alignment: Alignment.topLeft,
                        color: Colors.blue,
                        height: screenHeight * 0.28,
                        child: const Text(
                          "",
                          style: TextStyle(color: Colors.white, fontSize: 14),
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
                                  SizedBox(
                                    height: screenHeight * 0.14,
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  Container(
                                      color: Colors.blue,
                                      width: double.infinity,
                                      height: screenHeight * 0.18,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 5),
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      S
                                                          .of(context)
                                                          .looking_for_rent_your_properties,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 5),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/CheckMark.png"),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .verified_property_and_owner,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0, top: 5),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        "assets/images/CheckMark.png"),
                                                    Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                          S
                                                              .of(context)
                                                              .larger_collection_of_warehouses,
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0, top: 12),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    height: 25,
                                                    width: screenWidth * 0.5,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      S
                                                          .of(context)
                                                          .post_your_property_free,
                                                      style: const TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 12),
                                                    )),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Image.asset(
                                                  "assets/images/Ellipse.png",
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 6.0),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Image.asset(
                                                    "assets/images/house1.png")),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
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
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: const Icon(
                                            Icons.wifi_calling_3_outlined,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        InkWell(
                                          child: Text(
                                            S.of(context).call_for_assistance,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          onTap: () async {
                                            final call =
                                                Uri.parse('tel:+91 7007221530');
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10),
                                    child: Text(
                                      S.of(context).account,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _showUploadDocumentDialog(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.file_present_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).contracts_documents,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DocumentUpload()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.file_present_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).complete_kyc,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              Icons.diamond_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).subscriptions,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    height: 35,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Icon(
                                            Icons.share,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 15),
                                        Text(
                                          S.of(context).referral,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const Spacer(),
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(Icons.arrow_forward_ios,
                                                size: 15, color: Colors.grey),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10, bottom: 5),
                                    child: Text(
                                      S.of(context).general,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _sendEmail(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.support_agent,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).help_and_support,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () => _sendWhatsAppMessage(),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.connect_without_contact,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).connect_with_whatsapp,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.02,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NotificationSetting()));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.edit_notifications_sharp,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).notification_setting,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, top: 10, bottom: 5),
                                    child: Text(
                                      S.of(context).general,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewScreen(
                                              url:
                                                  'https://xpacesphere.com/Privacy%20Policy%20for%20Xpace%20Sphere.html',
                                              title:
                                                  S.of(context).privacy_policy),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons.policy_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).privacy_policy,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.01,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WebViewScreen(
                                              url:
                                                  'https://xpacesphere.com/Terms%20of%20use.html',
                                              title: S
                                                  .of(context)
                                                  .terms_and_conditions),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 4.0),
                                            child: Icon(
                                              Icons
                                                  .collections_bookmark_outlined,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Text(
                                            S.of(context).terms_and_conditions,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(right: 8.0),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 15,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Center(
                                    child: InkWell(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10, bottom: 10),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.logout_rounded,
                                                color: Colors.red),
                                            const SizedBox(width: 10),
                                            Text(
                                              S.of(context).log_out,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors
                                                    .red, // Red text for logout
                                              ),
                                            ),
                                            const Spacer(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 0.0),
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors
                                                        .white, // Background color for the dropdown
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12), // Rounded corners
                                                    border: Border.all(
                                                        color: Colors.blue,
                                                        width:
                                                            2), // Border color and width
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(
                                                                0.5), // Soft shadow
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: const Offset(0,
                                                            3), // Shadow position
                                                      ),
                                                    ],
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                          0), // Padding inside the dropdown
                                                  child: DropdownButton<Locale>(
                                                    icon: const Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors
                                                          .blue, // Change icon color to blue
                                                      size:
                                                          24, // Adjust icon size
                                                    ),
                                                    value:
                                                        languageProvider.locale,
                                                    onChanged:
                                                        (Locale? newLocale) {
                                                      if (newLocale != null) {
                                                        languageProvider
                                                            .setLocale(
                                                                newLocale);
                                                      }
                                                    },
                                                    underline:
                                                        Container(), // Remove the default underline
                                                    dropdownColor: Colors
                                                        .white, // Dropdown background color
                                                    isDense:
                                                        true, // Makes the dropdown more compact
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ), // Text style for selected item
                                                    items: LanguageProvider
                                                        .supportedLocales
                                                        .map((Locale locale) {
                                                      return DropdownMenuItem(
                                                        value: locale,
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                                Icons.language,
                                                                color: Colors
                                                                    .blueAccent,
                                                                size:
                                                                    18), // Optional icon before text
                                                            // SizedBox(width: 8), // Space between icon and text
                                                            Text(
                                                              languageProvider
                                                                  .getLanguageName(
                                                                      locale), // Display full language name
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
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
                                        bool shouldLogout =
                                            await _showLogoutConfirmationDialog(
                                                context);
                                        if (shouldLogout) {
                                          // Call the logout function
                                          await _logoutAndRedirect(context);
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0, top: 0, bottom: 0),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 24,
                                            width: 24,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Colors.black)),
                                            child: const Center(
                                                child: Icon(Icons.add)),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            S.of(context).follow_us_on,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          InkWell(
                                            child: Image.asset(
                                                "assets/images/Facebook.png"),
                                            onTap: () {
                                              _openFacebookProfile();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          InkWell(
                                            child: Image.asset(
                                                "assets/images/Instagram.png"),
                                            onTap: () {
                                              _openInstagramProfile();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          InkWell(
                                            child: Image.asset(
                                                "assets/images/TwitterX.png"),
                                            onTap: () {
                                              _openTwitterProfile();
                                            },
                                          )
                                        ],
                                      )),
                                  Consumer<RatingProvider>(
                                    builder: (context, ratingProvider, _) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(height: screenHeight * 0.04),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 22.0),
                                              child: Text(
                                                S
                                                    .of(context)
                                                    .we_value_your_feedback,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 22.0),
                                              child: Text(
                                                S
                                                    .of(context)
                                                    .your_comments_and_ratings_help_us_to_improve,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: screenHeight * 0.02),
                                          // AnimatedSwitcher for smooth transition
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            child: ratingProvider.isSubmitted
                                                ? _buildFeedbackSubmitted(
                                                    ratingProvider)
                                                : _buildFeedbackForm(
                                                    ratingProvider, phone),
                                          ),
                                        ],
                                      );
                                    },
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
          // Red container on top of both blue and white sections
          Positioned(
            top: screenHeight * 0.15,
            left: screenWidth * 0.15,
            child: Container(
              height: screenHeight * 0.23,
              width: screenWidth * 0.7,
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
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
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _showEditDialog(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 15, left: 13, right: 13),
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).edit_profile,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w400,
                                fontSize: 14),
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
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        child: profileProvider.profileImageUrl != null
                            ? CachedNetworkImage(
                                imageUrl: profileProvider.profileImageUrl!,
                                imageBuilder: (context, imageProvider) {
                                  return CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.blue,
                                    backgroundImage: imageProvider,
                                  );
                                },
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: const CircleAvatar(
                                    radius: 45,
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const CircleAvatar(
                                  radius: 45,
                                  backgroundColor: Colors.blue,
                                  backgroundImage:
                                      AssetImage("assets/images/userround.png"),
                                ),
                              )
                            : CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.blue,
                                backgroundImage: profileProvider.profileImage !=
                                        null
                                    ? FileImage(profileProvider.profileImage!)
                                    : const AssetImage(
                                            "assets/images/userround.png")
                                        as ImageProvider,
                              ),
                      ),
                      Positioned(
                        bottom: 3,
                        right: 5,
                        child: InkWell(
                          onTap: () => _pickImage(context),
                          child: const CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.camera_alt,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackSubmitted(RatingProvider ratingProvider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image.asset(ImageAssets.value),
        const Text(
          "Thanks you for your feedback!",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Rating: ${ratingProvider.rating}",
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            "Your words: ${ratingProvider.comment}",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
        const SizedBox(height: 30),
        AnimatedScale(
          scale: 1.1,
          duration: const Duration(milliseconds: 300),
          child: ElevatedButton(
            onPressed: () => ratingProvider.enableEditing(),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.orangeAccent,
            ),
            child: const Text(
              "Edit Feedback",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFeedbackForm(RatingProvider ratingProvider, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Rate Your Experience",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Center(
          child: RatingBar.builder(
            initialRating: ratingProvider.rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 6.0),
            itemBuilder: (context, _) =>
                const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              ratingProvider.setRating(rating);
            },
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Your Comment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FadeTransition(
          opacity: ratingProvider.isSubmitting
              ? const AlwaysStoppedAnimation(0.5)
              : const AlwaysStoppedAnimation(1.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              maxLines: 4,
              controller: ratingProvider.commentController,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: "Write something valuable...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                ratingProvider.setComment(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ratingProvider.isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      if (ratingProvider.isSubmitted) {
                        ratingProvider.updateFeedback(phone);
                      } else {
                        ratingProvider.submitFeedback(phone);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text(
                      ratingProvider.isSubmitted
                          ? "Update Feedback"
                          : "Submit Feedback",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 20),
      ],
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
    Name = prefs.getString("name") ?? "Default Name";
    phone = prefs.getString("phone") ?? "Default Phone";
    // Remove the '+91' prefix if it exists
    if (phone.startsWith("+91")) {
      phone = phone.substring(3);
    }
    phoneController.text = phone;
    nameController.text = Name;
    _fetchProfileImage();
    setState(() {});
  }

  Future<void> _fetchProfileImage() async {
    try {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      await fetchProfileImage(profileProvider, phone);
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching profile image: $e");
      }
    }
  }

  Future<void> fetchProfileImage(
      ProfileProvider profileProvider, String phone) async {
    final response = await http.get(
      Uri.parse(
          'https://xpacesphere.com/api/Register/GetRegistr?mobile=$phone'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (kDebugMode) {
        print("Response data: $data");
      }
      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Full Response: ${response.body}");
      }
      if (data.containsKey('data') && data['data'].isNotEmpty) {
        final userData = data['data'][0];
        final String relativeImageUrl = userData['userProfile'];
        if (kDebugMode) {
          print("Relative Image URL: $relativeImageUrl");
        }
        userFile = userData['userfile'] ?? "";
        name = userData['name'] ?? "";
        email = userData['Mailid'] ?? "";
        if (kDebugMode) {
          print("USERFILE$userFile");
        }
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("email", email);
        pref.setString("name", name);
        final String fullImageUrl = 'https://xpacesphere.com$relativeImageUrl';
        if (kDebugMode) {
          print("Full Image URL: $fullImageUrl");
        }
        profileProvider.setProfileImageUrl(fullImageUrl);
      } else {
        if (kDebugMode) {
          print("No user data or userProfile found in the response.");
        }
      }
    } else {
      if (kDebugMode) {
        print(
            'Failed to load profile image with status code: ${response.statusCode}');
      }
    }
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      final imageFile = File(pickedFile.path);
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
          profileProvider.setProfileImageUrl(uploadedImageUrl);
          if (kDebugMode) {
            print('Uploaded image URL: $uploadedImageUrl');
          }
        }
      }).catchError((error) {
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
        contentType:
            MediaType('image', 'jpeg'), // Set content type if necessary
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        // Read the response body
        final responseBody = await response.stream.bytesToString();
        if (kDebugMode) {
          print("Response Code: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Response Body: $responseBody");
        }

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
              title: Text(
                S.of(context).edit_profile,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            body: Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500),
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
                            labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500),
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
                            labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500),
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
                            labelStyle: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              S.of(context).cancel,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                            child: Text(S.of(context).submit,
                                style: const TextStyle(color: Colors.white)),
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
          child: SpinKitCircle(
            color: Colors.blue,
          ),
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
        SharedPreferences pref = await SharedPreferences.getInstance();
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
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (mounted) {
                            additionalPhoneController.clear();
                            emialController.clear();
                            Navigator.of(context).pop();
                            Navigator.of(context)
                                .pop(); // Close the form dialog first
                            setState(() {});
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

  void _sendWhatsAppMessage() async {
    String message = _messageController.text.trim();

    // if (message.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please enter a message!')),
    //   );
    //   return;
    // }

    // Encode the message for URL
    String encodedMessage = Uri.encodeComponent(message);
    String url = 'https://wa.me/$phoneNumber?text=$encodedMessage';

    // Launch WhatsApp or show error
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open WhatsApp!')),
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
                colors: [
                  Color(0xFFF1F8E9),
                  Color(0xFFFFFDE7),
                  Color(0xFFFBE9E7)
                ],
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
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          // Picking the file
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
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
                                builder: (_) => const Center(
                                  child: SpinKitCircle(
                                    color: Colors.blue,
                                  ),
                                ),
                              );

                              // Upload the document
                              var request = http.MultipartRequest(
                                'POST',
                                Uri.parse(
                                    'https://xpacesphere.com/api/Wherehousedt/UploadDocuments'),
                              );
                              request.fields['mobile'] = phone;
                              request.files.add(
                                  await http.MultipartFile.fromPath(
                                      'UserFile', filePath));

                              print('API Endpoint: ${request.url}');
                              print('Request Fields: ${request.fields}');
                              print('File Upload: ${filePath}');

                              var response = await request.send();

                              Navigator.of(context)
                                  .pop(); // Close the loading indicator

                              if (response.statusCode == 200) {
                                var responseBody =
                                    await response.stream.bytesToString();
                                print('Response (200): $responseBody');
                                Navigator.of(context)
                                    .pop(); // Close the loading indicator
                                Fluttertoast.showToast(
                                  msg: "Document uploaded successfully!",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              } else {
                                var errorBody =
                                    await response.stream.bytesToString();
                                print(
                                    'Error Response (${response.statusCode}): $errorBody');

                                Fluttertoast.showToast(
                                  msg:
                                      "Failed to upload document. Please try again.",
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
                        } catch (e) {
                          Navigator.of(context)
                              .pop(); // Close the loading indicator
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.blue, width: 3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            'Upload Document',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          S.of(context).cancel,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "No document uploaded",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text(S.of(context).submit,
                            style: const TextStyle(color: Colors.white)),
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
    bool launched = await launchUrl(Uri.parse(instagramUrl),
        mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Instagram app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl),
          mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication);
  }
}

// Function to launch Facebook app or web page
void _openFacebookProfile() async {
  const String facebookAppUrl = 'fb://profile/100009158840334';
  const String fallbackUrl =
      'https://www.facebook.com/profile.php?id=100009158840334';

  try {
    bool launched = await launchUrl(Uri.parse(facebookAppUrl),
        mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Facebook app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl),
          mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication);
  }
}

// Function to launch Twitter app or web page
void _openTwitterProfile() async {
  const String twitterAppUrl = 'twitter://user?screen_name=AnkeshYada78626';
  const String fallbackUrl = 'https://twitter.com/AnkeshYada78626';

  try {
    bool launched = await launchUrl(Uri.parse(twitterAppUrl),
        mode: LaunchMode.externalApplication);
    if (!launched) {
      // If Twitter app isn't installed, open in browser
      await launchUrl(Uri.parse(fallbackUrl),
          mode: LaunchMode.externalApplication);
    }
  } catch (e) {
    // In case any error occurs, open fallback URL in browser
    await launchUrl(Uri.parse(fallbackUrl),
        mode: LaunchMode.externalApplication);
  }
}
