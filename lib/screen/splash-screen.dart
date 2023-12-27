import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Durasi diubah menjadi 5 detik
    );

    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);

    Timer(Duration(seconds: 5), () {
      _controller.stop();
      Navigator.pushNamed(
        context,
        'login_page',
      );
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 3, 110),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/logo.jpg',
                width: 300.0,
                height: 300.0,
              ),
            ),
            SizedBox(height: 10),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_animation.value * 100, 0),
                  child: Opacity(
                    opacity: _animation.value,
                    child: Container(
                      height: 2.0,
                      width: 100.0 - (_animation.value * 50),
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Opacity(
              opacity: _animation.value,
              child: Text(
                'WELCOME TO KIMIA FARMA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
