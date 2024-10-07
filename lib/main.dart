
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Connectivity/networkService.dart';
import 'package:warehouse/MyHomePage.dart';
import 'package:warehouse/Partner/HomeScreen.dart';
import 'package:warehouse/Partner/Provider/AuthProvider.dart';
import 'package:warehouse/Partner/Provider/LocationProvider.dart';
import 'package:warehouse/Partner/Provider/warehouseProvider.dart';
import 'package:warehouse/User/UserProvider/AuthUserProvider.dart';
import 'package:warehouse/User/userHomePage.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  String name = prefs.getString('name') ?? '';
  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(), // Ensure this constructor matches your implementation
        ),
        ChangeNotifierProvider<AuthUserProvider>(
          create: (_) => AuthUserProvider(), // Ensure this constructor matches your implementation
        ),
        ChangeNotifierProvider<NetworkConnectionService>(
          create: (_) => NetworkConnectionService(), // Ensure this constructor matches your implementation
        ),
        ChangeNotifierProvider<LocationProvider>( // Add LocationProvider here
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(create: (_) => WarehouseProvider()),


      ],
      child: MyApp(
        isLoggedIn: isLoggedIn,
        name: name,
        isUserLoggedIn: isUserLoggedIn,
      ),
    ),
  );
}

class MyApp extends StatefulWidget  {
  final bool isLoggedIn;
  final bool isUserLoggedIn;
  final String name;

  const MyApp({super.key,
    required this.isLoggedIn,
    required this.name,
    required this.isUserLoggedIn,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      PermissionStatus mediaImagesPermission = await Permission.photos.request();
      PermissionStatus mediaVideosPermission = await Permission.videos.request();
      PermissionStatus cameraPermission = await Permission.camera.request();

      // print("Media Images Permission Status: $mediaImagesPermission");
      // print("Media Videos Permission Status: $mediaVideosPermission");
      // print("Camera Permission Status: $cameraPermission");

      if (mediaImagesPermission.isDenied || mediaVideosPermission.isDenied || cameraPermission.isDenied) {
        showPermissionDeniedDialog();
      } else if (mediaImagesPermission.isPermanentlyDenied || cameraPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      PermissionStatus photoPermission = await Permission.photos.request();
      PermissionStatus storagePermission = await Permission.storage.request();
      PermissionStatus cameraPermission = await Permission.camera.request();

      // print("Photo Permission Status: $photoPermission");
      // print("Storage Permission Status: $storagePermission");
      // print("Camera Permission Status: $cameraPermission");

      if (photoPermission.isDenied || cameraPermission.isDenied || storagePermission.isDenied) {
        showPermissionDeniedDialog();
      } else if (photoPermission.isPermanentlyDenied || cameraPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  void showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text("To upload photos and videos, please grant permission to access photos and the camera."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
            TextButton(
              onPressed: () {
                openAppSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      home: StreamBuilder<bool>(
        stream: Provider.of<NetworkConnectionService>(context).connectionStatusStream,
        builder: (context, snapshot) {

          // If there is an error in the stream
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }
          // If there's no internet (i.e., snapshot.data is false)
          if (snapshot.data == false) {
            return Center(
              child: Image.asset(ImageAssets.noInternet), // Show no internet connection image
            );
          }

          // If the internet connection is available (snapshot.data == true)
          return widget.isLoggedIn
              ? HomeScreen(name: widget.name)
              : widget.isUserLoggedIn
              ? userHomePage()
              : const MyHomePage();
        },
      ),
    );

  }
}



