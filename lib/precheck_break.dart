import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:all_road/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'DataClasses.dart';
import 'JobDetail.dart';
import 'SessionManager.dart';
import 'api.dart';
import 'job.dart';
import 'utility.dart';

class PrecheckBreak extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  PrecheckBreak({Key key, this.data}) : super(key: key);

  @override
  PrecheckBreakState createState() => PrecheckBreakState(data);
}

class PrecheckBreakState extends State<PrecheckBreak> {
  final ImagePicker _picker = ImagePicker();

  Map<String, dynamic> data = Map<String, dynamic>();

  PrecheckBreakState(this.data);

  List<PreCheckQuestion> items = [];
  List<TrailerQuestion> trailer_items = [];
  List<TrailerQuestion> trailer2_items = [];
  List<String> banners = [];
  String cat_name;
  int item_cnt = 0;
  bool trailer1_flag = false;
  bool trailer2_flag = false;
  List<File> upload_files = [];
  List<File> upload_files_trailer1 = [];
  List<File> upload_files_trailer2 = [];
  var truck_comment = TextEditingController();
  var trailer1_comment = TextEditingController();
  var trailer2_comment = TextEditingController();

  Truck selected_truck;
  Truck selected_trailer1;
  Truck selected_trailer2;
  String job_id;
  String break_id;

  bool truck_precheck_status = false;
  bool trailer1_precheck_status = false;
  bool trailer2_precheck_status = false;

  bool submit_btn_flag=false;
  List<Declaration> declaration_items = [];

  @override
  void initState() {
    selected_truck = data['selected_truck'];
    selected_trailer1 = data["selected_trailer1"];
    selected_trailer2 = data["selected_trailer2"];
    job_id=data["job_id"];
    break_id=data["break_id"];

    if (selected_truck.truck_cat == "1") {
      trailer1_flag = true;
      trailer2_flag = false;
    } else if (selected_truck.truck_cat == "2") {
      trailer1_flag = true;
      trailer2_flag = true;
    } else {
      trailer1_flag = false;
      trailer2_flag = false;
    }
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );


//debugger();

    _getPrecheckBreak("act=GET_PRECHECK_QUES");

    // cat_name = data["cat_name"];

    _getTrailerQuestion("act=GET_PRECHECK_TRAILER_QUES");

    _getDeclaration("act=GET_DECLARATION");
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
        centerTitle: true,
        title: Text(
          "Pre Check",
          style: Theme
              .of(context)
              .textTheme
              .headline1,
        ),

