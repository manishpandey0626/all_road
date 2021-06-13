import 'package:flutter/material.dart';

import 'Home.dart';
import 'Profile.dart';
import 'job.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Job(),
    Home(),
    Profile(),

  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,

            ),
            label: "Job",
            activeIcon: Icon(
              Icons.settings,
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
    );
  }

}