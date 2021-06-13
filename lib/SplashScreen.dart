import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:all_road/induction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'Home.dart';
import 'JobDetail.dart';
import 'SessionManager.dart';
import 'api.dart';
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
        _getJobStatus();
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


  _getJobStatus() async
  {
    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];

    Map<String, dynamic> data = new Map<String, dynamic>();
    data['act'] = "GET_JOB_STATUS";
    data['driver_id'] =driver_id;

    var response = await API.postData(data);
    //debugger();
    var resp = json.decode(response.body);
    if (resp["status"]) {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['job_id'] = resp["job_id"];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => JobDetail(data:data)));
    }
    else
    {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
    }
  }
}