import 'dart:convert';
import 'dart:developer';

import 'package:all_road/MyColors.dart';
import 'package:all_road/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'Break.dart';
import 'BreakDown.dart';
import 'Dashboard.dart';
import 'DataClasses.dart';
import 'FuelLog.dart';
import 'IncidentLog.dart';
import 'SessionManager.dart';
import 'WorksheetAttachment.dart';
import 'api.dart';

class JobDetail extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobDetail({Key key, this.data}) : super(key: key);

  @override
  JobDetailState createState() => JobDetailState(data);
}

class JobDetailState extends State<JobDetail> {
  Map<String, dynamic> data = Map<String, dynamic>();
  var shiftStartTime = TextEditingController();
  var shiftEndTime = TextEditingController();
  var startKM = TextEditingController();
  var endKM = TextEditingController();
  var loadsDone = TextEditingController();
  var loadsComment = TextEditingController();
  bool job_started = false;
  String job_id;


  JobDetailData jobDetailData;

  Worksite selected_worksite;
  Load selected_load;
  List<Worksite> worksites = [];
  List<Load> lov_load = [];

  JobDetailState(this.data);

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    job_id = data['job_id'];
    if (data['start_km'] != null) {
      startKM.text = data['start_km'];
    }

    if (data['jobDetailData'] != null) {
      jobDetailData = data['jobDetailData'];


      setState(() {
        shiftStartTime.text = jobDetailData.start_time;
        startKM.text = jobDetailData.start_km;
        // selected_worksite=jobDetailData.worksite;
        loadsDone.text = jobDetailData.loads_done;
        loadsComment.text = jobDetailData.loads_comment;
        if ("S" == jobDetailData.status) {
          job_started = true;
        }
      });
      _getWorksite();
    }
    else {
      _getJobDetail();
    }


    _getBreakStatus();

