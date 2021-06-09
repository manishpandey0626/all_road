import 'dart:async';
import 'dart:developer';
import 'package:all_road/induction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'driver_manual.dart';
import 'job.dart';
import 'login.dart';



class SplashScreen extends StatefulWidget {
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _versionName = 'V1.0';
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();

  _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
 // debugger();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if(status)
      {
        var testStatus = prefs.getString("testStatus") ?? "N";
        if("Y"==testStatus) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Job()));
        }
        else
          {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (BuildContext context) => Induction()));
          }
      }
    else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Login()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body:  Container(
              alignment: Alignment.center,
               child: SvgPicture.asset(
                'asset/images/logo.svg',

                 // semanticsLabel: 'Acme Logo'
              ),
            ),


    );
  }
}