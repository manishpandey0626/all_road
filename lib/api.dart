import 'dart:async';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
const baseUrl = "http://allroadtransportportal.com/api/index.php?";
const imageUrl="http://allroadtransportportal.com/productsImages/";



class API {


  static Future postData(Map<String, dynamic> data) {
    return http.post(
        Uri.parse(baseUrl),
      body:data
  );
  }

  static Future postMultipartData(Map<String, String> data,List<String> paths) async {
   // debugger();
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll(data);
    int i=1;
    for(String path in paths) {
      request.files.add(await http.MultipartFile.fromPath('file$i',path));
      i++;
    }
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    return respStr;
  }



  static Future uploadImage(filename,Map<String, String> data) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll(data);
    request.files.add(await http.MultipartFile.fromPath('LOGO', filename));
    var res = await request.send();
    final respStr = await res.stream.bytesToString();
    return respStr;
  }

  static Future saveBusiness(Map<String, String> data,List<String> paths) async {
    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll(data);
    int i=1;
    for(String path in paths) {
      request.files.add(await http.MultipartFile.fromPath('file$i',path));
      i++;
    }
   var res = await request.send();
    final respStr = await res.stream.bytesToString();
    return respStr;
  }

  static Future login(Map<String, dynamic> data) {
    return http.post(
        Uri.parse(baseUrl),
        body:data
    );
  }

  static Future getData(String end_url) {
    var url = baseUrl + end_url;
    return http.get(Uri.parse(url));
  }

}