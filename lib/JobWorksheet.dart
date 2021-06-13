import 'dart:convert';
import 'dart:developer';

import 'package:all_road/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataClasses.dart';
import 'api.dart';

class JobWorksheet extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobWorksheet({Key key, this.data}) : super(key: key);

  @override
  JobWorksheetState createState() => JobWorksheetState(data);
}

class JobWorksheetState extends State<JobWorksheet> {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobWorksheetState(this.data);

  List<JobWorksheetData> items = [];
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
    _getJobWorksheets();
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
              "JobWorksheets",
              style: Theme.of(context).textTheme.headline1,
            )),
        actions: [],
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          )),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.3,
              //mainAxisSpacing: 1,
              // crossAxisSpacing: 1,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(

                         padding:EdgeInsets.all(2),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            //clipBehavior: Clip.hardEdge,

                            children: [
                              Image.network(imageUrl + items[index].links,
                                  fit: BoxFit.fitWidth,
                                   width: 150,
                              height: 150,),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: Text(
                                    items[index].name,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                            ],
                          ),
                         decoration: BoxDecoration(
                            color: MyColors.greyBackground,
                            borderRadius: BorderRadius.all(Radius.circular(10)),


                          ),
                        ),
                      ),
                    ));
              },
              childCount: items.length,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: true,
            fillOverscroll: true,
            child: Container(color: Colors.white),
          )
        ]),
      ),
    );
  }

  _getJobWorksheets() async {
    Map<String, dynamic> post_data = Map<String, dynamic>();
    post_data['act'] = "GET_JOB_WORKSHEETS";
    post_data['job_id'] = data['job_id'];
    final response = await API.postData(post_data);

    debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        items = list.map((model) => JobWorksheetData.fromJson(model)).toList();
      });
    }
  }

  _launchURL(String image) async {
    if (image.isNotEmpty) {
      String url = image;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('File not found!!'),
        duration: const Duration(seconds: 1),
      ));
    }
  }
}
