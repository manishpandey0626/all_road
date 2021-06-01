import 'package:all_road/MyColors.dart';
import 'package:all_road/video.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'audio.dart';
import 'driver_manual.dart';
import 'driver_test.dart';
import 'job.dart';

class Induction extends StatefulWidget {
  Induction({Key key}) : super(key: key);

  @override
  InductionState createState() => InductionState();
}

class InductionState extends State<Induction> {
  InductionState();

  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );
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
              "Induction",
              style: Theme.of(context).textTheme.headline1,
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
        child: Column(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 10,
            ),
            Stack(children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: SvgPicture.asset(
                    'asset/images/Download_amico.svg',
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
                          "Quick Assessment",
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Easily download data \nfrom induction",
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ]),
                ),
              )
            ]),
            SizedBox(
              height: 10,
            )
          ]),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          //  fit:StackFit.expand,
                          children: [
                            Positioned(
                              top: 30,
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                  color: MyColors.greyBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),

                                child: Text(
                                  "View Audio",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                // constraints: BoxConstraints(minWidth: double.infinity),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),

                                child:Padding(
                                  padding: EdgeInsets.all(15),
                                  child: SvgPicture.asset(
                                    'asset/images/headphones.svg',
                                    alignment: Alignment.center,
                                    width: 10,
                                    height: 10,

                                ),
                                )
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Audio()));
                      },
                    ),
                    SizedBox(height:20),
                    GestureDetector(
                      child: Container(

                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          //  fit:StackFit.expand,
                          children: [
                            Positioned(
                              top: 30,
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                  color: MyColors.greyBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),

                                child: Text(
                                  "View Video",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                // constraints: BoxConstraints(minWidth: double.infinity),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  child:Padding(
                                    padding: EdgeInsets.all(15),
                                    child: SvgPicture.asset(
                                      'asset/images/video_camera.svg',
                                      alignment: Alignment.center,
                                      width: 10,
                                      height: 10,

                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Video()));
                      },
                    ),
                    SizedBox(height:20),

                    GestureDetector(
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        child: Stack(
                          //  fit:StackFit.expand,
                          children: [
                            Positioned(
                              top: 30,
                              child: Container(
                                alignment: Alignment.center,
                                height: 70,
                                width: MediaQuery.of(context).size.width - 30,
                                decoration: BoxDecoration(
                                  color: MyColors.greyBackground,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                ),

                                child: Text(
                                  "View PDF's",
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                // constraints: BoxConstraints(minWidth: double.infinity),
                              ),
                            ),
                            Positioned(
                              left: 20,
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                  child:Padding(
                                    padding: EdgeInsets.all(15),
                                    child: SvgPicture.asset(
                                      'asset/images/pdf.svg',
                                      alignment: Alignment.center,
                                      width: 10,
                                      height: 10,

                                    ),
                                  )
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: ()
                      {
                        Map<String, dynamic> data =
                        Map<String, dynamic>();
                        data['cat_id'] = "1";
                        data['cat_name']="test";
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DriverManual(data:data)));
                      },
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DriverTest()));
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Job()));
                      },
                      child: Text('Start Test',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
