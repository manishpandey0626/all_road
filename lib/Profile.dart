import 'package:all_road/MyColors.dart';
import 'package:all_road/SessionManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'api.dart';

class Profile extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  Profile({Key key, this.data}) : super(key: key);

  @override
  ProfileState createState() => ProfileState(data);
}

class ProfileState extends State<Profile> {
  Map<String, dynamic> data = Map<String, dynamic>();

  ProfileState(this.data);
Map<String,dynamic> user_data=null;
  String driver_id="";
  String driver_name="";
  String profile_img="";
  String licence_no="";
  String licence_expiry="";
  String commencement_date="";

 @override
  void initState() {
  _getDriverData();
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
          "Profile",
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
                        'asset/images/city_driver.svg',
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
                              "",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "",
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
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
          )),
          SliverToBoxAdapter(
              child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.fill,
                                    image:  NetworkImage(
                                        imageUrl+profile_img)
                                )
                            )),
                        SizedBox(height: 20,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: MyColors.greyBackground,
                          ),
                        child: Column(
                          children: [
                            getRow("Name",driver_name ),
                            getRow("Licence No", licence_no),
                            getRow("Licence Expiry Date", licence_expiry),
                            getRow("Commencement Date",commencement_date),
                          ],
                        ),
                        ),
                        SizedBox(height: 20,)



                      ]))),
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

  Widget getRow(String heading, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         /* Icon(
            icon,
            color: Color(0xff009933),
            size: 20,
          ),
          SizedBox(
            width: 8,
          ),*/
          Expanded(
              child:
              Text(heading, style: TextStyle(color: Colors.black38))),
          SizedBox(
            width: 8,
          ),
          Expanded(
              child: Text(text, style: TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

_getDriverData() async
{
  user_data= await SessionManager.getUserDetails();
  setState(() {

    driver_name=user_data[SessionManager.driverName];
    licence_no=user_data[SessionManager.licence_no];
    licence_expiry=user_data[SessionManager.licence_expiry];
    commencement_date=user_data[SessionManager.commencement];
    profile_img=user_data[SessionManager.profile_img];
  });


}
}
