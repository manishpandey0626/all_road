import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:all_road/induction.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Break.dart';
import 'Dashboard.dart';
import 'DataClasses.dart';
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

  //FirebaseMessaging messaging;


  String _versionName = 'V1.0';
  final splashDelay = 3;

  @override
  void initState() {
    super.initState();
   // registerNotification();

 // _loadWidget();
    navigationPage();
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
    data['act'] = "CURRENT_JOB";
    data['driver_id'] =driver_id;

    var response = await API.postData(data);
    //debugger();
    var resp = json.decode(response.body);
    if (resp["status"]) {
      JobDetailData jobDetailData = JobDetailData.fromJson(resp['data']);

      _getBreakStatus(jobDetailData);

    }
    else
    {

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
    }
  }


  _getBreakStatus(JobDetailData jobDetailData) async {
    //debugger();
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data["act"] = "BREAK_STATUS";
    post_data["job_id"]=jobDetailData.job_id;
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);

    if (this.mounted) {
      setState(() {
      // debugger();
        bool break_expire = response_data['expire'];
        String precheck_status = response_data['precheck_status'];

        if (!break_expire || precheck_status == "N") {
          Map<String, dynamic> data = Map<String, dynamic>();
          data['rego'] = jobDetailData.rego;
          data['truck_id'] = jobDetailData.truck_id;
          data['trailer1_id'] = jobDetailData.trailer1_id;
          data['trailer2_id'] = jobDetailData.trailer2_id;
          data['job_id'] = jobDetailData.job_id;
          data['time']=response_data['time'];
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Break(data: data)));
        }
        else
          {
            Map<String, dynamic> data = Map<String, dynamic>();
            data['jobDetailData'] = jobDetailData;
            data['job_id'] = jobDetailData.job_id;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => JobDetail(data:data)));
          }
      });
    }
  }

/*  registerNotification() async
  {
   // await Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print("token=> $value");
    });
  }*/
}