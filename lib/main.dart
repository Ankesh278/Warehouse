import 'dart:io';
import 'package:Lisofy/Connectivity/network_service.dart';
import 'package:Lisofy/Localization/languages.dart';
import 'package:Lisofy/Warehouse/Partner/Provider/auth_provider.dart';
import 'package:Lisofy/Warehouse/Partner/Provider/location_provider.dart';
import 'package:Lisofy/Warehouse/Partner/Provider/warehouse_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/notification_setting.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/document_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/filter_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/interest_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/auth_user_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/photo_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/rating_provider.dart';
import 'package:Lisofy/Warehouse/User/UserProvider/sorting_provider.dart';
import 'package:Lisofy/Warehouse/User/userlogin.dart';
import 'package:Lisofy/generated/l10n.dart';
import 'package:Lisofy/new_home_page.dart';
import 'package:Lisofy/resources/ImageAssets/ImagesAssets.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    if (kDebugMode) {
      print("Firebase Initialization Error: $e");
    }
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Android-specific initialization
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@drawable/ic_stat_push_notification');

  const InitializationSettings initializationSettings = InitializationSettings(
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
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PhotoProvider()),
        ChangeNotifierProvider(create: (_) => RatingProvider()),
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
    super.key,
    required this.isLoggedIn,
    required this.name,
    required this.isUserLoggedIn,
    required this.longitude,
    required this.latitude,
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

    FirebaseMessaging.instance.getToken().then((token) {
      if (kDebugMode) {
        print("FCM Token:  $token");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'general_notifications',
              'General Notifications',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@drawable/ic_stat_push_notification',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("Notification clicked: ${message.messageId}");
      }
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
    return PopScope(
        canPop: false,
        child:Consumer<LanguageProvider>(
          builder: (context, languageProvider, child) {
            return MaterialApp(
              theme: ThemeData(
                fontFamily: 'Mulish',
                textTheme: const TextTheme(
                  displayLarge: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  bodyLarge: TextStyle(fontSize: 12),
                ),
              ),
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
                Locale('pa', ''),
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
                        ? NewHomePage(latitude: widget.latitude, longitude: widget.longitude)
                        : const UserLogin();
                  },
                ),
              ),
            );
          },
        ));
  }
}
Future<void> _createNotificationChannel() async {
  if (Platform.isAndroid) {
    try {
      // Define notification channel for Android 8+ (API 26+)
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'general_notifications',
        'General Notifications',
        description: 'Warehouse App Notifications',
        importance: Importance.high,
      );

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      if (kDebugMode) {
        print("Notification channel created successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating notification channel: $e");
      }
    }
  }
}

