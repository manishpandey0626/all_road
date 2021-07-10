import 'dart:convert';
import 'dart:io';

import 'package:all_road/JobWorksheet.dart';
import 'package:all_road/MyColors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataClasses.dart';
import 'SessionManager.dart';
import 'api.dart';

class JobListing extends StatefulWidget {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobListing({Key key, this.data}) : super(key: key);

  @override
  JobListingState createState() => JobListingState(data);
}

class JobListingState extends State<JobListing> {
  Map<String, dynamic> data = Map<String, dynamic>();

  JobListingState(this.data);

  List<JobListingData> items = [];
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
    _getJobListings();
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
          "Job Listing",
          style: Theme.of(context).textTheme.headline1,
        ),
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
                                  "Check the details \nof completed tasks",
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
          SliverList(
            /*separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,*/
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      /*   border: Border(
                            top: BorderSide(

                                color: Colors.grey.shade300, width: 0.5))*/
                    ),
                    padding: index==0? EdgeInsets.fromLTRB(20, 20, 20, 0):EdgeInsets.fromLTRB(20, 0, 20, 0) ,
                    child: Column(

                      children: [

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset(
                                'asset/images/suitcase.svg',
                                alignment: Alignment.center,
                                width: 20,
                                height: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(width: 20),
                              Flexible(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children:[ Text(
                                    items[index].rego_no,
                                    style: Theme.of(context).textTheme.headline5,
                                  ),
                                    Text(
                                      items[index].start_date,
                                      style:   TextStyle(
                                    color:Colors.black45
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              IconButton(
                                onPressed: () {
                                  Map<String,dynamic> data= Map<String,dynamic>();
                                  data['job_id']=items[index].id;
                                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => JobWorksheet(data:data)));

                                },
                                icon: SvgPicture.asset(
                                  'asset/images/google_docs.svg',
                                  width: 20,
                                  height: 20,
                                  alignment: Alignment.center,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              /*IconButton(
                              onPressed: () {
                                requestDownload(items[index].file_name);
                              },
                              icon: SvgPicture.asset(
                                'asset/images/download.svg',
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),*/
                            ])
                        ,Divider()],
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(color:Colors.white),
          )
        ]),
      ),
    );
  }

  _getJobListings() async {
    Map<String,dynamic> user_data= await SessionManager.getUserDetails();
    String driver_id= user_data[SessionManager.driverId];
    //driver_id="1";

    Map<String,dynamic> post_data=Map<String,dynamic>();
    post_data['act']="GET_JOB_LISTING";
    post_data['driver_id']=driver_id;
    final response = await API.postData(post_data);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["data"];
        items = list.map((model) => JobListingData.fromJson(model)).toList();
      });
    }
  }

  _launchURL(String image) async {

    if(image.isNotEmpty) {
      String url = imageUrl + image;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('File not found!!'),
        duration: const Duration(seconds: 1),

      ));
    }
  }

/*  Future<void> requestDownload(String _name) async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.


      final dir =
      await getExternalStorageDirectory(); //From path_provider package
      var _localPath = dir.path;
      final savedDir = Directory(_localPath);
      await savedDir.create(recursive: true).then((value) async {
        String _taskid = await FlutterDownloader.enqueue(
          url: imageUrl+_name,
          fileName: _name,
          savedDir: _localPath,
          showNotification: true,
          openFileFromNotification: true,
        );
        print(_taskid);
      });
    }
  }*/
}
