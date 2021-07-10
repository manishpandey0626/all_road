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

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'api.dart';

class FuelLogDashboard extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  FuelLogDashboard({Key key, this.data}) : super(key: key);

  @override
  FuelLogDashboardState createState() => FuelLogDashboardState(data);
}

class FuelLogDashboardState extends State<FuelLogDashboard> {
  Map<String, dynamic> data = Map<String, dynamic>();
  var amount = TextEditingController();
  var truckId = TextEditingController();
  var liters = TextEditingController();
  var comment = TextEditingController();

  Truck selected_truck;
  List<Truck> truck_items = [];
  List<File> upload_files = [];
  final ImagePicker _picker = ImagePicker();


  FuelLogDashboardState(this.data);

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    _getTruck("act=GET_TRUCK");
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
          "Fuel Log",
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
                            'asset/images/gas_station.svg',
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
                                  "Maintain your fuel usage \nfor smooth functioning.",
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .headline2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                /*Text(
                                  "Maintain your fuel usage \nfor smooth functioning.",
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

                          Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 20,vertical:20),
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
                              onChanged: (Truck Value) {
                                setState(() {
                                  selected_truck = Value;
                                  if(selected_truck.truck_cat =="1")
                                  {

                                  }
                                });
                              },
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
                          _getInputText(amount, "Amount", "Amount", "",is_numeric: true),
                          _getInputText(liters, "Liters", "Liters", "",is_numeric: true),
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
          SliverToBoxAdapter(
            child:Container(
              color:Colors.white,
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
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,

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
          /* inputFormatters: is_numeric
              ? [FilteringTextInputFormatter.digitsOnly]
              : [FilteringTextInputFormatter.deny("~")],*/
          keyboardType: is_numeric ? TextInputType.numberWithOptions(decimal:true) : TextInputType.text,
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
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
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

    if(selected_truck==null)
    {
      Utility.showMsg(context,"Plese select Truck.");
      return;
    }

    if(amount.text.isEmpty)
    {
      Utility.showMsg(context,"Plese enter amount.");
      return;
    }
    if(liters.text.isEmpty)
    {
      Utility.showMsg(context,"Please enter liters.");
      return;
    }


    if(upload_files.length<1)
    {
      Utility.showMsg(context,"Plese upload atleast one fuel log image.");
      return;
    }

    Map<String, dynamic> data1 = Map<String, String>();

    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];


    data1['act'] = 'ADD_FUEL_LOG';
    data1["user_id"] = driver_id;
    data1["truck_id"] = selected_truck.id;
    data1["job_id"] = "";
    data1["amount"] = amount.text;
    data1["liters"] = liters.text;
    data1["comment"] = comment.text;


    List<String> paths=[];
    paths.addAll(upload_files.map((file)=>file.path));

    var response = await API.postMultipartData(data1,paths);
    //debugger();
    var resp = json.decode(response);
    if (resp["status"]) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Fuel log saved successfully.'),
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

  _getTruck(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        // debugger();
        truck_items = list.map((model) => Truck.fromJson(model)).toList();
        if(data !=null) {
          if(truck_items.length>0) {
            selected_truck = truck_items.singleWhere((element) => element.id ==
                data['selected_truck'].id);
          }
        }
      });
    }
  }
}
