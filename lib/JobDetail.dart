import 'dart:developer';

import 'package:all_road/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'DataClasses.dart';
import 'SessionManager.dart';
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
  var worksite = TextEditingController();
  var loadsDone = TextEditingController();
  var loadsComment = TextEditingController();
  bool job_started=false;
  String job_id;

  JobDetailData jobDetailData;

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

    _getJobDetail();
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.myCustomGreen,
      //drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: MyColors.myCustomGreen,
        elevation: 0.0,
        title: Align(
            alignment: Alignment.center,
            child: Text(
              "JobDetail",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            )),
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
                  padding: EdgeInsets.all(20),
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
                                          labelText: "Shift Start"
                                        ),
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
                                          is_numeric: true,is_enable: !job_started))),
                            ],
                          ),
                          _getInputText(worksite, "Worksite", "Worksite",
                              "",is_enable: !job_started),
                          _getInputText(loadsDone, "Loads Done", "Loads Done", "",is_enable: !job_started),
                          _getInputText(loadsComment, "Loads Comment", "Loads Comment", "",is_enable:!job_started),
                          Visibility(
                            visible: job_started,
                            child: Row(
                              children: [
                                Flexible(
                                  child: SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextFormField(
                                          onTap: () {
                                            _selectTime(context,shiftEndTime);
                                          },
                                          readOnly: true,
                                          controller: shiftEndTime,
                                          decoration: InputDecoration(
                                            hintText: "Shift End",
                                            labelText: "Shift End"
                                          ),
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
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
              child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //  padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {
                        _startJob();
                      },
                      child: Text('Start Job',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                    ), ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        //  padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {
                        _startJob();
                      },
                      child: Text('Submit',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    )],
                ),

            ),
          )
        ]),
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
    final TimeOfDay picked =
    await showTimePicker(context: context, initialTime: TimeOfDay.now());
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

      Map<String,dynamic> user_data= await SessionManager.getUserDetails();
      String driver_id= user_data[SessionManager.driverId];

      Map<String, dynamic> data = new Map<String, dynamic>();
      data['act'] = "CURRENT_JOB";
      data['driver_id'] =driver_id;

      var response = await API.postData(data);
    //  debugger();
      var resp = json.decode(response.body);
      jobDetailData=  JobDetailData.fromJson(resp['data']);
setState(() {
  shiftStartTime.text=jobDetailData.start_time;
  startKM.text=jobDetailData.start_km;
  worksite.text=jobDetailData.worksite;
  loadsDone.text=jobDetailData.loads_done;
  loadsComment.text=jobDetailData.loads_comment;
  if("S"==jobDetailData.status)
    {
      job_started=true;
    }

});
    }


//$job_id, $start_time, $start_km, $worksite, $loads_done, $loads_comment
  _startJob() async {
    Map<String, dynamic> job_data = new Map<String, dynamic>();
    job_data['act'] = "START_JOB";
    job_data['job_id'] = job_id;
    job_data['start_time'] = shiftStartTime.text;
    job_data['start_km'] = startKM.text;
    job_data['worksite'] = worksite.text;
    job_data['loads_done'] = loadsDone.text;
    job_data['loads_comment'] = loadsComment.text;

    var response = await API.postData(job_data);
    debugger();
    print(response.body);
    var resp = json.decode(response.body);
    if (resp["status"]) {

      setState(() {
        job_started=true;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
         content: Text('Job Started!!'),
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


}
