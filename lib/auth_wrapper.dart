import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:donate_path/login_page.dart';
import 'package:donate_path/home_page.dart';
import 'package:donate_path/org_home_page.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print('Auth state change detected');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data != null) {
          String email = snapshot.data!.email!;
          int index = email.indexOf('@');
          String domain = email.substring(index + 1);

          print('Logged in email domain: $domain');

          if (domain == "org.com") {
            print("Navigating to OrgHomePage for Organization");
            return OrgHomePage();
          } else {
            print("Navigating to HomePage for User");
            return HomePage();
          }
        } else {
          print("No user logged in. Navigating to LoginPage.");
          return LoginPage();
        }
      },
    );
  }
}
