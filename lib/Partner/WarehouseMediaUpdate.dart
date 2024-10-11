import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/Partner/models/warehousesModel.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class WarehouseMediaUpdate extends StatefulWidget {
  final Warehouse warehouse;

  const WarehouseMediaUpdate({required this.warehouse, super.key});

  @override
  State<WarehouseMediaUpdate> createState() => _WarehouseMediaUpdateState();
}

class _WarehouseMediaUpdateState extends State<WarehouseMediaUpdate> {
  int totalmedia = 0;
  int _photoCount = 0;
  int _videoCount = 0;
  double _progress = 0.0;
  final List<XFile> _pickedImages = [];
  final List<XFile> _pickedVideos = [];
  final List<String> _uploadedImages = [];
  final List<String> _uploadedVideos = [];
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    String filePath = widget.warehouse.filepath;
    processMediaFilePath(filePath);
  }

  void processMediaFilePath(String filePath) {
    List<String> filePaths = filePath.split(',');

    List<String> photos = [];
    List<String> videos = [];

    for (var path in filePaths) {
      if (path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png')) {
        photos.add(path);
      } else if (path.endsWith('.mp4') || path.endsWith('.avi') || path.endsWith('.mov')) {
        videos.add(path);
      }
    }

    setState(() {
      _uploadedImages.addAll(photos);
      _uploadedVideos.addAll(videos);
      _photoCount = photos.length;
      _videoCount = videos.length;
      totalmedia = photos.length + videos.length;
      _progress = totalmedia * 5.0;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_photoCount >= 10) return;

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          totalmedia++;
          _photoCount++;
          _pickedImages.add(pickedFile);
          _progress += 5;
        });
        print("Picked image: ${pickedFile.path}"); // Debug print
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }
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
        print("Picked video: ${pickedFile.path}"); // Debug print
      }
    } catch (e) {
      print("Error picking video: $e");
    }
  }

  Future<void> _uploadMedia(BuildContext context) async {
    if (_pickedImages.isEmpty && _pickedVideos.isEmpty && _uploadedImages.isEmpty && _uploadedVideos.isEmpty) {
      print("No media to upload.");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://xpacesphere.com/api/Wherehousedt/Upd_whousefile'),
      );

      // Add new media (picked images and videos)
      List<File> mediaFiles = [];
      mediaFiles.addAll(_pickedImages.map((xFile) => File(xFile.path)));
      mediaFiles.addAll(_pickedVideos.map((xFile) => File(xFile.path)));

      if (mediaFiles.isNotEmpty) {
        // Add picked media files to the 'Filedata' field
        for (var mediaFile in mediaFiles) {
          if (await mediaFile.exists()) {
            request.files.add(await http.MultipartFile.fromPath(
              'Filedata', // Make sure this field name matches what the API expects
              mediaFile.path,
              filename: basename(mediaFile.path),
            ));
          }
        }
      } else {
        // If no new media files are selected, you might still need to send an empty file placeholder or skip this field
        print("No new media files to upload.");
      }

      // Add already uploaded media paths (if applicable)
      if (_uploadedImages.isNotEmpty) {
        for (var imagePath in _uploadedImages) {
          request.fields['uploadedImages[]'] = imagePath; // Adjust based on your API
        }
      }

      if (_uploadedVideos.isNotEmpty) {
        for (var videoPath in _uploadedVideos) {
          request.fields['uploadedVideos[]'] = videoPath; // Adjust based on your API
        }
      }

      // Add additional required fields (like warehouse ID)
      request.fields['Id'] = widget.warehouse.id.toString();

      print("Request files count: ${request.files.length}"); // Debugging log
      print("Request fields: ${request.fields}"); // Debugging log

      var response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photos and Videos Uploaded...'),
            backgroundColor: Colors.green,
          ),
        );
        _clearAllFields();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        setState(() {
          _isUploading = false;
        });
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Upload new Vides and Photos'),
            backgroundColor: Colors.redAccent,
          ),
        );
        print("Failed to upload files: ${response.statusCode}, $responseBody");
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      print("Error uploading files: $e");
    }
  }





  // Function to generate a thumbnail for a video
  Future<Uint8List?> _generateThumbnail(String videoPath, bool isLocalFile) async {
    if (isLocalFile) {
      // For locally picked videos
      return await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128, // Set max width for the thumbnail
        quality: 75,   // Thumbnail quality
      );
    } else {
      // For videos from the server
      return await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 75,
      );
    }
  }

  // Widget to display a video thumbnail
  Widget _buildVideoThumbnail(String videoPath, bool isLocalFile) {
    return FutureBuilder<Uint8List?>(
      future: _generateThumbnail(videoPath, isLocalFile),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black26,
            ),
            child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 50),
          );
        } else if (snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.memory(snapshot.data!, fit: BoxFit.cover),
              ),
              const Icon(Icons.play_circle_filled, color: Colors.white, size: 50),
            ],
          );
        } else {
          // If there's an error generating the thumbnail, show a fallback image or icon
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.black26,
                ),
                child: const Icon(Icons.play_circle_filled, color: Colors.white, size: 50),
              ),
            ],
          );
        }
      },
    );
  }

  // Function to remove media from the lists
  void _removeMedia(String mediaType, int index) {
    setState(() {
      if (mediaType == 'Photos') {
        if (index < _uploadedImages.length) {
          // Remove from uploaded images
          _uploadedImages.removeAt(index);
          _photoCount--;
        } else {
          // Remove from picked images
          _pickedImages.removeAt(index - _uploadedImages.length);
          _photoCount--;
        }
      } else if (mediaType == 'Videos') {
        if (index < _uploadedVideos.length) {
          // Remove from uploaded videos
          _uploadedVideos.removeAt(index);
          _videoCount--;
        } else {
          // Remove from picked videos
          _pickedVideos.removeAt(index - _uploadedVideos.length);
          _videoCount--;
        }
      }
      totalmedia = _photoCount + _videoCount; // Update total media count
      _progress = totalmedia * 5.0; // Update progress based on media count
    });
  }

  // Show a dialog to manage photos or videos
  void _showMediaDialog(BuildContext context, String mediaType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Manage $mediaType'),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (mediaType == 'Photos') ...[
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1, // To make the images square
                                ),
                                itemCount: _uploadedImages.length + _pickedImages.length,
                                itemBuilder: (context, index) {
                                  if (index < _uploadedImages.length) {
                                    // Fetch images from server
                                    String imageUrl = "https://xpacesphere.com${_uploadedImages[index]}";
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.network(imageUrl, fit: BoxFit.cover),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel, color: Colors.red),
                                            onPressed: () {
                                              _removeMedia('Photos', index);
                                              Navigator.of(context).pop(); // Close the dialog to refresh
                                              _showMediaDialog(context, 'Photos'); // Reopen to refresh view
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Display picked images from gallery
                                    return Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8.0),
                                          child: Image.file(
                                            File(_pickedImages[index - _uploadedImages.length].path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel, color: Colors.red),
                                            onPressed: () {
                                              _removeMedia('Photos', index);
                                              Navigator.of(context).pop(); // Close the dialog to refresh
                                              _showMediaDialog(context, 'Photos'); // Reopen to refresh view
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                child: const Text("Add More Photos"),
                              ),
                            ] else if (mediaType == 'Videos') ...[
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                                itemCount: _uploadedVideos.length + _pickedVideos.length,
                                itemBuilder: (context, index) {
                                  if (index < _uploadedVideos.length) {
                                    // Display server video thumbnails
                                    String videoUrl = "https://xpacesphere.com" + _uploadedVideos[index];
                                    return Stack(
                                      children: [
                                        _buildVideoThumbnail(videoUrl, false),  // False for non-local files
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel, color: Colors.red),
                                            onPressed: () {
                                              _removeMedia('Videos', index);
                                              Navigator.of(context).pop(); // Close the dialog to refresh
                                              _showMediaDialog(context, 'Videos'); // Reopen to refresh view
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    // Display locally picked video thumbnails
                                    String videoPath = _pickedVideos[index - _uploadedVideos.length].path;
                                    return Stack(
                                      children: [
                                        _buildVideoThumbnail(videoPath, true),  // True for local files
                                        Positioned(
                                          top: 5,
                                          right: 5,
                                          child: IconButton(
                                            icon: const Icon(Icons.cancel, color: Colors.red),
                                            onPressed: () {
                                              _removeMedia('Videos', index);
                                              Navigator.of(context).pop(); // Close the dialog to refresh
                                              _showMediaDialog(context, 'Videos'); // Reopen to refresh view
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  _pickVideo();
                                },
                                child: const Text("Add More Videos"),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            );
          },
        );
      },
    );
  }



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
                                InkWell(
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                const Text(
                                  "Add Warehouse",
                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                const Spacer(),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: screenHeight * 0.08, left: 20),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add additional details to attract more client",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
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
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  height: 15,
                                  margin: const EdgeInsets.symmetric(horizontal: 18),
                                  child: LinearProgressIndicator(
                                    value: _progress / 100,
                                    backgroundColor: Colors.grey.shade300,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 16),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => _showMediaDialog(context, 'Photos'),
                                      child: _buildCounter('Photos', _photoCount, "Uploaded Media"),
                                    ),
                                    GestureDetector(
                                      onTap: () => _showMediaDialog(context, 'Videos'),
                                      child: _buildCounter('Videos', _videoCount, ""),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const SizedBox(height: 36),
                                _isUploading
                                    ? const SpinKitCircle(
                                  color: Colors.blue,
                                  size: 50.0,
                                )
                                    : InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6)),
                                    height: screenHeight * 0.055,
                                    width: screenWidth * 0.47,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.03),
                                    child: const Center(
                                        child: Text("Update & Next",
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ),
                                  onTap: () {
                                    _uploadMedia(context);
                                  },
                                ),
                                SizedBox(height: 30,),
                                InkWell(
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(6)),
                                    height: screenHeight * 0.04,
                                    width: screenWidth * 0.4,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.05),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Center(
                                            child: Text("Skip",
                                                style: TextStyle(
                                                    color: Colors.white))),
                                        Icon(Icons.skip_next_outlined,color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen()),
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
          ),
        ],
      ),
    );

  }

  Widget _buildCounter(String label, int count, String name) {
    return Column(
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
              bottomLeft: Radius.circular(6),
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
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
    );
  }
}
