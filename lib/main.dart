import 'package:flutter/material.dart';
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
        initialRoute: 'profile',
        routes: {
          'profile': (context) => ProfilePage(),
        });
  }
}