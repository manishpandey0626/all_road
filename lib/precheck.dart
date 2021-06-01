import 'dart:convert';
import 'dart:io';

import 'package:all_road/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


import 'DataClasses.dart';
import 'api.dart';
import 'induction.dart';
import 'job.dart';

class Precheck extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  Precheck({Key key, this.data}) : super(key: key);

  @override
  PrecheckState createState() => PrecheckState(data);
}

class PrecheckState extends State<Precheck> {
  Map<String, dynamic> data = Map<String, dynamic>();

  PrecheckState(this.data);

  List<PreCheckQuestion> items = [];
  List<String> banners = [];
  String cat_name;
  int _current = 0;
  int item_cnt = 0;

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    // cat_name = data["cat_name"];
    _getPrecheck("act=GET_PRECHECK_QUES");
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
              "Pre Check",
              style: Theme
                  .of(context)
                  .textTheme
                  .headline1,
            )),
        actions: [
          /*GestureDetector(
            onTap: ()
            {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBusiness(),
                      settings: RouteSettings(

                      )));
            },
            child: Padding(
              padding: EdgeInsets.fromLTRB(0,0,16,0),
              child: Row(

                  children:[Icon(Icons.add_box,color: Color(0xff009933),),Text("Add Business",style: TextStyle(fontWeight: FontWeight.w700,color: Color(0xff009933)),)]
              ),
            ),
          )*/
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

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),

                ),
                  child:Padding(
                      padding:EdgeInsets.fromLTRB(20,16,0,16),
                      child: Text("Truck Question",style: Theme.of(context).textTheme.headline1,))
              )),
          SliverList(
            delegate:
            SliverChildBuilderDelegate((BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {},
                  child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical:0),
                        decoration: BoxDecoration(
                          color: MyColors.greyBackground,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),

                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                                  Padding(
                                     padding: EdgeInsets.fromLTRB(16,16,16,0),
                                      child: Text(
                                    items[index].question,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headline5,
                                  )),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                          value: items[index].option1,
                                          groupValue: items[index].myanswer,
                                          onChanged: (val) {
                                            setState(() {
                                              items[index].myanswer = val;
                                            });
                                          }),
                                      Text(items[index].option1),   ]),
                                      SizedBox(width:50),
                                      Row(

                                      children: [Radio(
                                          value: items[index].option2,

                                          groupValue: items[index].myanswer,
                                          onChanged: (val) {
                                            setState(() {
                                              items[index].myanswer = val;
                                            });
                                          }),
                                      Text(items[index].option2)])

                                ],
                              ),
                            ]),
                      )));
            }, childCount: items.length),
          ),
          SliverToBoxAdapter(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  color: Colors.white,
                  child: items.length>0 ?ElevatedButton(

                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        )),
                    onPressed: () {
                      bool flag=items.any((element) => element.answer !=element.myanswer);
                      print("flag===>${flag}");

                      if(flag)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('You Failed in test. Try Again'),
                          duration: const Duration(seconds: 5),

                        ));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Induction()));
                      }
                      else
                      {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('You Passed the test.'),
                          duration: const Duration(seconds: 5),

                        ));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Job()));
                      }

                    },
                    child: Text('Submit Test',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ):SizedBox())),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(color: Colors.white,

            ),
          )
        ]),
      ),
    );
  }

  _getPrecheck(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        items = list.map((model) => PreCheckQuestion.fromJson(model)).toList();
      });
    }
  }


}
