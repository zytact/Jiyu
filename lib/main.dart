import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jiyu/ui/LoginPage.dart';
import 'package:jiyu/ui/SplashScreen.dart';
import 'package:jiyu/ui/WatchingPage.dart';
import 'package:jiyu/auth/login.dart';

void main() => runApp(Jiyu());

class Jiyu extends StatelessWidget {
  final backgroundColor = Color(0xFF33325F);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Jiyu",
      theme: ThemeData(
        primarySwatch: Colors.purple,
        brightness: Brightness.dark,
        canvasColor: backgroundColor,
        textSelectionColor: Colors.purpleAccent,
        cursorColor: Colors.purpleAccent,
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
