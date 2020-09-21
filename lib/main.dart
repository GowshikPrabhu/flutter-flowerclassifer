import 'package:flutter/material.dart';
import 'package:imageclassifier/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flower Identifier',
      home: MySplashScreen(),
    );
  }
}
