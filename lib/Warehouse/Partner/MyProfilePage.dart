import 'package:Lisofy/Warehouse/User/userlogin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';




class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
      await prefs.remove('userEmail');
      await prefs.remove('userName');
      await prefs.setBool('isLoggedIn', false);

      // Navigate to the Login Page and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) =>  userlogin()), // Replace with your login page
            (route) => false,
      );
    } catch (e) {
      print("Error during logout: $e");
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

  String name="";
  String phone="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShareData();
  }
  getShareData() async {
    SharedPreferences pref=await SharedPreferences.getInstance();
    name=pref.getString("name")!;
    phone=pref.getString("phone")!;

    // Use setState to update the UI after data is loaded
    setState(() {
      name = name  ?? 'Unknown User'; // Set a default value if null
      phone = phone ?? 'No Phone';
    });

    print("name::::::"+name);
    print("[phone]::::::"+phone);

  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                          "My Profile",
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
                            padding: EdgeInsets.all(screenWidth * 0.06),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: screenHeight*0.14,),
                                  InkWell(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                          const Text(
                                            "Call for Assistance",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                    onTap: () async{
                                      final call = Uri.parse('tel:+91 7007221530');
                                      if (await canLaunchUrl(call)) {
                                        launchUrl(call);
                                      } else {
                                        throw 'Could not launch $call';
                                      }
                                    },
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 13.0,top: 10),
                                    child: Text("Account",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )


                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 13.0,top: 10,bottom: 10),
                                    child: Text("General",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                          child: Icon(Icons.punch_clock_outlined,color: Colors.grey,),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "Change Password",
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.02,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 13.0,top: 10,bottom: 10),
                                    child: Text("General",style: TextStyle(fontWeight: FontWeight.w600),),


                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 13),
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
                                            child:  Icon(Icons.arrow_forward_ios,size: 14,color: Colors.grey,),
                                          ),
                                        )



                                      ],
                                    ),
                                  ),
                                  SizedBox(height: screenHeight*0.03,),
                                Center(
                                  child: InkWell(
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 13.0, top: 10, bottom: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.logout_rounded, color: Colors.red),
                                          SizedBox(width: 10),
                                          Text(
                                            "Log out",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.red, // Red text for logout
                                            ),
                                          ),
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
                                      padding: const EdgeInsets.only(left: 13.0,top: 0,bottom: 0),
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
                                          onTap: _openFacebookProfile,
                                          ),
                                          const SizedBox(width: 15,),
                                          InkWell(child: Image.asset("assets/images/Instagram.png"),
                                          onTap: _openInstagramProfile,
                                          ),
                                          const SizedBox(width: 15,),
                                          InkWell(child: Image.asset("assets/images/TwitterX.png"),
                                          onTap: _openTwitterProfile,
                                          )

                                        ],
                                      )


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
            top: screenHeight * 0.15, // Adjust this to move the container vertically
            left: screenWidth / 2 - 125, // Center the container horizontally
            child: Container(
              height: 190,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade600,
                      spreadRadius: 1,
                      blurRadius: 15
                  )
                ],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white)
              ),
              child: Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
               // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    name.length > 10 ? '${name.substring(0, 10)}...' : name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  // SizedBox(height: 10,),
                   Padding(
                    padding: const EdgeInsets.only(bottom: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_calling_3_outlined,color: Colors.blue,),
                        const SizedBox(width: 15,),
                        Text(
                          phone.length > 13 ? '${phone.substring(0, 13)}...' : phone,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15,left: 13,right: 13),
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.blue)
                      ),
                      child: const Center(child: Text("Edit Profile",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w400,fontSize: 14),)),
                    ),
                  )
                ],
              ),
            )
          ),
          Positioned(
              top: screenHeight * 0.08, // Adjust this to move the container vertically
              left: screenWidth / 2 - 45, // Center the container horizontally
              child: Image.asset("assets/images/userround.png")
          ),
        ],
      ),
    );
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
}
