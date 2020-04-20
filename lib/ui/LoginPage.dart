import 'package:flutter/material.dart';
import 'package:jiyu/auth/login.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final backgroundColor = Color(0xFF33325F);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: this.backgroundColor,
      body: SafeArea(
          child: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              "assets/icon.png",
              width: 150,
            ),
            Text(
              "Jiyu",
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              onPressed: () async {
                bool res = await AuthProvider().signInWithGoogle();
                if (res == false) {
                  print("Failed");
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              elevation: 8.0,
              color: Colors.purple,
              child: InkWell(
                splashColor: Colors.greenAccent,
                child: Text("SIGN IN WITH GOOGLE"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
