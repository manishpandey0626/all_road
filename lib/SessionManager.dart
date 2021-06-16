import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SessionManager
{
  static final  String driverId="driver_id";
  static final  String driverName="driver_name";
  static final  String testStatus="testStatus";
  static final  String commencement="commencement";
  static final  String licence_no="licence_no";
  static final  String licence_expiry="licence_expiry";
  static final  String profile_img="profile_img";

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

 static createSession (String pdriverId,String pdriverName,String ptestStatus,String licence_no,String licence_expiry,String commencement,String profile_img) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
 // debugger();
   prefs.setBool(isLoggedIn, true);
   prefs.setString(driverId,pdriverId);
   prefs.setString(driverName,pdriverName);
   prefs.setString(testStatus,ptestStatus);
   prefs.setString(SessionManager.licence_no,licence_no);
   prefs.setString(SessionManager.licence_expiry,licence_expiry);
   prefs.setString(SessionManager.commencement,commencement);
   prefs.setString(SessionManager.profile_img,profile_img);

 }

  static getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  // debugger();
    Map<String,dynamic> map =Map<String,dynamic>();
    map[driverId]=prefs.getString(driverId);
    map[driverName]=prefs.getString(driverName);
    map[testStatus]=prefs.getString(testStatus);
    map[profile_img]=prefs.getString(profile_img);
    map[licence_no]=prefs.getString(licence_no);
    map[licence_expiry]=prefs.getString(licence_expiry);
    map[commencement]=prefs.getString(commencement);


    return map;

  }


}