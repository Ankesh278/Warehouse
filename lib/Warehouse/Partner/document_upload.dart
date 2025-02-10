
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warehouse/Warehouse/User/UserProvider/DocumentProvider.dart';
import 'package:http/http.dart' as http;

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => DocumentUploadState();
}

class DocumentUploadState extends State<DocumentUpload> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cityController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  late final String? phone;
  late final String? name;
  List<dynamic> _placeSuggestions = [];
  bool _isUserSelection = false;
@override
  void initState() {
    super.initState();
    getSharedData();
    _cityController.addListener(() {
      if (!_isUserSelection) {
        _onSearchChanged(_cityController.text);
      }
    });
  }

  void getSharedData() async{
  SharedPreferences pref= await SharedPreferences.getInstance();
  phone=pref.getString("phone");
  name=pref.getString("name");
  if (kDebugMode) {
    print("Phone${phone!}");
  }
  _phoneController.text=phone??"";
  _nameController.text=name??"";
  }
  void _onSearchChanged(String input) async {
    print("User input: $input"); // Debugging input value
    if (input.isNotEmpty) {
      try {
        final suggestions = await fetchPlaceSuggestions(input);
        print("Fetched suggestions: $suggestions"); // Log API response data
        setState(() {
          _placeSuggestions = suggestions;
        });
      } catch (e) {
        print("Error fetching suggestions: $e"); // Error log
      }
    } else {
      setState(() {
        _placeSuggestions = [];
      });
    }
  }

  Future<List> fetchPlaceSuggestions(String input) async {
    const String apiKey = "AIzaSyDxbkZhKCXDGPdtOWxTPxFBg_tjAd3jsTk";
    const String baseUrl =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    final requestUrl = "$baseUrl?input=$input&key=$apiKey&components=country:in";

    print("Request URL: $requestUrl"); // Debugging the API request URL

    try {
      final response = await http.get(Uri.parse(requestUrl));
      print("API Response Code: ${response.statusCode}"); // Log response code

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("API Response Body: ${response.body}"); // Log response body
        return data['predictions'] ?? [];
      } else {
        print(
            "Failed to fetch suggestions. Status Code: ${response.statusCode}"); // Log if response code is not 200
        throw Exception("Failed to fetch suggestions");
      }
    } catch (e) {
      print("Exception during API call: $e"); // Log any exceptions
      return [];
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final providerPhoto = Provider.of<PhotoProvider>(context);
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
                      height: screenHeight * 0.13,
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
                                         SizedBox(width: screenWidth*0.04,),
                                        const Text("Complete KYC",style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),)
                                      ],
                                    )
                                  ],
                                ),

                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: screenWidth * 0.005),
                        decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(screenWidth*0.1),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal:screenWidth * 0.08,vertical: screenHeight*0.03),
                          child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    SizedBox(height: screenHeight*0.006,),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Name',
                                        enabled: false,
                                        labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(screenWidth*0.1),
                                          borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.blue,width: 1.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    TextFormField(
                                      maxLength: 10,
                                      enabled: false,
                                      controller: _phoneController,
                                      decoration: InputDecoration(
                                        labelText: 'Mobile No.',
                                        labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.blue,width: 1.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your Mobile No.';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    TextFormField(
                                      controller: _cityController,
                                      decoration: InputDecoration(
                                        labelText: 'City',
                                        labelStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.grey,width: 1.5),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(30.0),
                                          borderSide: const BorderSide(color: Colors.blue,width: 1.5),
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter city';
                                        }
                                        return null;
                                      },
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 20.0),
                                    //   child: TextField(
                                    //     controller: _controller,
                                    //     decoration: InputDecoration(
                                    //       hintText: 'Enter a location',
                                    //       label: Text(
                                    //         S.of(context).location,
                                    //         style: TextStyle(
                                    //           color: Colors.black,
                                    //           fontSize: 14,
                                    //           fontWeight: FontWeight.w600,
                                    //         ),
                                    //       ),
                                    //       hintStyle: TextStyle(
                                    //         color: Colors.grey,
                                    //         fontSize: 10,
                                    //       ),
                                    //       filled: true,
                                    //       fillColor: Colors.white,
                                    //       contentPadding: EdgeInsets.symmetric(
                                    //           vertical: 10, horizontal: 10),
                                    //       border: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(5),
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey, width: 1.0),
                                    //       ),
                                    //       enabledBorder: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(5),
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey, width: 1.0),
                                    //       ),
                                    //       focusedBorder: OutlineInputBorder(
                                    //         borderRadius: BorderRadius.circular(5),
                                    //         borderSide: BorderSide(
                                    //             color: Colors.grey, width: 1.0),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(height: 20),

                                    // Display Suggestions
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: _placeSuggestions.length,
                                      itemBuilder: (context, index) {
                                        final suggestion =
                                        _placeSuggestions[index];
                                        return ListTile(
                                          title: Text(
                                            suggestion['description'] ?? '',
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _isUserSelection = true; // Prevent listener
                                              _cityController.text =
                                                  suggestion['description'] ?? '';
                                              _placeSuggestions = [];
                                            });
                                            Future.delayed(Duration(milliseconds: 300), () {
                                              _isUserSelection = false; // Re-enable listener
                                            });
                                            print(
                                                "Selected Place: ${suggestion['description']}"); // Log selected place
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    Consumer<PhotoProvider>(builder: (context,photoProvider,child){
                                      return Container(
                                        height: screenHeight*0.07,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(color: photoProvider.arepancardPhotosUploaded?Colors.green:Colors.grey,width: 2)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            photoProvider.arepancardPhotosUploaded?Container():Container(
                                              height: double.infinity,
                                              width: screenWidth*0.3,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.grey,width: 1)
                                              ),
                                              child: GestureDetector(
                                                onTap: ()=>showCameraDialog(context),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.camera_alt,color: Colors.blue,),
                                                    SizedBox(width: screenWidth*0.02,),
                                                    const Text("Upload",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 16),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            photoProvider.arepancardPhotosUploaded?const Text("Pan Card Uploaded*",style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.w600),):const Text("Owner PAN CARD*",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                            SizedBox(width: screenWidth*0.1,)
                                          ],
                                        ),
                                      );
                                    }),
                                    SizedBox(height: screenHeight*0.02,),
                                    Consumer<PhotoProvider>(builder: (context,photoprovider,child){
                                      return Container(
                                        height: screenHeight*0.07,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(color: photoprovider.areselfiePhotosUploaded?Colors.green:Colors.grey,width: 2)
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            photoprovider.areselfiePhotosUploaded?Container():Container(
                                              height: double.infinity,
                                              width: screenWidth*0.3,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(7),
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.grey,width: 1)
                                              ),
                                              child: GestureDetector(
                                                onTap: ()=>showSelfieCameraDialog(context),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.camera_alt,color: Colors.blue,),
                                                    SizedBox(width: screenWidth*0.02,),
                                                    const Text("Upload",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.w600,fontSize: 16),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                            photoprovider.areselfiePhotosUploaded?const Text("Selfie Uploaded*",style: TextStyle(color: Colors.green,fontSize: 16,fontWeight: FontWeight.w600),):const Text("Selfie Of Owner*",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                                            SizedBox(width: screenWidth*0.1,)
                                          ],
                                        ),
                                      );
                                    }),
                                    SizedBox(height: screenHeight*0.02,),
                                    Consumer<PhotoProvider>(
                                      builder: (context, aadharPhotoProvider, child) {
                                        bool areBothUploaded = aadharPhotoProvider.areFrontAadharUploaded && aadharPhotoProvider.areBackAadharUploaded;
                                        return Container(
                                          height: screenHeight * 0.2,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.white,
                                            border: Border.all(
                                              color: areBothUploaded ? Colors.green : Colors.grey,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Front Photo
                                              _photoUploadSection(
                                                context,
                                                aadharPhotoProvider.aadharPhotoFront,
                                                "Upload Front Side",
                                                    () {
                                                  // Disable click if both photos are uploaded
                                                  if (!areBothUploaded) {
                                                    _pickAadharPhoto(context, ImageSource.gallery, isFront: true);
                                                  }
                                                },
                                                isClickable: !areBothUploaded, // Disable if both are uploaded
                                              ),
                                               SizedBox(height: screenHeight*0.013),
                                              // Back Photo
                                              _photoUploadSection(
                                                context,
                                                aadharPhotoProvider.aadharPhotoBack,
                                                "Upload Back Side",
                                                    () {
                                                  // Disable click if both photos are uploaded
                                                  if (!areBothUploaded) {
                                                    _pickAadharPhoto(context, ImageSource.gallery, isFront: false);
                                                  }
                                                },
                                                isClickable: !areBothUploaded, // Disable if both are uploaded
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: screenHeight*0.04,),
                                    ElevatedButton(
                                      onPressed: (){
                                        providerPhoto.uploadPhotos(phone!);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0), // Circular border radius
                                          side: const BorderSide(color: Colors.grey), // Border color
                                        ),
                                        elevation: 5, // Shadow effect
                                        shadowColor: Colors.black.withOpacity(0.2), // Shadow color
                                        padding:  EdgeInsets.symmetric(vertical: screenHeight*0.01, horizontal: screenWidth*0.1), // Button padding
                                        minimumSize: Size(screenWidth*0.85, screenWidth*0.1), // Button size
                                      ),
                                      child: const Text(
                                        "Upload",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )

                                  ]
                                )
                              )
                          )
                        )
                      )
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }

  Future<void> _pickSelfiePhotoGallery(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      bool isConfirmed = await _showImagePreviewDialog(context, file);
      if (isConfirmed) {
        Provider.of<PhotoProvider>(context, listen: false).selfieOfOwnerPhotoUpdate(file);
      }
    }
  }
  Future<void> _pickPhotoGallery(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      bool isConfirmed = await _showImagePreviewDialog(context, file);
      if (isConfirmed) {
        Provider.of<PhotoProvider>(context, listen: false).updatePanPhoto(file);
      }
    }
  }
  void showCameraDialog(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (ctx)=>Container(
          height: screenHeight*0.15,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenWidth*0.2)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             ListTile(
               onTap: (){
                 _pickPhotoGallery(context,ImageSource.gallery);
                 Navigator.of(ctx).pop();
               },
               title: const Text("Choose from Gallery",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 17),),
               trailing: const Icon(Icons.photo_camera_back,color: Colors.grey,size: 35,),
             ),
              Container(
                height: 2,
                width: screenWidth,
                color: Colors.grey,
              ),
              ListTile(
                onTap: (){
                  _pickPhotoGallery(context,ImageSource.camera);
                  Navigator.of(ctx).pop();
                },
                title: const Text("Capture from Camera",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 17),),
                trailing: const Icon(Icons.camera_alt,color: Colors.grey,size: 35,),
              )
            ],
          ),
        )
    );
  }
  void showSelfieCameraDialog(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    showModalBottomSheet(
        context: context,
        builder: (ctx)=>Container(
          height: screenHeight*0.15,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(screenWidth*0.5)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                onTap: (){
                  _pickSelfiePhotoGallery(context,ImageSource.gallery);
                  Navigator.of(ctx).pop();
                },
                title: const Text("Choose from Gallery",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 17),),
                trailing: const Icon(Icons.photo_camera_back,color: Colors.grey,size: 35,),
              ),
              Container(
                height: 2,
                width: screenWidth,
                color: Colors.grey,
              ),
              ListTile(
                onTap: (){
                  _pickSelfiePhotoGallery(context,ImageSource.camera);
                  Navigator.of(ctx).pop();
                },
                title: const Text("Capture from Camera",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w600,fontSize: 17),),
                trailing: const Icon(Icons.camera_alt,color: Colors.grey,size: 35,),
              )
            ],
          ),
        )
    );
  }
  Future<bool> _showImagePreviewDialog(BuildContext context, File imageFile) async {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth*0.05),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Image Preview',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth*0.05),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(screenWidth*0.05),
                child: Image.file(
                  imageFile,
                  height: screenHeight*0.3,
                  fit: BoxFit.cover,
                ),
              ),
            ),
             SizedBox(height: screenHeight*0.03),
            const Text(
              'Are you sure you want to use this photo?',
              style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    ) ?? false;
  }


  Widget _photoUploadSection(
      BuildContext context, File? photo, String label, VoidCallback onTap, {bool isClickable = true}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: isClickable ? onTap : null, // Disable tap when not clickable
      child: Container(
        height: screenHeight * 0.078,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenWidth * 0.02), // Outer border radius
          color: Colors.white,
          border: Border.all(color: photo != null ? Colors.green : Colors.grey, width: 1),
        ),
        child: photo != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(screenWidth * 0.02), // Inner circular border for photo
          child: Image.file(photo, fit: BoxFit.cover),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, color: isClickable ? Colors.blue : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isClickable ? Colors.blue : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickAadharPhoto(BuildContext context, ImageSource source, {required bool isFront}) async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      // Show preview dialog
      bool isConfirmed = await _showImagePreviewDialog(context, file);

      if (isConfirmed) {
        final provider = Provider.of<PhotoProvider>(context, listen: false);

        if (isFront) {
          provider.aadharCardPhotoFront(file);
        } else {
          provider.aadharCardPhotoback(file);
        }
      }
    }
  }
  void showAadharCameraDialog(BuildContext context, {required bool isFront}) {
    final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        height: screenHeight*0.2,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                _pickAadharPhoto(context, ImageSource.gallery, isFront: isFront);
                Navigator.of(ctx).pop();
              },
              title: const Text("Choose from Gallery"),
              trailing: const Icon(Icons.photo_library, size: 30),
            ),
            ListTile(
              onTap: () {
                _pickAadharPhoto(context, ImageSource.camera, isFront: isFront);
                Navigator.of(ctx).pop();
              },
              title: const Text("Capture from Camera"),
              trailing: const Icon(Icons.camera_alt, size: 30),
            ),
          ],
        ),
      ),
    );
  }
}


























