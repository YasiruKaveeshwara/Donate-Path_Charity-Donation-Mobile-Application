import 'package:donate_path/all_items_page.dart';
import 'package:donate_path/events.dart';
import 'package:donate_path/my_items_page.dart';
import 'package:donate_path/orphanages.dart';

import 'volunteer_dashboard.dart';
import 'volunteer_register.dart';
import 'settings_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'auth_wrapper.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'home_page.dart'; // Import other pages as needed
import 'volunteer_profile.dart'; // Example additional page
import 'volunteer_list.dart';
import 'donate_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donations App',
      debugShowCheckedModeBanner: false, // Hide the debug banner
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/signup': (context) => const SignUpPage(),
        '/signin': (context) => const LoginPage(),
        '/home': (context) => const HomePage(), // Add other routes as needed
        '/profile': (context) => const VolunteerProfile(),
        '/settings': (context) => SettingsPage(),
        '/volunteer_dashboard': (context) => VolunteerDashboard(),
        '/volunteer_register': (context) => VolunteerRegisterPage(),
        '/volunteer_list': (context) => VolunteerListPage(),
        '/orphanages': (context) => OrphanagePage(),
        '/my_items': (context) => MyItemsPage(),
        '/events': (context) => EventPage(),
        '/donate_page': (context) => DonatePage(),
        '/all_items': (context) => AllItemsPage(),
      },
    );
  }
}