    _getLoads();
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: MyColors.myCustomGreen,
        //drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: MyColors.myCustomGreen,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            "JobDetail",
            style: Theme
                .of(context)
                .textTheme
                .headline1,
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(controller: _scrollController, slivers: [
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
                              'asset/images/resume_bro.svg',
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
                                    "Have some faith in us",
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
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                )),
            SliverToBoxAdapter(
                child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(20,0,20,20),
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
                            Row(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextFormField(
                                          enabled: !job_started,
                                          onTap: () {
                                            _selectTime(context,shiftStartTime);
                                          },
                                          readOnly: true,
                                          controller: shiftStartTime,
                                          decoration: InputDecoration(
                                          hintText: "Shift Start",
                                          labelText: "Shift Start"),
                                          validator: (value) {
                                            /*   if (value.isEmpty) {
                return msg;
              }*/
                                            return null;
                                          },
                                        ),
                                      )),
                                ),
                                Flexible(
                                    child: SizedBox(
                                        child: _getInputText(
                                            startKM,
                                            "Start K.M",
                                            "Start K.M",
                                            "Please enter start K.M",
                                            is_numeric: true, is_enable: false))),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: DropdownButtonFormField<Worksite>(

                                decoration:InputDecoration(

                                  isDense: true,
                                  labelText: "Worksite",
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff009933))),

                                ),


                                validator: (value) =>
                                value == null ? "Please Select Truck." : null,
                                value: selected_worksite,
                                onChanged:job_started? null:(Worksite Value) {
                                  setState(() {
                                    selected_worksite = Value;
                                  });
                                },
                                items: worksites.map((Worksite worksite) {
                                  return DropdownMenuItem<Worksite>(
                                    value: worksite,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          worksite.name,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Visibility(
                              visible: job_started,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: DropdownButtonFormField<Load>(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelText: "Loads done",
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Color(0xff009933))),
                                  ),
                                  validator: (value) => value == null
                                      ? "Please Select Truck."
                                      : null,
                                  value: selected_load,
                                  onChanged: (Load Value) {
                                    setState(() {
                                      selected_load = Value;
                                    });
                                  },
                                  items: lov_load.map((Load load) {
                                    return DropdownMenuItem<Load>(
                                      value: load,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            load.name,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: job_started,
                                child: _getInputText(loadsComment,
                                    "Loads Comment", "Loads Comment", "")),
                            Visibility(
                              visible: job_started,
                              child: Row(
                                children: [
                                  Flexible(
                                    child: SizedBox(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextFormField(
                                        onTap: () {
                                              _selectTime(context,shiftEndTime);
                                            },
                                            readOnly: true,
                                            controller: shiftEndTime,
                                            decoration: InputDecoration(
                                            hintText: "Shift End",
                                            labelText: "Shift End"),
                                            validator: (value) {
                                              /*   if (value.isEmpty) {
                return msg;
              }*/
                                              return null;
                                            },
                                          ),
                                        )),
                                  ),
                                  Flexible(
                                      child: SizedBox(
                                          child: _getInputText(
                                              endKM,
                                              "End K.M",
                                              "End K.M",
                                              "Please enter End K.M",
                                              is_numeric: true))),
                                ],
                              ),)


                          ],
                        )))),
            SliverToBoxAdapter(
              child: Visibility(
                visible: job_started,
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Map<String, dynamic> data = Map<String, dynamic>();
                            data['rego'] = jobDetailData.rego;
                            data['truck_id'] = jobDetailData.truck_id;
                            data['job_id'] = jobDetailData.job_id;
                            data['ids'] = selected_worksite.document;
                            data['trailer1_id'] = jobDetailData.trailer1_id;
                            data['trailer2_id'] = jobDetailData.trailer2_id;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        WorksheetAttachment(data: data)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: MyColors.greyBackground,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              "Worksheet Attachment*",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Map<String, dynamic> data = Map<String, dynamic>();
                            data['rego'] = jobDetailData.rego;
                            data['truck_id'] = jobDetailData.truck_id;
                            data['job_id'] = jobDetailData.job_id;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FuelLog(data: data)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: MyColors.greyBackground,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              "Fuel Log",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Map<String, dynamic> data = Map<String, dynamic>();
                            data['rego'] = jobDetailData.rego;
                            data['truck_id'] = jobDetailData.truck_id;
                            data['job_id'] = jobDetailData.job_id;
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        IncidentLog(data: data)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            decoration: BoxDecoration(
                              color: MyColors.greyBackground,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Text(
                              "Incident Log",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  _callBreak();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: MyColors.greyBackground,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    "Break",
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> data =
                                      Map<String, dynamic>();
                                  data['rego'] = jobDetailData.rego;
                                  data['truck_id'] = jobDetailData.truck_id;
                                  data['job_id'] = jobDetailData.job_id;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              BreakDown(data: data)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: MyColors.greyBackground,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    "Break Down",
                                    style: Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: !job_started,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )),
                          onPressed: () {
                            _startJob();
                          },
                          child: Text('Start Job',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      Visibility(
                        visible: job_started,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )),
                          onPressed: () {
                            _checkWorksheetUploaded();
                          },
                          child: Text('Submit',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _getInputText(TextEditingController controller, String hint,
      String label, String msg,
      {obscureText = false, readOnly = false, is_numeric = false,is_enable=true}) {
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
          enabled:   is_enable,
          readOnly: readOnly,
          controller: controller,
          obscureText: obscureText,
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

  Future<Null> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null)
      setState(() {
        var hour = picked.hour.toString();
        var minute = picked.minute.toString();
        var time = hour + ' : ' + minute;
        controller.text = time;
      });
  }

  _getJobDetail() async
  {
    Map<String, dynamic> user_data = await SessionManager.getUserDetails();
    String driver_id = user_data[SessionManager.driverId];

    Map<String, dynamic> data = new Map<String, dynamic>();
    data['act'] = "CURRENT_JOB";
    data['driver_id'] = driver_id;

    var response = await API.postData(data);
    //  debugger();
    var resp = json.decode(response.body);
    bool flag = resp['status'];
    if (flag) {
      jobDetailData = JobDetailData.fromJson(resp['data']);

      _getWorksite();
      setState(() {
        shiftStartTime.text = jobDetailData.start_time;
        startKM.text = jobDetailData.start_km;
        // selected_worksite=jobDetailData.worksite;
        loadsDone.text = jobDetailData.loads_done;
        loadsComment.text = jobDetailData.loads_comment;
        if ("S" == jobDetailData.status) {
          job_started = true;
        }
      });
    }
    else {
      _getWorksite();
    }
  }

//$job_id, $start_time, $start_km, $worksite, $loads_done, $loads_comment
  _startJob() async {
    if (shiftStartTime.text.isEmpty) {
      Utility.showMsg(context, "Please select shift start time.");
      return;
    }

    if (startKM.text.isEmpty) {
      Utility.showMsg(context, "Please enter start KM.");
      return;
    }

    if (selected_worksite == null) {
      Utility.showMsg(context, "Please select worksite.");
      return;
    }

    Map<String, dynamic> job_data = new Map<String, dynamic>();
    job_data['act'] = "START_JOB";
    job_data['job_id'] = job_id;
    job_data['start_time'] = shiftStartTime.text;
    job_data['start_km'] = startKM.text;
    job_data['worksite'] = selected_worksite.id;


    var response = await API.postData(job_data);
    //debugger();
    print(response.body);
    var resp = json.decode(response.body);
    if (resp["status"]) {
      setState(() {
        job_started = true;
        _getJobDetail();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Job Started!!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${resp["msg"]}'),
        duration: const Duration(seconds: 5),
      ));
    }
  }


  _endJob() async {
    if (selected_load == null) {
      Utility.showMsg(context, "Please select loads");
      return;
    }
    if (shiftEndTime.text.isEmpty) {
      Utility.showMsg(context, "Please select shift end time.");
      //  Utility.showMsg(context,"Please select shift end time.");
      return;
    }

    double sk=double.parse(startKM.text);
    double ek=double.parse(endKM.text);

    if(ek<=sk)
      {
        Utility.showMsg(context, "End KM. must be greather than start KM.");
        return;
      }

    if (endKM.text.isEmpty) {
      Utility.showMsg(context, "Please enter end KM.");
      return;
    }

    Map<String, dynamic> job_data = new Map<String, dynamic>();
    job_data['act'] = "END_JOB";
    job_data['job_id'] = job_id;
    job_data['end_time'] = shiftEndTime.text;
    job_data['end_km'] = endKM.text;
    job_data['loads_done'] = selected_load.id;
    job_data['loads_comment'] = loadsComment.text;
    job_data['truck_id'] =jobDetailData.truck_id;

    var response = await API.postData(job_data);
   // debugger();
    print(response.body);
    var resp = json.decode(response.body);
    if (resp["status"]) {
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Job End!!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${resp["msg"]}'),
        duration: const Duration(seconds: 5),
      ));
    }
  }


  _getWorksite() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data["act"] = "GET_WORKSITE";
    final response = await API.postData(data);

    //debugger();
    var response_data = json.decode(response.body);

    //  debugger();
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        //  debugger();
        worksites = list.map((model) => Worksite.fromJson(model)).toList();
        if (jobDetailData != null) {
          selected_worksite = worksites
              .singleWhere((element) => element.id == jobDetailData.worksite);
        }
      });
    }
  }

  _getLoads() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data["act"] = "GET_LOADS";
    final response = await API.postData(data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        //  debugger();
        lov_load = list.map((model) => Load.fromJson(model)).toList();
      });
    }
  }

  _getBreakStatus() async {
    //debugger();
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data["act"] = "BREAK_STATUS";
    post_data["job_id"]=job_id;
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);

    if (this.mounted) {
      setState(() {
        // debugger();
        bool break_expire = response_data['expire'];
        String precheck_status = response_data['precheck_status'];

        if (!break_expire || precheck_status == "N") {
          _callBreak();
        }
      });
    }
  }

  _callBreak() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['rego'] = jobDetailData.rego;
    data['truck_id'] = jobDetailData.truck_id;
    data['trailer1_id'] = jobDetailData.trailer1_id;
    data['trailer2_id'] = jobDetailData.trailer2_id;
    data['job_id'] = jobDetailData.job_id;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Break(data: data)));
  }

  _checkWorksheetUploaded() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data["act"] = "CHECK_WORKSHEET_UPLOADED";
    data["job_id"] = job_id;
    final response = await API.postData(data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        bool status = response_data["status"];
        //  debugger();
        if (status) {
          _endJob();
        } else {
          Utility.showMsg(context, "Please attach worksheet.");
        }
      });
    }
  }


  Future<bool>  onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the App?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {

                Navigator.of(context).pop(false);
                // return Future.value(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
                //  return Future.value(true);
              },
            )
          ],
        );
      },
    ) ?? false;
  }
}
