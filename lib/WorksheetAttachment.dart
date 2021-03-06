import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:all_road/MyColors.dart';
import 'package:all_road/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'api.dart';

class WorksheetAttachment extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  WorksheetAttachment({Key key, this.data}) : super(key: key);

  @override
  WorksheetAttachmentState createState() => WorksheetAttachmentState(data);
}

class WorksheetAttachmentState extends State<WorksheetAttachment> {
  Map<String, dynamic> data = Map<String, dynamic>();

  WorksheetAttachmentState(this.data);

  final ImagePicker _picker = ImagePicker();
  List<WorksheetAttachmentData> items = [];
  List<String> banners = [];
  String cat_name;
  int _current = 0;
  int item_cnt = 0;
  var comment = TextEditingController();

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    // cat_name = data["cat_name"];
    _getWorksheet();
    /* _getBanners("act=GET_BANNER&cat_id=" + data["cat_id"]);*/
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      //drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: MyColors.myCustomGreen,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Worksheet",
          style: Theme
              .of(context)
              .textTheme
              .headline1,
        ),
        actions: [
        ],
        // backgroundColor: Color(0xFFecf7ef),
      ),
      body: SafeArea(
        child: CustomScrollView(controller: _scrollController, slivers: [
          SliverToBoxAdapter(
              child: Container(
                color: MyColors.myCustomGreen,
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
                              'asset/images/add_file_bro.svg',
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
                                    "Collect and check the \ndocuments before \nswitching on the \nengine",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline2,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  /*Text(
                                    "Collect and check the documents \nbefore switching on the engine",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline3,
                                  ),*/
                                ]),
                          ),
                        )
                      ]),
                      SizedBox(
                        height: 10,
                      )
                    ]),
              )),
          SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              )),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,

              //mainAxisSpacing: 1,
              // crossAxisSpacing: 1,
            ),
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      //getImageFromGallery(index);
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: 150,
                              color: Colors.grey[50],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  //mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    SizedBox(height:8),
                                    Material(

                                      child: InkWell(

                                        onTap: (){
                                          Navigator.pop(context);
                                          getImageFromGallery(index);
                                        },

                                        child: Container(
                                          //color: Colors.transparent,
                                          padding:EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                          child: Row(
                                              children:[
                                                Icon(Icons.image,
                                                color:Colors.grey[700]),
                                                SizedBox(width:16),
                                                Text("Gallery",style: TextStyle(color:Colors.grey[700],fontSize: 18),)
                                              ]
                                          ),
                                        ),
                                      ),
                                    ),
                                      SizedBox(height:8),
                                      Material(
                                        child: InkWell(
                                          onTap: (){
                                            Navigator.pop(context);
                                            getImageFromCamera(index);
                                          },
                                          child: Container(

                                            padding:EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                            child: Row(
                                              children:[
                                                Icon(Icons.camera,
                                                    color:Colors.grey[700]),
                                                SizedBox(width:8),
                                                Text("Camera",style: TextStyle(color:Colors.grey[700],fontSize: 18),)
                                              ]
                                            ),
                                          ),
                                        ),
                                      ),
                                   /* ElevatedButton(
                                      child: const Text('Gallery'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        getImageFromGallery(index);
                                      }

                                    ),*/

                                  ],
                                ),
                              ),
                            );});
                    },
                    child: Container(
                     // color: Colors.red,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          //color:Colors.blue,
                          padding: EdgeInsets.all(10),
                          //   clipBehavior: Clip.hardEdge,
                          child: Column(
                            //clipBehavior: Clip.hardEdge,

                            children: [
                          Stack(
                          children: [
                              Container(
                                width: 100,
                                height:100,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(
                                    color:MyColors.greyBackground,
                                    //border: Border.all(color: Colors.grey[700]),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 8),

                                child: items[index].file == null ? SvgPicture.asset(
                                  'asset/images/jpg_logo.svg',
                                  alignment: Alignment.center,

                                ) : Image.file(
                                  items[index].file,
                                  fit: BoxFit.contain,
                                ),
                              ),Positioned(
                              right:10,
                              top:5,
                              child:
                              items[index].file == null ? SizedBox():
                              GestureDetector(
                                onTap: (){

                                  setState(() {
                                    //items.removeAt(index);
                                    items[index].file=null;
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
                            )]),

                              SizedBox(height: 10),
                              Text(items[index].name,
                                overflow: TextOverflow.ellipsis,),

                            ],
                          ),

                        ),
                      ),
                    ));
              },
              childCount: items.length,
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: _getInputText(comment, "Comment", "Comment", "",
                  lines: 3),
            ),
          ),
          SliverToBoxAdapter(

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
                    /*  bool flag = items.any((element) =>
                      element.file == null);
                      if(flag)
                      {
                        Utility.showMsg(context,"Please select all mentioned documents.");
                        return;
                      }*/

                      _saveData();
                    },
                    child: Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              )
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            fillOverscroll: true,


            child: Container(
              color: Colors.white,

            ),
          ),


        ]),
      ),
    );
  }

  _getWorksheet() async {
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data["act"] = "GET_WORKSHEET";
    post_data["ids"] = data['ids'];
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        items = list.map((model) => WorksheetAttachmentData.fromJson(model))
            .toList();
      });
    }
  }


  Future getImageFromCamera(int index) async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      if (pickedFile != null) {
        items[index].file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImageFromGallery(int index) async {
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (pickedFile != null) {
        File file = File(pickedFile.path);
        var lastSeparator = pickedFile.path.lastIndexOf(Platform.pathSeparator);
        var newPath = pickedFile.path.substring(0, lastSeparator + 1);

        items[index].file = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
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


  _saveData() async {
    Map<String, dynamic> data1 = Map<String, String>();

    Map<String, dynamic> user_data = await SessionManager.getUserDetails();
    String driver_id = user_data[SessionManager.driverId];

    List<WorksheetAttachmentData> selected_items=items.where((element)=>element.file !=null).toList();
    if(selected_items.isEmpty)
      {
        Utility.showMsg(context,"Please upload atleast one document.");
        return;
      }

    String ids= selected_items.map((e) => e.id).toList().join(",");
      data1['act'] = "ADD_WORKSHEET";
      data1["user_id"] = driver_id;
      data1["truck_id"] = data['truck_id'];
      data1["job_id"] = data['job_id'];
      data1["trailer1_id"] = data["trailer1_id"];
      data1["trailer2_id"] = data["trailer2_id"];
      data1["ids"] = ids;

   // debugger();
      List<String> paths = [];
      paths.addAll(selected_items.map((element) => element.file.path));
      var response = await API.postMultipartData(data1, paths);
   // debugger();
      var resp = json.decode(response);
      if (resp["status"]) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Worksheet saved successfully.'),
          duration: const Duration(seconds: 5),

        ));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${resp["msg"]}'),
          duration: const Duration(seconds: 5),

        ));
      }
    }
  }
