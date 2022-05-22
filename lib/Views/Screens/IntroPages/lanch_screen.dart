// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home/home_screen.dart';
import 'intro_first_page.dart';
import '../login_page.dart';
// import 'login/login_page.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  _startTimer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Timer(
        Duration(seconds: 4),
        () => {
              if (prefs.getBool('hasViewIntro') != null)
                {
                  if (prefs.getBool('isLoggedIn') == null)
                    {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      //   (Route<dynamic> route) => false,
                      // )
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    }
                  else if (prefs.getBool('isLoggedIn') == true)
                    {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomeScreen()),
                      //   (Route<dynamic> route) => false,
                      // )
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen())) //return HomeScreen();
                    }
                  else
                    {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => LoginPage()),
                      //   (Route<dynamic> route) => false,
                      // )
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()))
                    }
                }
              else
                {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => IntroFirstPage()))
                }
            });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Center(
              child: Image.asset(
            "images/Splashsc.jpg",
            width: size.width,
            height: size.height,
            // fit: BoxFit,
          )),
        ),
      ),
    );
  }
}
