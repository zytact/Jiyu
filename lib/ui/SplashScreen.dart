import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final backgroundColor = Color(0xFF2d3447);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/icon.png",
            ),
            Text(
              "Jiyu",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Made by Arnab",
              style: TextStyle(
                fontSize: 15.0,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
