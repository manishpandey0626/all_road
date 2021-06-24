import 'package:all_road/utility.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'Home.dart';
import 'Profile.dart';
import 'job.dart';
import 'main.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 1;

  List<Widget> _widgetOptions = <Widget>[
    Job(),
    Home(),
    Profile(),

  ];


  @override
  void initState() {
    /*FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null ) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: '@drawable/ic_notification',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      *//*Navigator.pushNamed(context, '/message',
          arguments: MessageArguments(message, true));*//*

    });*/
  }


  @override
  Widget build(BuildContext context) {



    return WillPopScope(
      onWillPop: onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
        AssetImage("asset/images/Truck1.png"),


      ),
              label: "Job",
              activeIcon: ImageIcon(
                AssetImage("asset/images/Truck1.png"),
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,

              ),
              label: "Dashboard",
              activeIcon: Icon(
                Icons.home,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,

              ),
              label: "Profile",
              activeIcon: Icon(
              Icons.person,
                color: Theme.of(context).primaryColorDark,
              ),
            ),

          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  Future<bool>  onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the App?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {

                  Navigator.of(context).pop(false);
                 // return Future.value(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              //  return Future.value(true);
              },
            )
          ],
        );
      },
    ) ?? false;
  }

}