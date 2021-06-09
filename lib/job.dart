import 'dart:convert';
import 'dart:developer';

import 'package:all_road/JobDetail.dart';
import 'package:all_road/MyColors.dart';
import 'package:all_road/precheck.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'api.dart';

class Job extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  Job({Key key, this.data}) : super(key: key);

  @override
  JobState createState() => JobState(data);
}

class JobState extends State<Job> {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobState(this.data);

  List<Truck> truck_items = [];
  List<Truck> trailer1_items=[];
  List<Truck> trailer2_items=[];
  List<Truck> banners = [];
  String cat_name;
  int _current = 0;
  int item_cnt = 0;
  Truck selected_truck;
  Truck selected_trailer;
  Truck selected_trailer2;
  bool enable_truck=true;
  bool enable_trailer1=true;
  bool enable_trailer2=true;

  String driver_id;
  List<PreCheckQuestion> truck_data=[];


  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    // cat_name = data["cat_name"];

  _getJobStatus();

    if(data!=null) {
     // debugger();
      enable_truck = data["truck_status"]==null ? true : !data["truck_status"];
      enable_trailer1 = data["trailer1_status"]==null ? false : !data["trailer1_status"];
      enable_trailer2 = data["trailer2_status"]==null ? false : !data["trailer2_status"];

    }


    /* _getBanners("act=GET_BANNER&cat_id=" + data["cat_id"]);*/
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
              "Job",
              style: Theme.of(context).textTheme.headline1,
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
                        'asset/images/Job_hunt-amico.svg',
                        alignment: Alignment.bottomRight,
                        width: MediaQuery.of(context).size.width,
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
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Select one option",
                              style: Theme.of(context).textTheme.headline3,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 100,vertical: 16),
                  child: DropdownButtonFormField<Truck>(

                    decoration:InputDecoration(

                      isDense: true,
                      labelText: "Truck",
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff009933))),

                    ),


                    validator: (value) =>
                        value == null ? "Please Select Truck." : null,
                    value: selected_truck,
                    onChanged: enable_truck? (Truck Value) {
                      setState(() {
                        selected_truck = Value;
                        if(selected_truck.truck_cat =="1")
                          {

                          }
                      });
                    }:null,
                    items: truck_items.map((Truck truck) {
                      return DropdownMenuItem<Truck>(
                        value: truck,
                        child: Row(
                          children: <Widget>[
                            Text(
                              truck.rego,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Visibility(
                  visible: selected_truck==null? false:selected_truck.truck_cat=="1" ? true:false,
                //  maintainAnimation: true,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 100,vertical: 16),
                    child: DropdownButtonFormField<Truck>(

                      decoration:InputDecoration(
                        isDense: true,
                        labelText: "Trailer 1",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff009933))),

                      ),


                      validator: (value) =>
                      value == null ? "Please Select Trailer" : null,
                      value: selected_trailer,
                      onChanged: enable_trailer1? (Truck Value) {
                        setState(() {
                          selected_trailer = Value;
                        });
                      }:null,
                      items: trailer1_items.map((Truck trailer) {
                        return DropdownMenuItem<Truck>(
                          value: trailer,
                          child: Row(
                            children: <Widget>[
                              Text(
                                trailer.rego,
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
                  visible: selected_truck==null? false:selected_truck.truck_cat=="2" ? true:false,
                  //  maintainAnimation: true,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 100,vertical: 16),
                    child: DropdownButtonFormField<Truck>(

                      decoration:InputDecoration(
                        isDense: true,
                        labelText: "Trailer",
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff009933))),

                      ),


                      validator: (value) =>
                      value == null ? "Please Select Trailer" : null,
                      value: selected_trailer2,
                      onChanged: enable_trailer2?(Truck Value) {
                        setState(() {
                          selected_trailer2 = Value;
                        });
                      }:false,
                      items: trailer1_items.map((Truck trailer) {
                        return DropdownMenuItem<Truck>(
                          value: trailer,
                          child: Row(
                            children: <Widget>[
                              Text(
                                trailer.rego,
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    color: Colors.white,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {

                        if(selected_truck==null)
                          {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('Please select Truck'),
                              duration: const Duration(seconds: 3),

                            ));
                            return;
                          }
                      if(selected_truck.truck_cat=="1" && selected_trailer==null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Please select Trailer 1'),
                            duration: const Duration(seconds: 3),

                          ));
                          return;
                        }

                        if(selected_truck.truck_cat=="2" && selected_trailer2==null)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Please select Trailer 2'),
                            duration: const Duration(seconds: 3),

                          ));
                          return;
                        }

                        Map<String, dynamic> data1 =
                        Map<String, dynamic>();
                        data1['selected_truck'] = selected_truck;
                        data1['selected_trailer1']=selected_trailer;
                        data1['selected_trailer2']=selected_trailer2;

                        data1['truck_precheck_status']= data!=null ? data['truck_status']:false;
                        data1['trailer1_precheck_status']=data!=null ?data['trailer1_status']:false;
                        data1['trailer2_precheck_status']=data!=null ?data['trailer2_status']:false;
                        data1['truck_files']=data!=null? data['truck_files']:null;
                        data1['trailer1_files']=data!=null? data['trailer1_files']:null;
                        data1['trailer2_files']=data!=null? data['trailer2_files']:null;
                        data1['truck_comment']=data!=null ? data['truck_comment']:null;
                        data1['trailer1_comment']=data!=null ? data['trailer1_comment']:null;
                        data1['trailer2_comment']=data!=null ? data['trailer2_comment']:null;




                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Precheck(data:data1)));
                      },
                      child: Text('Pre Check',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ))
              ],
            ),
          )),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
            ),
          )
        ]),
      ),
    );
  }

  _getTruck(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
    //  debugger();
        truck_items = list.map((model) => Truck.fromJson(model)).toList();
        if(data !=null) {
          selected_truck =truck_items.singleWhere((element) => element.id==data['selected_truck'].id);
        }
      });
    }
  }

  _getTrailer(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        trailer1_items = list.map((model) => Truck.fromJson(model)).toList();
        trailer2_items = list.map((model) => Truck.fromJson(model)).toList();
        if(data !=null) {
          selected_trailer =trailer1_items.singleWhere((element) => element.id==data['selected_trailer1'].id);
          if(selected_truck.truck_cat=="2") {
            selected_trailer2 =
                trailer2_items.singleWhere((element) => element.id ==
                    data['selected_trailer2'].id);
          }
        }
      });
    }
  }

  _getJobStatus() async
  {
    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    driver_id= user_data[SessionManager.driverId];

    Map<String, dynamic> data = new Map<String, dynamic>();
    data['act'] = "GET_JOB_STATUS";
    data['driver_id'] =driver_id;

    var response = await API.postData(data);
 //  debugger();
    var resp = json.decode(response.body);
    if (resp["status"]) {
      Map<String, dynamic> data = Map<String, dynamic>();
      data['job_id'] = resp["job_id"];
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => JobDetail(data:data)));
    }
    else
      {
        _getTruck("act=GET_TRUCK");
        _getTrailer("act=GET_TRAILER");

      }
  }

}
