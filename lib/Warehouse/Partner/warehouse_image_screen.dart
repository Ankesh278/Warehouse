import 'dart:convert';
import 'dart:io';
import 'package:Lisofy/Warehouse/Partner/amenities_warehouse.dart';
import 'package:Lisofy/Warehouse/Partner/media_picker_screen.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WarehouseImageScreen extends StatefulWidget {
  const WarehouseImageScreen({super.key});
  @override
  State<WarehouseImageScreen> createState() => _WarehouseImageScreenState();
}
class _WarehouseImageScreenState extends State<WarehouseImageScreen> {
  int totalMedia = 0;
  int _photoCount = 0;
  int _videoCount = 0;
  late int warehouseId;
  double _progress = 0.0;
  late int id;
  late List<XFile> _pickedImages = [];
  late List<XFile> _pickedVideos = [];
  bool _isUploading = false;
  Future<void> _uploadMedia(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone")!;
    if (phone.startsWith("+91")) {
      phone = phone.replaceFirst("+91", "");
    }
    if (_pickedImages.isEmpty && _pickedVideos.isEmpty) return;
    setState(() {
      _isUploading = true;
    });
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'https://xpacesphere.com/api/Wherehousedt/Ins_whousefiledetails'),
      );
      if (kDebugMode) {
        print("Response:  $request");
      }
      List<File> mediaFiles = [];
      mediaFiles.addAll(_pickedImages.map((xFile) => File(xFile.path)));
      mediaFiles.addAll(_pickedVideos.map((xFile) => File(xFile.path)));
      if (kDebugMode) {
        print("Number of media files: ${mediaFiles.length}");
      }
      for (int i = 0; i < mediaFiles.length; i++) {
        if (kDebugMode) {
          print("Uploading file ${i + 1}: ${mediaFiles[i].path}");
        }
        request.files.add(await http.MultipartFile.fromPath(
          'Filedata',
          mediaFiles[i].path,
          filename: basename(mediaFiles[i].path),
        ));
      }

      request.fields['Id'] = id.toString();
      if (kDebugMode) {
        print(("Url>>>${request.url}"));
      }

      if (kDebugMode) {
        print("Form fields: mobile=$phone, Id=$id");
      }

      var response = await request.send();
      if (kDebugMode) {
        print("Files response$response");
      }
      if (response.statusCode == 200) {
        setState(() {
          _isUploading = false;
        });
        if (kDebugMode) {
          print("Files uploaded successfully!");
        }
        String responseString = await response.stream.bytesToString();
        if (kDebugMode) {
          print("Response body: $responseString");
        }
        if (!mounted) return;
        Future.microtask(() {
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AmenitiesWarehouse(id: id)),
            );
          }
        });

        try {
          var responseJson = jsonDecode(responseString);
          String message = responseJson['message'];
          int code = responseJson['status'];
          if (kDebugMode) {
            print("Message: $message");
          }
          if (kDebugMode) {
            print("Status: $code");
          }
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing response JSON: $e");
          }
        }
        if (!mounted) return;
        Future.microtask(() {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photos and Videos Uploaded...'),
                backgroundColor: Colors.green,
              ),
            );
          }
        });
        _clearAllFields();
        if (!mounted) return;
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => AmenitiesWarehouse(id: id)),
                  (Route<dynamic> route) => false,
            );
          }
        });
      } else {
        setState(() {
          _isUploading = false;
        });
        if (kDebugMode) {
          print("Failed to upload files: ${response.statusCode}");
        }
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      if (kDebugMode) {
        print("Error uploading files: $e");
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      totalMedia = 0;
      _photoCount = 0;
      _videoCount = 0;
      _progress = 0.0; 
      _pickedImages.clear();
      _pickedVideos.clear();
    });
  }
  @override
  void initState() {
    super.initState();
    getId();
  }

  Future<String?> getId() async {
    String apiUrl = "http://xpacesphere.com/api/Wherehousedt/GetWarehouseId";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString("phone")!;

    if (phone.startsWith("+91")) {
      phone = phone.replaceFirst("+91", "");
    }
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?mobile=$phone'),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        id = jsonResponse['id'];
        prefs.setString("id", id.toString());
        if (kDebugMode) {
          print("Iddddd: ${id.toString()}");
        }
        return id.toString();
      } else {
        if (kDebugMode) {
          print('Failed to load data. Status code: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      return null;
    }
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
                                        InkWell(
                                          child: const Icon(
                                            Icons.arrow_back_ios_new,
                                            color: Colors.white,
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                         Text(
                                          S.of(context).add_warehouse,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                const SizedBox(width: 5),
                              ],
                            ),
                            SingleChildScrollView(
                             scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: screenHeight * 0.08, left: 15),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      S.of(context).add_additional_details,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                  ],
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
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '${S.of(context).warehouse_images} $totalMedia/20',
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                height: 15,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: LinearProgressIndicator(
                                  value: _progress/100,
                                  borderRadius: BorderRadius.circular(10),
                                  backgroundColor: Colors.grey[200],
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          Colors.blue),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                  margin:
                                      EdgeInsets.only(right: screenWidth * 0.4),
                                  child:  Text(
                                    S.of(context).add_files,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600),
                                  )),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // Add Photos
                                  GestureDetector(
                                    onTap: () async {
                                      final List<XFile>? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MediaPickerPage(
                                            isImagePicker: true,
                                            initialMedia: _pickedImages,
                                          ),
                                        ),
                                      );
                                      if (result != null && result.isNotEmpty) {
                                        setState(() {
                                          _pickedImages = result;
                                          _photoCount = _pickedImages.length;
                                          totalMedia = _pickedImages.length + _pickedVideos.length;
                                          _progress = (5.0 * totalMedia);
                                        });
                                      }
                                    },
                                    child: Image.asset("assets/images/addphotos.png"),
                                  ),
                                  // Add Videos
                                  GestureDetector(
                                    onTap: () async {
                                      final List<XFile>? result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MediaPickerPage(
                                            isImagePicker: false,
                                            initialMedia: _pickedVideos,
                                          ),
                                        ),
                                      );
                                      if (result != null && result.isNotEmpty) {
                                        setState(() {
                                          _pickedVideos = result;
                                          _videoCount = _pickedVideos.length;
                                          totalMedia = _pickedImages.length + _pickedVideos.length;
                                          _progress = (totalMedia / (totalMedia + 20)).clamp(0.0, 1.0);
                                        });
                                        if (kDebugMode) {
                                          print("Selected Videos: ${result.length}");
                                        }
                                      }
                                    },
                                    child: Image.asset("assets/images/addvideo.png"),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  _buildCounter(
                                      S.of(context).photos, _photoCount, S.of(context).uploaded_media),
                                  _buildCounter('${S.of(context).videos} ', _videoCount, ""),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _isUploading
                                  ? const SpinKitCircle(
                                      color: Colors.blue,
                                      size: 50.0,
                                    )
                                  : InkWell(
                                      child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          height: screenHeight * 0.055,
                                          width: screenWidth * 0.47,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.03),
                                          child:  Center(
                                              child: Text(
                                                S.of(context).save_next,
                                            style:
                                                const TextStyle(color: Colors.white),
                                          ))),
                                      onTap: () {
                                        _uploadMedia(context);
                                      },
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Image.asset(
                                      "assets/images/InfoPopup.png",
                                      height: 13,
                                      width: 15,
                                      color: Colors.red,
                                    ),
                                  ),
                                   Flexible(
                                    child: Text(
                                      S.of(context).upload_warehouse_image,
                                      maxLines: 2,
                                      overflow: TextOverflow.visible,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Image.asset(
                                          "assets/images/demoimage1.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Image.asset(
                                          "assets/images/demoimage2.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 3),
                                        child: Image.asset(
                                          "assets/images/demoimage3.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
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

Widget _buildCounter(String label, int count, String name) {
  return GestureDetector(
    onTap: (){
    },
    child: Column(
      children: <Widget>[
        Text(name,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            border: Border.all(color: Colors.blue),
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
                bottomLeft: Radius.circular(6)),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400, color: Colors.grey),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

























