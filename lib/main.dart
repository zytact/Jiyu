import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiyu/ui/LoginPage.dart';
import 'package:jiyu/ui/SplashScreen.dart';
import 'package:jiyu/ui/WatchingPage.dart';

void main() => runApp(Jiyu());

class Jiyu extends StatelessWidget {
  final backgroundColor = Color(0xFF2d3447);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jiyu",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        canvasColor: this.backgroundColor,
        textSelectionColor: Colors.blueAccent,
        cursorColor: Colors.blueAccent,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.data == null) {
          return LoginPage();
        }
        if (snapshot.hasData) {
          return WatchingPage();
        }
      },
    );
  }
}
