import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:all_road/MyColors.dart';
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
      backgroundColor: MyColors.myCustomGreen,
      //drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: MyColors.myCustomGreen,
        elevation: 0.0,
        title: Align(
            alignment: Alignment.center,
            child: Text(
              "Worksheet",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            )),
        actions: [
        ],
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
                                  "",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Collect all types  \ndocuments",
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
                      getImageFromGallery(index);
                    },
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          //   clipBehavior: Clip.hardEdge,
                          child: Column(
                            //clipBehavior: Clip.hardEdge,

                            children: [


                              items[index].file == null ? SvgPicture.asset(
                                'asset/images/jpg_logo.svg',
                                alignment: Alignment.center,

                              ) : Image.file(
                                items[index].file,
                                width: 50,
                                height: 50,
                              ),
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
                  lines: 4),
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,

            child: Container(
              color: Colors.white,

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
                      _saveData();
                    },
                    child: Text('Submit',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              )
          )

        ]),
      ),
    );
  }

  _getWorksheet() async {
    Map<String, dynamic> data = Map<String, dynamic>();
    data["act"] = "GET_WORKSHEET";
    data["ids"] = "1,2";
    final response = await API.postData(data);

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
    String ids= items.map((e) => e.id).toList().join(",");
      data1['act'] = "ADD_WORKSHEET";
      data1["user_id"] = driver_id;
      data1["truck_id"] = data['truck_id'];
      data1["job_id"] = data['job_id'];
      data1["trailer1_id"] = data["trailer1_id"];
      data1["trailer2_id"] = data["trailer2_id"];
      data1["ids"] = ids;

    //debugger();
      List<String> paths = [];
      paths.addAll(items.map((element) => element.file.path));
      var response = await API.postMultipartData(data1, paths);

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
