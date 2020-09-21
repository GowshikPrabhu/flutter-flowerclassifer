import 'package:flutter/material.dart';
import 'package:imageclassifier/home.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 2,
      navigateAfterSeconds: Home(),
      title: Text(
        'Flower Identifier',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      image: Image.asset('assets/flower.png'),
      backgroundColor: Colors.black,
      photoSize: 100,
      loaderColor: Color(0xFF1E90FF),
    );
  }
}