        // backgroundColor: Color(0xFFecf7ef),
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
                            'asset/images/kids _studying_from_home_bro.svg',
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
                                  "Quick Assessment",
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
                  color: Colors.grey[400],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Truck Question",
                      style: Theme.of(context).textTheme.headline1))),
          SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {},
                  child: Container(
                      color: Colors.white,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        decoration: BoxDecoration(
                          color: MyColors.greyBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                  child: Text(
                                    items[index].question,
                                    style:
                                    Theme.of(context).textTheme.headline5,
                                  )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Radio(
                                        value: items[index].option1,
                                        groupValue: items[index].myanswer,
                                        onChanged: truck_precheck_status
                                            ? null
                                            : (val) {
                                          setState(() {
                                            items[index].myanswer = val;
                                          });
                                        }),
                                    Text(items[index].option1),
                                  ]),
                                  SizedBox(width: 50),
                                  Row(children: [
                                    Radio(
                                        value: items[index].option2,
                                        groupValue: items[index].myanswer,
                                        onChanged: truck_precheck_status
                                            ? null
                                            : (val) {
                                          setState(() {
                                            items[index].myanswer = val;
                                          });
                                        }),
                                    Text(items[index].option2)
                                  ])
                                ],
                              ),
                            ]),
                      )));
            }, childCount: items.length),
          ),
          SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: MyColors.greyBackground,
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(children: [
                        TextField(
                            enabled: !truck_precheck_status,
                            controller: truck_comment,
                            decoration: InputDecoration(hintText: "Comment"),
                            minLines: 2,
                            maxLines: 4),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(

                                //  padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              onPressed: truck_precheck_status
                                  ? null
                                  : () {
                                getImageFromGallery();
                              },
                              child: Text('Gallery',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  )),
                              onPressed: truck_precheck_status
                                  ? null
                                  : () {
                                getImageFromCamera();
                              },
                              child: Text('Camera',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                            )
                          ],
                        ),
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
                      ])),
                ),
              )),
          SliverVisibility(
            visible: trailer1_flag,
            sliver: SliverToBoxAdapter(
                child: Container(
                    color: Colors.grey[400],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Trailer Question",
                        style: Theme.of(context).textTheme.headline1))),
          ),
          SliverVisibility(
            visible: trailer1_flag,
            sliver: SliverList(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {},
                    child: Container(
                        color: Colors.white,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          decoration: BoxDecoration(
                            color: MyColors.greyBackground,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: Text(
                                      trailer_items[index].question,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                    )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Radio(
                                          value: trailer_items[index].option1,
                                          groupValue:
                                          trailer_items[index].myanswer,
                                          onChanged: trailer1_precheck_status
                                              ? null
                                              : (val) {
                                            setState(() {
                                              trailer_items[index]
                                                  .myanswer = val;
                                            });
                                          }),
                                      Text(trailer_items[index].option1),
                                    ]),
                                    SizedBox(width: 50),
                                    Row(children: [
                                      Radio(
                                          value: trailer_items[index].option2,
                                          groupValue:
                                          trailer_items[index].myanswer,
                                          onChanged: trailer1_precheck_status
                                              ? null
                                              : (val) {
                                            setState(() {
                                              trailer_items[index]
                                                  .myanswer = val;
                                            });
                                          }),
                                      Text(trailer_items[index].option2)
                                    ])
                                  ],
                                ),
                              ]),
                        )));
              }, childCount: trailer_items.length),
            ),
          ),
          SliverVisibility(
            visible: trailer1_flag,
            sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: MyColors.greyBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(children: [
                          TextField(
                              enabled: !trailer1_precheck_status,
                              controller: trailer1_comment,
                              decoration: InputDecoration(hintText: "Comment"),
                              minLines: 2,
                              maxLines: 4),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //  padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: trailer1_precheck_status
                                    ? null
                                    : () {
                                  getImageFromGallery(type: "trailer1");
                                },
                                child: Text('Gallery',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: trailer1_precheck_status
                                    ? null
                                    : () {
                                  getImageFromCamera(type: "trailer1");
                                },
                                child: Text('Camera',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 100,
                            child: ListView.builder(

                                scrollDirection: Axis.horizontal,
                                itemCount: upload_files_trailer1.length,
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
                                          File(upload_files_trailer1[index].path),
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
                                              upload_files_trailer1.removeAt(index);
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
                        ])),
                  ),
                )),
          ),
          SliverVisibility(
            visible: trailer2_flag,
            sliver: SliverToBoxAdapter(
                child: Container(
                    color: Colors.grey[400],
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text("Trailer two Question",
                        style: Theme.of(context).textTheme.headline1))),
          ),
          SliverVisibility(
            visible: trailer2_flag,
            sliver: SliverList(
              delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {},
                    child: Container(
                        color: Colors.white,
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          decoration: BoxDecoration(
                            color: MyColors.greyBackground,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: Text(
                                      trailer2_items[index].question,
                                      style:
                                      Theme.of(context).textTheme.headline5,
                                    )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Radio(
                                          value: trailer2_items[index].option1,
                                          groupValue:
                                          trailer2_items[index].myanswer,
                                          onChanged: trailer2_precheck_status
                                              ? null
                                              : (val) {
                                            setState(() {
                                              trailer2_items[index]
                                                  .myanswer = val;
                                            });
                                          }),
                                      Text(trailer2_items[index].option1),
                                    ]),
                                    SizedBox(width: 50),
                                    Row(children: [
                                      Radio(
                                          value: trailer2_items[index].option2,
                                          groupValue:
                                          trailer2_items[index].myanswer,
                                          onChanged: trailer2_precheck_status
                                              ? null
                                              : (val) {
                                            setState(() {
                                              trailer2_items[index]
                                                  .myanswer = val;
                                            });
                                          }),
                                      Text(trailer2_items[index].option2)
                                    ])
                                  ],
                                ),
                              ]),
                        )));
              }, childCount: trailer2_items.length),
            ),
          ),
          SliverVisibility(
            visible: trailer2_flag,
            sliver: SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: MyColors.greyBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(children: [
                          TextField(
                              enabled: !trailer2_precheck_status,
                              controller: trailer2_comment,
                              decoration: InputDecoration(hintText: "Comment"),
                              minLines: 2,
                              maxLines: 4),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  //  padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: trailer2_precheck_status
                                    ? null
                                    : () {
                                  getImageFromGallery(type: "trailer2");
                                },
                                child: Text('Gallery',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                                onPressed: trailer2_precheck_status
                                    ? null
                                    : () {
                                  getImageFromCamera(type: "trailer2");
                                },
                                child: Text('Camera',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            height: 100,
                            child: ListView.builder(

                                scrollDirection: Axis.horizontal,
                                itemCount: upload_files_trailer2.length,
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
                                          File(upload_files_trailer2[index].path),
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
                                              upload_files_trailer2.removeAt(index);
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
                        ])),
                  ),
                )),
          ),
          SliverToBoxAdapter(
              child: Container(
                  color: Colors.grey[400],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text("Driver Declaration",
                      style: Theme.of(context).textTheme.headline1))),
          SliverList(

            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {},
                  child: Container(
                      color: Colors.white,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: MyColors.greyBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(value: declaration_items[index].flag, onChanged: (value)
                                  {
                                    setState(() {
                                      declaration_items[index].flag=value;
                                      submit_btn_flag = !declaration_items.any((element) => !element.flag);
                                    });

                                  }),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Text(declaration_items[index].question))
                                ],
                              ),
                            ]),
                      )));
            }, childCount: declaration_items.length),
          ),
          SliverToBoxAdapter(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  color: Colors.white,
                  child: items.length > 0
                      ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )),
                    onPressed: submit_btn_flag?() {
                      bool flag = items.any((element) =>
                      element.myanswer == null);

                      if(flag)
                      {
                        Utility.showMsg(context, 'please attend all truck questions.');
                        return;
                      }
                      if(selected_truck.truck_cat=="1" || selected_truck.truck_cat=="2") {
                        bool flag2 = trailer_items.any((element) =>
                        element.myanswer == null);

                        if (flag2) {
                          Utility.showMsg(context,
                              'please attend all trailer 1 questions.');
                          return;
                        }
                      }

                      if(selected_truck.truck_cat=="2") {
                        bool flag2 = trailer2_items.any((element) =>
                        element.myanswer == null);

                        if (flag2) {
                          Utility.showMsg(context,
                              'please attend all trailer 2 questions.');
                          return;
                        }
                      }


                      if(upload_files.length<1)
                      {
                        Utility.showMsg(context, "Please select atleast one image for truck");
                        return;
                      }
                      if((selected_truck.truck_cat=="1" || selected_truck.truck_cat=="2") && upload_files_trailer1.length<1)
                      {
                        Utility.showMsg(context, "Please select atleast one image for trailer 1");
                        return;
                      }
                      if(selected_truck.truck_cat=="2" && upload_files_trailer2.length<1)
                      {
                        Utility.showMsg(context, "Please select atleast one image for trailer 2");
                        return;
                      }

                      _saveData();
                    }:null,
                    child: Text('Submit',
                        style:
                        TextStyle(color: Colors.white, fontSize: 16)),
                  )
                      : SizedBox())),
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

  _getPrecheckBreak(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        items = list
            .map((model) =>
            PreCheckQuestion.fromJson(model, status: truck_precheck_status))
            .toList();
      });
    }
  }

  _getTrailerQuestion(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        trailer_items = list
            .map((model) => TrailerQuestion.fromJson(model,
            status: trailer1_precheck_status))
            .toList();
        trailer2_items = list
            .map((model) => TrailerQuestion.fromJson(model,
            status: trailer2_precheck_status))
            .toList();
      });
    }
  }

  Future getImageFromCamera({type: "truck"}) async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        var lastSeparator = pickedFile.path.lastIndexOf(Platform.pathSeparator);
        var newPath = pickedFile.path.substring(0, lastSeparator + 1);
        var file_name=pickedFile.path.substring(lastSeparator + 1,pickedFile.path.length);
        if (type == "trailer1") {
          upload_files_trailer1.add(file.renameSync(
              newPath + "trailer1_${upload_files_trailer1.length}_$file_name"));
        } else if (type == "trailer2") {
          upload_files_trailer2.add(file.renameSync(
              newPath + "trailer2_${upload_files_trailer2.length}_$file_name"));
        } else {
          upload_files.add(file
              .renameSync(newPath + "truck_${upload_files.length}_$file_name"));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery({type = 'truck'}) async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        var lastSeparator = pickedFile.path.lastIndexOf(Platform.pathSeparator);
        var newPath = pickedFile.path.substring(0, lastSeparator + 1);
        var file_name=pickedFile.path.substring(lastSeparator + 1,pickedFile.path.length);
        if (type == "trailer1") {
          upload_files_trailer1.add(file.renameSync(
              newPath + "trailer1_${upload_files_trailer1.length}_$file_name"));
        } else if (type == "trailer2") {
          upload_files_trailer2.add(file.renameSync(
              newPath + "trailer2_${upload_files_trailer2.length}_$file_name"));
        } else {
          upload_files.add(file
              .renameSync(newPath + "truck_${upload_files.length}_$file_name"));
        }
      } else {
        print('No image selected.');
      }
    });
  }

  _saveData() async {
    String precheck_data =
    jsonEncode(items.map((data) => data.toJson()).toList());

    String precheck_trailer_data =
    jsonEncode(trailer_items.map((data) => data.toJson()).toList());
    String precheck_trailer2_data =
    jsonEncode(trailer2_items.map((data) => data.toJson()).toList());

    bool truck_status =
    !items.any((element) => element.answer != element.myanswer && "high"==element.priority);
    bool trailer1_status =
    !trailer_items.any((element) => element.answer != element.myanswer && "high"==element.priority);
    bool trailer2_status =
    !trailer2_items.any((element) => element.answer != element.myanswer && "high"==element.priority);


    String truck_cat = selected_truck.truck_cat;

    Map<String, dynamic> data = Map<String, String>();

    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];

    data['act'] = 'SAVE_PRECHECK_BREAK';
    data["user_id"] = driver_id;
    data["truck_id"] = selected_truck.id;
    data["trailer1_id"] = truck_cat=="1" || selected_truck.truck_cat=="2"?selected_trailer1.id:"";
    data["trailer2_id"] = truck_cat=="2"?selected_trailer2.id:"";
    data["precheck_truck"] = precheck_data;
    data["precheck_trailer"] = truck_cat=="1" || selected_truck.truck_cat=="2" ?precheck_trailer_data:"";
    data["precheck_trailer2"] = truck_cat=="2"?precheck_trailer2_data:"";
    data["truck_comment"] = truck_comment.text;
    data["trailer1_comment"] = trailer1_comment.text;
    data["trailer2_comment"] = trailer2_comment.text;
    data["truck_status"]=truck_status.toString();
    data["trailer1_status"]=trailer1_status.toString();
    data["trailer2_status"]=trailer2_status.toString();
    data["truck_cat"]=truck_cat;
    data["job_id"]=job_id;
    data["break_id"]=break_id;
//debugger();
    List<String> paths=[];
    paths.addAll(upload_files.map((file)=>file.path));
    paths.addAll(upload_files_trailer1.map((file)=>file.path));
    paths.addAll(upload_files_trailer2.map((file)=>file.path));
    var response = await API.saveBusiness(data,paths);
    //debugger();
    var resp = json.decode(response);
    if (resp["status"]) {


      if ((truck_cat == "0" && truck_status) ||
          (truck_cat == "1" && truck_status && trailer1_status) ||
          (truck_cat == "2" && truck_status && trailer1_status &&
              trailer2_status)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Record saved successfully!!'),
          duration: const Duration(seconds: 3),

        ));
        Map<String, dynamic> data = Map<String, dynamic>();
        data['job_id'] = job_id;
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => JobDetail(data: data)));
      }
      else {

        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => Job()));

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Precheck failed!!'),
          duration: const Duration(seconds: 3),

        ));


        //}
        //}
      }
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${resp["msg"]}'),
        duration: const Duration(seconds: 5),

      ));
    }
  }

  _getDeclaration(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        declaration_items = list
            .map((model) => Declaration.fromJson(model,
            status: trailer1_precheck_status))
            .toList();

      });
    }
  }
}
