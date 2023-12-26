import 'package:flutter/material.dart';
import 'package:kimiafarma/screen/home-page.dart';
import 'package:kimiafarma/screen/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'home_page',
        routes: {
          'home_page': (context) => HomePage(),
          'profile_page': (context) => ProfilePage(),
        });
  }
}
