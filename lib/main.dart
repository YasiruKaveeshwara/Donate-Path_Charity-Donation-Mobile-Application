import 'package:donate_path/orphanages.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'all_items_page.dart';
import 'donate_page.dart';
import 'events.dart';
import 'my_items_page.dart';
import 'theme_notifier.dart';
import 'language_notifier.dart';
import 'auth_wrapper.dart';
import 'settings_page.dart';
import 'signup_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'volunteer_profile.dart';
import 'volunteer_list.dart';
import 'my_feedback.dart';
import 'volunteer_dashboard.dart';
import 'volunteer_register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LanguageNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LanguageNotifier>(
      builder: (context, themeNotifier, languageNotifier, child) {
        return MaterialApp(
          title: 'Donations App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
          ),
          themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(languageNotifier.currentLanguage),
          initialRoute: '/',
          routes: {
            '/': (context) => AuthWrapper(),
            '/signup': (context) => SignUpPage(),
            '/signin': (context) => LoginPage(),
            '/home': (context) => HomePage(),
            '/profile': (context) => const VolunteerProfile(),
            '/settings': (context) => const SettingsPage(),
            '/volunteer_dashboard': (context) => VolunteerDashboard(),
            '/volunteer_register': (context) => VolunteerRegisterPage(),
            '/volunteer_list': (context) => VolunteerListPage(),
            '/my_feedback': (context) => MyFeedbackPage(),
            '/orphanages': (context) => OrphanagePage(),
        '/my_items': (context) => MyItemsPage(),
        '/events': (context) => EventPage(),
        '/donate_page': (context) => DonatePage(),
        '/all_items': (context) => AllItemsPage(),
          },
        );
      },
    );
  }
}
