
import 'package:all_road/FuelLogDashboard.dart';
import 'package:all_road/ImportantLinks.dart';
import 'package:all_road/IncidentLogDashboard.dart';
import 'package:all_road/JobListing.dart';
import 'package:all_road/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'driver_manual2.dart';
import 'login.dart';

class Home extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  Home({Key key, this.data}) : super(key: key);

  @override
  HomeState createState() => HomeState(data);
}

class HomeState extends State<Home> {
  Map<String, dynamic> data = Map<String, dynamic>();

  HomeState(this.data);



  String driver_id;



  @override
  void initState() {
    _scrollController = new ScrollController(
      // NEW
      initialScrollOffset: 0.0, // NEW
      keepScrollOffset: true,
      // NEW
    );

    // cat_name = data["cat_name"];





    /* _getBanners("act=GET_BANNER&cat_id=" + data["cat_id"]);*/
  }

  ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: MyColors.myCustomGreen,
      //drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: MyColors.myCustomGreen,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "Dashboard",
          style: Theme.of(context).textTheme.headline1,
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
                            'asset/images/visual_data_rafiki.svg',
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
                                  "All you need to \nknow is available \non one click.",
                                  style: Theme.of(context).textTheme.headline2,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                /*Text(
                                  "Collect all type document",
                                  style: Theme.of(context).textTheme.headline3,
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
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                ),
              )),
          SliverToBoxAdapter(
            child:Container(
              color:Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){

                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DriverManual2()));
                        },
                        child: Container(
                          width: size.width*0.4,
                          padding:EdgeInsets.all(20),
                          child:Column(
                            children: [
                              SvgPicture.asset(
                                'asset/images/manual.svg',

                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height:10),
                              Text("Driver Manual",style: Theme.of(context).textTheme.headline3,)

                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ImportantLinks()));
                        },
                        child: Container(
                          width: size.width*0.4,
                          padding:EdgeInsets.all(20),
                          child:Column(
                            children: [
                              SvgPicture.asset(
                                'asset/images/link_logo.svg',

                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height:10),
                              Text("Important Links",style: Theme.of(context).textTheme.headline3,)

                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      )

                    ],
                  ),
                  SizedBox(height:20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => JobListing()));
                        },
                        child: Container(
                          width: size.width*0.4,
                          padding:EdgeInsets.all(20),
                          child:Column(
                            children: [
                              SvgPicture.asset(
                                'asset/images/employee.svg',

                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height:10),
                              Text("Jobs",style: Theme.of(context).textTheme.headline3,)

                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => IncidentLogDashboard()));
                        },
                        child: Container(
                          width: size.width*0.4,
                          padding:EdgeInsets.all(20),
                          child:Column(
                            children: [
                              SvgPicture.asset(
                                'asset/images/danger_sign.svg',

                                width: 30,
                                height: 30,
                              ),
                              SizedBox(height:10),
                              Text("Incident Log",style: Theme.of(context).textTheme.headline3,)

                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                              BorderRadius.all(Radius.circular(10))),
                        ),
                      ),


                    ],
                  ),
                  SizedBox(height:20),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FuelLogDashboard()));
                    },
                    child: Container(
                      width: size.width,
                      padding:EdgeInsets.all(20),
                      child:Column(
                        children: [
                          SvgPicture.asset(
                            'asset/images/log_format.svg',

                            width: 30,
                            height: 30,
                          ),
                          SizedBox(height:10),
                          Text("Fuel Log",style: Theme.of(context).textTheme.headline3,)

                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                          BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height:20),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )),
                      onPressed: () {
                       // _saveData();
                        SessionManager.logout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Login()));
                      },
                      child: Text('Logout',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),

                  SizedBox(height:20),
                ]
              )

            )
          ),
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



}
