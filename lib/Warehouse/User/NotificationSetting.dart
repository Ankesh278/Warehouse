
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSetting extends StatefulWidget {
  const NotificationSetting({super.key});

  @override
  State<NotificationSetting> createState() => _NotificationSettingState();
}
class _NotificationSettingState extends State<NotificationSetting> {
  String? Phone;
  String? Email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<NotificationSettingsProvider>(context, listen: false)
        .loadPreferences(); // Load preferences on initialization
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = Provider.of<NotificationSettingsProvider>(context);

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
                    // Header Section
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
                                const SizedBox(width: 20),
                                const Text(
                                  "Notification setting",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Notification Options Section
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
                          padding: EdgeInsets.all(screenWidth * 0.08),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Replace ListView with Column
                                Column(
                                  children: [
                                    _buildNotificationOption(
                                      subheading: "",
                                      context: context,
                                      title: 'Phone Notifications',
                                      value: provider.phoneNotifications,
                                      onChanged: provider.togglePhoneNotifications,
                                    ),
                                    _buildNotificationOption(
                                      subheading: provider.email ?? 'Not added', // Show loading
                                      context: context,
                                      title: 'Email Notifications',
                                      value: provider.emailNotifications,
                                      onChanged: provider.toggleEmailNotifications,
                                    ),
                                    _buildNotificationOption(
                                      subheading: provider.phone ?? 'Not added', // Show loading
                                      context: context,
                                      title: 'Push Notifications',
                                      value: provider.pushNotifications,
                                      onChanged: provider.togglePushNotifications,
                                    ),
                                  ],
                                )
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
}


Widget _buildNotificationOption({
  required BuildContext context,
  required String title,
  required String subheading,
  required bool value,
  required VoidCallback onChanged,
}) {
  return AnimatedContainer(
    duration: const Duration(milliseconds: 3000),
    curve: Curves.easeInOut,
    margin: const EdgeInsets.symmetric(vertical: 10.0),
    padding: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
      color: value ? Colors.green.shade50 : Colors.grey.shade200,
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: value ? Colors.green : Colors.grey.shade400,
        width: 1.0,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: value ? Colors.blue : Colors.blue.shade300,
              ),
            ),
            Text(subheading,style: const TextStyle(color: Colors.black26,fontSize: 12),)
          ],
        ),
        Switch(
          value: value,
          onChanged: (_) => onChanged(),
          activeColor: Colors.green,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade400,
        ),
      ],
    ),
  );
}


class NotificationSettingsProvider with ChangeNotifier {
  bool _phoneNotifications = true;
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  String? _phone;
  String? _email;

  // Getters
  bool get phoneNotifications => _phoneNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get pushNotifications => _pushNotifications;
  String? get phone => _phone;
  String? get email => _email;

  // Load preferences
  Future<void> loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _phoneNotifications = prefs.getBool('phoneNotifications') ?? true;
    _emailNotifications = prefs.getBool('emailNotifications') ?? true;
    _pushNotifications = prefs.getBool('pushNotifications') ?? true;
    _phone = prefs.getString('phone');
    _email = prefs.getString('email');
    print("emailll>>"+_email.toString());

    // Remove "+91" prefix from phone if present
    if (_phone != null && _phone!.startsWith("+91")) {
      _phone = _phone!.substring(3);
    }
    notifyListeners();
  }

  // Toggle methods
  void togglePhoneNotifications() async {
    _phoneNotifications = !_phoneNotifications;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('phoneNotifications', _phoneNotifications);
    notifyListeners();
  }

  void toggleEmailNotifications() async {
    _emailNotifications = !_emailNotifications;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('emailNotifications', _emailNotifications);
    notifyListeners();
  }

  void togglePushNotifications() async {
    _pushNotifications = !_pushNotifications;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('pushNotifications', _pushNotifications);
    notifyListeners();
  }
}


























