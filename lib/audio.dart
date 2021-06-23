import 'dart:convert';

import 'package:all_road/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DataClasses.dart';
import 'api.dart';

class Audio extends StatefulWidget {
  Audio({Key key}) : super(key: key);

  @override
  AudioState createState() => AudioState();
}

class AudioState extends State<Audio> {
  AudioState();

  List<AudioData> items = [];
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
    _getAudios("act=GET_AUDIO");
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
        centerTitle: true,
        title: Text(
          "Audios",
          style: Theme.of(context).textTheme.headline1,
        ),
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
                              "Your Training Requires \nImplementation",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "A minute of audio is \nworth 1.8 million \nwords",
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
              childAspectRatio: 1,
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
                          clipBehavior: Clip.hardEdge,
                          child: Stack(
                            //clipBehavior: Clip.hardEdge,

                            children: [


                              Align(
                                alignment: Alignment.topCenter,
                                child: AspectRatio(
                                  aspectRatio: 2/1,
                                  child:Image.network(imageUrl+items[index].disp_img_url,fit:BoxFit.fill)
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: AspectRatio(
                                  aspectRatio: 2/1,
                                  child: Container(
                                    alignment: Alignment.center,
                                 padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                       child: Text('title this is the long title .title this is the long title .',
                                         overflow: TextOverflow.ellipsis,)
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 2/1,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: GestureDetector(
                                    onTap: (){
                                      _launchURL(items[index].file_name);
                                    },
                                    child: SvgPicture.asset(
                                      'asset/images/play_button.svg',
                                      alignment: Alignment.center,

                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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

  _getAudios(String url) async {
    final response = await API.getData(url);

    //debugger();
    var response_data = json.decode(response.body);
    if (this.mounted) {
      setState(() {
        Iterable list = response_data["audio"];
        items = list.map((model) => AudioData.fromJson(model)).toList();
        //items.addAll(list.map((model) => AudioData.fromJson(model)).toList());
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
