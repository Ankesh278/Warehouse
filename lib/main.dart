import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:warehouse/Connectivity/networkService.dart';
import 'package:warehouse/Localization/Languages.dart';
import 'package:warehouse/Partner/Provider/AuthProvider.dart';
import 'package:warehouse/Partner/Provider/LocationProvider.dart';
import 'package:warehouse/Partner/Provider/warehouseProvider.dart';
import 'package:warehouse/User/NotificationSetting.dart';
import 'package:warehouse/User/UserProvider/AuthUserProvider.dart';
import 'package:warehouse/User/UserProvider/FilterProvider.dart';
import 'package:warehouse/User/UserProvider/photoProvider.dart';
import 'package:warehouse/User/UserProvider/sortingProvider.dart';
import 'package:warehouse/User/userlogin.dart';
import 'package:warehouse/generated/l10n.dart';
import 'package:warehouse/newHomePage.dart';
import 'package:warehouse/resources/ImageAssets/ImagesAssets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle background notifications here
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Android-specific initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Create notification channel for Android 8 and above (API level 26+)
  await _createNotificationChannel();

  // Lock the app in portrait mode
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;
  String name = prefs.getString('name') ?? '';
  double latitude = prefs.getDouble('latitude') ?? 0.00;
  double longitude = prefs.getDouble('longitude') ?? 0.00;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AuthUserProvider>(create: (_) => AuthUserProvider()),
        ChangeNotifierProvider<NetworkConnectionService>(create: (_) => NetworkConnectionService()),
        ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
        ChangeNotifierProvider<WarehouseProvider>(create: (_) => WarehouseProvider()),
        ChangeNotifierProvider<LanguageProvider>(create: (_) => LanguageProvider()),
        ChangeNotifierProvider<SortingProvider>(create: (_) => SortingProvider()),
        ChangeNotifierProvider<FilterProvider>(create: (_) => FilterProvider()),
        ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
        ChangeNotifierProvider<NotificationSettingsProvider>(create: (_) => NotificationSettingsProvider()),
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

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isUserLoggedIn;
  final String name;
  final double longitude;
  final double latitude;

  const MyApp({
    Key? key,
    required this.isLoggedIn,
    required this.name,
    required this.isUserLoggedIn,
    required this.longitude,
    required this.latitude,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestPermissions();
    });

    FirebaseMessaging.instance.getToken().then((token) {

      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'general_notifications', // Channel ID
              'General Notifications', // Channel Name
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.messageId}");
    });
  }


  Future<void> requestPermissions() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    // Request Notification Permission
    PermissionStatus notificationPermission = await Permission.notification.request();

    if (notificationPermission.isDenied || notificationPermission.isPermanentlyDenied) {
      _showNotificationPermissionDialog();
    }

    // Additional Permissions for Media and Camera
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

  void _showNotificationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Notification Permission Required"),
          content: const Text(
              "This app requires notification permissions to send you updates. Please enable notifications in the app settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
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


  void _showPermissionDeniedDialog() {
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
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
            Locale('bn', ''),
            Locale('kn', ''),
            Locale('mr', ''),
            Locale('ml', ''),
            Locale('te', ''),
            Locale('ta', ''),
          ],
          home: Scaffold(
            body: StreamBuilder<bool>(
              stream: Provider.of<NetworkConnectionService>(context).connectionStatusStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Something went wrong..."));
                }
                if (snapshot.data == false) {
                  return Center(child: Image.asset(ImageAssets.noInternet));
                }

                return widget.isUserLoggedIn
                    ? newHomePage(latitude: widget.latitude, longitude: widget.longitude)
                    : userlogin();
              },
            ),
          ),
        );
      },
    );
  }
}

Future<void> _createNotificationChannel() async {
  if (Platform.isAndroid) {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Define notification channel for Android 8+
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'general_notifications', // Same as used in AndroidNotificationDetails
      'General Notifications',
      description: 'Warehouse App Notifications',
      importance: Importance.high,
    );

    // Initialize the plugin with the defined channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
