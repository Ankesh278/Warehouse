import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Partner/HomeScreen.dart';

class WarehouseImageScreen extends StatefulWidget {
  const WarehouseImageScreen({super.key});

  @override
  State<WarehouseImageScreen> createState() => _WarehouseImageScreenState();
}

class _WarehouseImageScreenState extends State<WarehouseImageScreen> {
  int totalmedia=0;
  int _photoCount = 0;
  int _videoCount = 0;
  double _progress = 0.0;
  final List<XFile> _pickedImages = [];
  final List<XFile> _pickedVideos = [];
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  // Function to pick images
  Future<void> _pickImage(ImageSource source) async {
    if (_photoCount >= 10) return;

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          totalmedia++;
          _photoCount++;
          _pickedImages.add(pickedFile );
          _progress += 5;
        });
      }
    } catch (e) {
      // Handle errors gracefully
      print("Error picking image: $e");
    }
  }

  // Function to pick videos
  Future<void> _pickVideo() async {
    if (_videoCount >= 10) return;
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          totalmedia++;
          _videoCount++;
          _pickedVideos.add(pickedFile);
          _progress += 5;
        });
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }
  // Function to upload files to server
  Future<void> _uploadMedia(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone")!;
    if (phone.startsWith("+91")) {
      phone = phone.replaceFirst("+91", "");
    }

    if (_pickedImages.isEmpty && _pickedVideos.isEmpty) return;

    setState(() {
      _isUploading = true; // Show progress indicator
    });

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://xpacesphere.com/api/Wherehousedt/Ins_whousefiledetails'),
      );

      // Combine images and videos into a single list
      List<File> mediaFiles = [];
      // Convert XFile (from image picker) to File
      mediaFiles.addAll(_pickedImages.map((xFile) => File(xFile.path)));
      mediaFiles.addAll(_pickedVideos.map((xFile) => File(xFile.path)));

      // Attach all media files to the request under 'fileUpload'
      for (int i = 0; i < mediaFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'Filedata',
          mediaFiles[i].path,
          filename: basename(mediaFiles[i].path),
        ));
      }

      // Add the mobile number as form data
      request.fields['mobile'] = phone;

      // Send the request to the server
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        setState(() {
          _isUploading = false;
        });
        print("Files uploaded successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photos and Videos Uploaded...'),
            backgroundColor: Colors.green,
          ),
        );
        _clearAllFields(); // Clear fields after successful upload
        // Navigate to the Home Screen and remove back stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()), // Replace HomeScreen() with your actual HomeScreen widget
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } else {
        setState(() {
          _isUploading = false;
        });
        print("Failed to upload files: ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading files: $e");
    } finally {
      setState(() {
        _isUploading = false; // Hide progress indicator after upload
      });
    }
  }



  // Function to clear all fields after upload
  void _clearAllFields() {
    setState(() {
      totalmedia = 0;
      _photoCount = 0;
      _videoCount = 0;
      _progress = 0.0;
      _pickedImages.clear();
      _pickedVideos.clear();
    });
  }



  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              width: double.infinity,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      color: Colors.blue,
                      height: screenHeight * 0.18,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: screenHeight * 0.025,
                          left: screenWidth * 0.025,
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(child: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
                                          onTap: (){
                                            Navigator.pop(context);
                                          },
                                        ),
                                        const Text("Add Warehouse",style: TextStyle(color: Colors.white,fontSize: 14),)
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: screenHeight*0.08,left: 20),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add additional details to attract more client",
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal, color: Colors.white),
                                  ),


                                ],
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
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Warehouse Images $totalmedia/20',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.blue),
                                ),
                                const SizedBox(height: 16),

                                // Linear progress bar with increased width
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(horizontal: 18),
                                  child: LinearProgressIndicator(
                                    value: _progress,
                                    borderRadius: BorderRadius.circular(10),
                                    backgroundColor: Colors.grey[200],
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                  ),
                                ),


                                const SizedBox(height: 16),
                                Container(
                                    margin: EdgeInsets.only(right: screenWidth*0.4),
                                    child: const Text("Add files",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),)),
                                const SizedBox(height: 10),

                                // Circle Avatars for upload buttons with increased size
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => _pickImage(ImageSource.gallery),
                                      child: Image.asset("assets/images/addphotos.png"),
                                    ),
                                    GestureDetector(
                                      onTap: _pickVideo,
                                      child: Image.asset("assets/images/addvideo.png"),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                // Counters for photos and videos
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    _buildCounter('Photos ', _photoCount,"Uploaded Media"),
                                    _buildCounter('Videos ', _videoCount,""),
                                  ],
                                ),

                                const SizedBox(height: 16),
                                _isUploading?SpinKitCircle(
                                  color: Colors.blue,
                                  size: 50.0,
                                ):

                              InkWell(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.circular(6)
                                      ),
                                      height: screenHeight * 0.055, // Adjusted for responsiveness
                                      width: screenWidth * 0.47, // Adjusted for responsiveness
                                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Adjusted for responsiveness
                                      child: const Center(child: Text("Save & Next",style: TextStyle(color: Colors.white),))
                                  ),
                                  onTap: (){
                                    _uploadMedia(context);

                                  },
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start, // Aligns image and text at the top
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Image.asset(
                                        "assets/images/InfoPopup.png",
                                        height: 13,
                                        width: 15,
                                        color: Colors.red,
                                      ),
                                    ), // Adds space between the image and text
                                    const Flexible(
                                      child: Text(
                                        "Upload Warehouse Image Only and Please Ensure Clarity and Proper Lighting",
                                        maxLines: 2, // Limits the text to two lines
                                        overflow: TextOverflow.visible, // Ensures text wraps without truncation
                                        style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),


                                //Row with three images of equal size
                                SizedBox(
                                  height: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          child: Image.asset(
                                            "assets/images/demoimage1.png",
                                            fit: BoxFit.contain, // Adjust the image to fit within the container
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          child: Image.asset(
                                            "assets/images/demoimage2.png",
                                            fit: BoxFit.contain, // Adjust the image to fit within the container
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 3),
                                          child: Image.asset(
                                            "assets/images/demoimage3.png",
                                            fit: BoxFit.contain, // Adjust the image to fit within the container
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

Widget _buildCounter(String label, int count,String name) {
  return Column(
    children: <Widget>[
      Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400,color: Colors.grey)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.blue),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6),bottomRight: Radius.circular(6),bottomLeft: Radius.circular(6)),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                '$count',
                style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.grey),
              ),
              Text(label,style: const TextStyle(fontWeight: FontWeight.w400,color: Colors.grey),)
            ],
          ),
        ),
      ),
    ],
  );
}
























