import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_layout.dart'; // Import the MainLayout

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPushNotificationSetting();
  }

  // Load the saved preference for push notifications
  Future<void> _loadPushNotificationSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _pushNotificationsEnabled = prefs.getBool('pushNotifications') ?? true;
    });
  }

  // Save the preference for push notifications
  Future<void> _togglePushNotifications(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pushNotifications', value);
    setState(() {
      _pushNotificationsEnabled = value;
    });

    // Add your push notification enable/disable logic here
    if (value) {
      print("Push notifications enabled");
      // Call your method to enable notifications
    } else {
      print("Push notifications disabled");
      // Call your method to disable notifications
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      headerText: 'Settings', // Pass the header text
      selectedIndex: 2, // Set index for the Settings tab in the bottom navigation
      profileImage: '',
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Push Notifications'),
            trailing: Switch(
              value: _pushNotificationsEnabled,
              onChanged: (value) {
                _togglePushNotifications(value);
              },
              activeColor: Colors.green,
            ),
          ),
          const Divider(),
          // Add other settings items here
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: SettingsPage()));
