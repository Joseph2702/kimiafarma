import 'package:flutter/material.dart';
import 'package:kimiafarma/screen/home-page.dart';
import 'package:kimiafarma/screen/profile-page.dart';
import 'package:kimiafarma/screen/login-page.dart';
import 'package:kimiafarma/screen/splash-screen.dart';
import 'package:kimiafarma/screen/forgot-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash_screen',
        routes: {
          'splash_screen': (context) => SplashScreen(),
          'login_page': (context) => LoginPage(),
          'forgot_page': (context) => ForgotPage(),
          'home_page': (context) => HomePage(),
          'profile_page': (context) => ProfilePage(),
        });
  }
}
