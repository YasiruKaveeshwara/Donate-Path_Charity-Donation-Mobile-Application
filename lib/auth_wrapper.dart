import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donate_path/login_page.dart';
import 'package:donate_path/home_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}
