import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SessionManager
{
  static final  String driverId="driver_id";
  static final  String driverName="driver_name";
  static final  String testStatus="testStatus";

  static final String isLoggedIn="isLoggedIn";

 static logout() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   // debugger();
   prefs.setBool('isLoggedIn', false);
   prefs.remove("driver_id");
   prefs.remove("driver_name");

 }

static updateTestStatus(String status) async
{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // debugger();
  prefs.setString(testStatus,status);
}

 static createSession (String pdriverId,String pdriverName,String ptestStatus) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
 // debugger();
   prefs.setBool(isLoggedIn, true);
   prefs.setString(driverId,pdriverId);
   prefs.setString(driverName,pdriverName);
   prefs.setString(testStatus,ptestStatus);

 }

  static getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  // debugger();
    Map<String,dynamic> map =Map<String,dynamic>();
    map[driverId]=prefs.getString(driverId);
    map[driverName]=prefs.getString(driverName);
    map[testStatus]=prefs.getString(testStatus);


    return map;

  }


}