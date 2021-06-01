import 'dart:convert';

import 'package:all_road/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'DataClasses.dart';
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
  List<String> banners = [];
  String cat_name;
  int _current = 0;
  int item_cnt = 0;
  Truck selected_truck;

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    // cat_name = data["cat_name"];
    _getTruck("act=GET_TRUCK");
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
                    onChanged: (Truck Value) {
                      setState(() {
                        selected_truck = Value;
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

                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    color: Colors.white,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {},
                      child: Text('Submit Test',
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
        truck_items = list.map((model) => Truck.fromJson(model)).toList();
      });
    }
  }
}
