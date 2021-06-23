import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:all_road/MyColors.dart';
import 'package:all_road/precheck_break.dart';
import 'package:all_road/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'api.dart';

class Break extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  Break({Key key, this.data}) : super(key: key);

  @override
  BreakState createState() => BreakState(data);
}

class BreakState extends State<Break> with WidgetsBindingObserver {
  Map<String, dynamic> data = Map<String, dynamic>();

  var truckId = TextEditingController();
  String rego;

  Truck selected_truck;
  Truck selected_trailer1;
  Truck selected_trailer2;
  BreakTimeData selected_time;
  List<BreakTimeData> breaktimes = [];

  bool break_expire=true;
  String precheck_status="Y";
  String break_id;

  BreakState(this.data);

  @override
  void initState() {

    WidgetsBinding.instance.addObserver(this);
    super.initState();


    rego = data["rego"];
    truckId.text = rego;

    _getBreakTimes();
    _getBreakStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //do your stuff
      _getBreakStatus();

      print("ON Resume=====================");
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => break_expire && precheck_status == "Y",
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.myCustomGreen,
        //drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: MyColors.myCustomGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "Break",
            style: Theme
                .of(context)
                .textTheme
                .headline1,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh',
              onPressed: () {
                _getBreakStatus();
              },
            ),
          ],

        ),
        body: SafeArea(
            child: CustomScrollView( slivers: [
            SliverToBoxAdapter(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Stack(children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: SvgPicture.asset(
                          'asset/images/coffee_break_bro.svg',
                          alignment: Alignment.bottomRight,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          height: 150,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Give Yourself a Break",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline2,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Select one option",
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .headline3,
                              ),
                            ]),
                      ),
                    )
                  ]),
                  SizedBox(
                    height: 10,
                  )
                ])),
        SliverToBoxAdapter(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
            )),
        SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: MyColors.greyBackground,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _getInputText(truckId, "Truck No", "Truck No", "",
                            is_enable: false),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonFormField<BreakTimeData>(
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: "Break Time",
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Color(0xff009933))),
                            ),
                            validator: (value) =>
                            value == null ? "Please Select Break Time" : null,
                            value: selected_time,
                            onChanged:break_expire? (BreakTimeData Value) {
                              setState(() {
                                selected_time = Value;
                              });
                            }:null,
                            items: breaktimes.map((BreakTimeData breaktime) {
                              return DropdownMenuItem<BreakTimeData>(
                                value: breaktime,
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      breaktime.display_time,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      ],
                    )))),
              SliverToBoxAdapter(

                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          children:[
                            Visibility(
                              visible: !break_expire || precheck_status=="Y",
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    )),
                                onPressed: break_expire?() {
                                  //  _saveData();
                                  showAlertDialog(context);
                                }:null,
                                child: Text('Take a Break',
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ),
                            Visibility(
                              visible: break_expire && precheck_status=="N",
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    )),
                                onPressed: () {
                                  _precheck();
                                },
                                child: Text('Precheck',
                                    style: TextStyle(color: Colors.white, fontSize: 16)),
                              ),
                            ),]
                      ),
                    ),
                  )
              ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(20),

            ),
          ),
        ),

      ]),
      ),
      ),
    );
    }

  Widget _getInputText(TextEditingController controller, String hint,
      String label, String msg,
      {obscureText = false,
        readOnly = false,
        is_numeric = false,
        is_enable = true,
        lines = 1}) {
    final _minimumPaadding = 5.0;

    return Padding(
        padding: EdgeInsets.only(
            top: _minimumPaadding,
            bottom: _minimumPaadding,
            left: 20.0,
            right: 20.0),
        child: TextFormField(
          inputFormatters: is_numeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : [FilteringTextInputFormatter.deny("~")],
          keyboardType: is_numeric ? TextInputType.number : TextInputType.text,
          enabled: is_enable,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscureText,
          minLines: lines,
          maxLines: lines,
          decoration: InputDecoration(
            hintText: hint,
            labelText: label,
          ),
          validator: (value) {
            /*   if (value.isEmpty) {
              return msg;
            }*/
            return null;
          },
        ));
  }


  _precheck() async {
    Map<String, dynamic> data1 = new Map<String, dynamic>();
    data1['act'] = "GET_SELECTED_TRUCK_AND_TRAILER";
    data1['truck_id'] = data["truck_id"];
    data1['trailer1_id'] = data["trailer1_id"];
    data1['trailer2_id'] = data["trailer2_id"];


    var response = await API.postData(data1);

    var resp = json.decode(response.body);
    selected_truck = Truck.fromJson(resp['truck']);
    if ("" != resp['trailer1']) {
      selected_trailer1 = Truck.fromJson(resp['trailer1']);
    }
    if ("" != resp['trailer2']) {
      selected_trailer2 = Truck.fromJson(resp['trailer2']);
    }

    Map<String, dynamic> precheck_data = Map<String, dynamic>();
    precheck_data['selected_truck'] = selected_truck;
    precheck_data['selected_trailer1'] = selected_trailer1;
    precheck_data['selected_trailer2'] = selected_trailer2;
    precheck_data["job_id"]=data["job_id"];
    precheck_data["break_id"]=break_id;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                PrecheckBreak(data: precheck_data)));
  }

  _getBreakTimes() async {
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data["act"] = "GET_BREAK_TIME";
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
     //    debugger();
        breaktimes =
            list.map((model) => BreakTimeData.fromJson(model)).toList();

        if (data['time'] != null) {
          selected_time = breaktimes.singleWhere((element) => element.time ==data['time']  );
        }
      });
    }
  }


  _getBreakStatus() async {
    //debugger();
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data["act"] = "BREAK_STATUS";
    post_data["job_id"]=data["job_id"];
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        //debugger();
        break_expire=response_data['expire'];
        precheck_status=response_data['precheck_status'];
        break_id=response_data['break_id'];
      });
    }
  }

  _saveData() async {
if(selected_time==null)
  {
    Utility.showMsg(context,"Please select break time.");
    return;
  }

    Map<String, dynamic> data1 = Map<String, String>();

    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];


    data1['act'] = 'ADD_BREAK';
    data1["user_id"] = driver_id;
    data1["truck_id"] = data['truck_id'];
    data1["job_id"] = data['job_id'];
    data1["time"]=selected_time.time;




    var response = await API.postData(data1);
    debugger();
    var resp = json.decode(response.body);
    if (resp["status"]) {
      setState(() {
        break_expire=false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Break Started.'),
        duration: const Duration(seconds: 5),

      ));
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${resp["msg"]}'),
        duration: const Duration(seconds: 5),

      ));
    }
  }


  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        _saveData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Take a Break"),
      content: Text("Do you want to take a break of ${selected_time.display_time}?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
