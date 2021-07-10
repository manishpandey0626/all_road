import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:all_road/MyColors.dart';
import 'package:all_road/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'Dashboard.dart';
import 'SessionManager.dart';
import 'api.dart';

class BreakDown extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  BreakDown({Key key, this.data}) : super(key: key);

  @override
  BreakDownState createState() => BreakDownState(data);
}

class BreakDownState extends State<BreakDown> {
  Map<String, dynamic> data = Map<String, dynamic>();
  var reportedDate = TextEditingController();
  var truckId = TextEditingController();
  var comment = TextEditingController();
  List<File> upload_files = [];
  final ImagePicker _picker = ImagePicker();
  String rego;

  BreakDownState(this.data);

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    rego = data["rego"];
    truckId.text = rego;
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
        centerTitle: true,
        title: Text(
          "Break Down",
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
                            'asset/images/work_time_amico.svg',
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
                                  "Calm down,",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Just report the issue\nand we will take care of it.",
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
                              child: TextFormField(
                                onTap: () {
                                  _selectDate(context, reportedDate);
                                },
                                readOnly: true,
                                controller: reportedDate,
                                decoration: InputDecoration(
                                    hintText: "Reported Date",
                                    labelText: "Reported Date"),
                                validator: (value) {
                                  /*   if (value.isEmpty) {
              return msg;
            }*/
                                  return null;
                                },
                              )),
                          _getInputText(comment, "Comment", "Comment", "",
                              lines: 4),

                          SizedBox(height: 20),
                          Container(
                            height: 100,
                            child: ListView.builder(

                                scrollDirection: Axis.horizontal,
                                itemCount: upload_files.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        width: 100,
                                        height:100,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                            color:Colors.grey[400],
                                            //border: Border.all(color: Colors.grey[700]),
                                            borderRadius: BorderRadius.circular(4)
                                        ),
                                        margin: EdgeInsets.symmetric(horizontal: 8),

                                        child: Image.file(
                                          File(upload_files[index].path),
                                          fit: BoxFit.contain,

                                        ),
                                      ),
                                      Positioned(
                                        right:10,
                                        top:5,
                                        child:
                                        GestureDetector(
                                          onTap: (){

                                            setState(() {
                                              upload_files.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(1),
                                            padding:EdgeInsets.all(2),
                                            decoration:BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.red[900],
                                                    Colors.red[500],
                                                    // Color(0x00000000)
                                                  ],
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                ),
                                                borderRadius: BorderRadius.circular(50)
                                            ),
                                            //  color:Colors.yellow,
                                            child:
                                            Icon(

                                              Icons.close,
                                              color: Colors.white,
                                              size: 16.0,

                                            ),
                                          ),
                                        ),
                                      )

                                    ],
                                  );
                                }),
                          )
                        ],
                      )))),
          SliverToBoxAdapter(
            child: Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromGallery();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.greyBackground,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text("Gallery", style: Theme
                              .of(context)
                              .textTheme
                              .headline4,),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: MyColors.greyBackground,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Text("Camera", style: Theme
                              .of(context)
                              .textTheme
                              .headline4,),
                        ),
                      ),
                    ),
                  ],
                )
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      )),
                  onPressed: () {
                    _saveData();
                  },
                  child: Text('Submit',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ),
        ]),
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

  Future<Null> _selectDate(BuildContext context,
      TextEditingController controller) async {
    var date= DateTime.now();
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(date.year,date.month-6,date.day),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        var hour = picked.hour.toString();
        var minute = picked.minute.toString();
        var time = hour + ' : ' + minute;
        var date = picked.day.toString() +
            '/' +
            picked.month.toString() +
            '/' +
            picked.year.toString();
        controller.text = date;
      });
  }



  Future getImageFromCamera() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        upload_files.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        var lastSeparator = pickedFile.path.lastIndexOf(Platform.pathSeparator);
        var newPath = pickedFile.path.substring(0, lastSeparator + 1);

        upload_files.add(file);
      } else {
        print('No image selected.');
      }
    });
  }


  _saveData() async {

    if(reportedDate.text.isEmpty)
    {
      Utility.showMsg(context,"Plese select Reported date.");
      return;
    }

    if(upload_files.length<1)
    {
      Utility.showMsg(context,"Plese upload atleast one incident image.");
      return;
    }

    Map<String, dynamic> data1 = Map<String, String>();

    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];


    data1['act'] = 'BREAK_DOWN';
    data1["user_id"] = driver_id;
    data1["truck_id"] = data['truck_id'];
    data1["job_id"] = data['job_id'];
    data1["reported_date"] = reportedDate.text;
    data1["comment"] = comment.text;


    List<String> paths=[];
    paths.addAll(upload_files.map((file)=>file.path));

    var response = await API.postMultipartData(data1,paths);
    //debugger();
    var resp = json.decode(response);
    if (resp["status"]) {
    /*  Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => Dashboard()));*/

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Dashboard()
          ),
          ModalRoute.withName("/Dashboard")
      );
    }
    else
    {
      Utility.showMsg(context,"Error: ${resp["msg"]}");
    }
  }
}
