
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Connectivity/networkService.dart';
import 'package:warehouse/Localization/Languages.dart';
import 'package:warehouse/Partner/Provider/AuthProvider.dart';
import 'package:warehouse/Partner/Provider/LocationProvider.dart';
import 'package:warehouse/Partner/Provider/warehouseProvider.dart';
import 'package:warehouse/User/UserProvider/AuthUserProvider.dart';
import 'package:warehouse/User/UserProvider/FilterProvider.dart';
import 'package:warehouse/User/UserProvider/photoProvider.dart';
import 'package:warehouse/User/UserProvider/sortingProvider.dart';
import 'package:warehouse/User/userlogin.dart';
import 'package:warehouse/generated/l10n.dart';
import 'package:warehouse/newHomePage.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Lock the app in portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  String name = prefs.getString('name') ?? '';
  double latitude = prefs.getDouble('latitude') ?? 0.00;
  double longitude = prefs.getDouble('longitude') ?? 0.00;
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
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => SortingProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),



      ],

      child: MyApp(
        isLoggedIn: isLoggedIn,
        name: name,
        isUserLoggedIn: isUserLoggedIn,
        latitude: latitude,
        longitude: longitude,
      ),
    ),
  );
}

class MyApp extends StatefulWidget  {
  final bool isLoggedIn;
  final bool isUserLoggedIn;
  final String name;
  final double longitude;
  final double latitude;

  const MyApp({super.key,
    required this.isLoggedIn,
    required this.name,
    required this.isUserLoggedIn,
    required this.longitude,
    required this.latitude

  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermissions();
    });
  }

  Future<void> requestPermissions() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt >= 33) {
      PermissionStatus mediaImagesPermission = await Permission.photos.request();
      PermissionStatus mediaVideosPermission = await Permission.videos.request();
      PermissionStatus cameraPermission = await Permission.camera.request();

      if (mediaImagesPermission.isDenied || mediaVideosPermission.isDenied || cameraPermission.isDenied) {
        _showPermissionDeniedDialog();
      } else if (mediaImagesPermission.isPermanentlyDenied || cameraPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    } else {
      PermissionStatus photoPermission = await Permission.photos.request();
      PermissionStatus storagePermission = await Permission.storage.request();
      PermissionStatus cameraPermission = await Permission.camera.request();

      if (photoPermission.isDenied || cameraPermission.isDenied || storagePermission.isDenied) {
        _showPermissionDeniedDialog();
      } else if (photoPermission.isPermanentlyDenied || cameraPermission.isPermanentlyDenied) {
        openAppSettings();
      }
    }
  }

  void _showPermissionDeniedDialog() {
    // Use context safely here because it's inside the widget tree
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
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: languageProvider.locale,
          localizationsDelegates: const [
            S.delegate, // Add the localization delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English
            Locale('hi', ''), // Hindi
            Locale('bn', ''), // Bengali
            Locale('kn', ''), // Kannada
            Locale('mr', ''), // Marathi
            Locale('ml', ''), // Malayalam
            Locale('te', ''), // Telugu
            Locale('ta', ''), // Tamil
            // Add more locales as needed
          ],
          home: Scaffold( // Ensure that the StreamBuilder is within a Scaffold
            body: StreamBuilder<bool>(
              stream: Provider
                  .of<NetworkConnectionService>(context)
                  .connectionStatusStream,
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
                    child: Image.asset(ImageAssets
                        .noInternet), // Show no internet connection image
                  );
                }

                // If the internet connection is available (snapshot.data == true)
                return widget.isUserLoggedIn
                    ? newHomePage(latitude:widget.latitude,longitude:widget.longitude)
                    : userlogin();
              },
            ),
          ),
        );

      }
    );
  }

}



