import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:donate_path/auth_wrapper.dart';
import 'package:donate_path/signup_page.dart';
import 'package:donate_path/login_page.dart';
import 'package:donate_path/org_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donations App',
      routes: {
        '/signup': (context) => SignUpPage(),
        '/signin': (context) => LoginPage(),
        '/org_signup': (context) => OrgSignupPage(),

        // ... other routes
      },
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthWrapper(),
    );
  }
}
