
import 'package:flutter/material.dart';

class Utility {

static showMsg(BuildContext context,String msg)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content:  Text(msg),
    duration: const Duration(seconds: 3),

  ));

}


static Future<bool>  onBackPressed(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              return Future.value(false);
            //  Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              //Navigator.of(context).pop(true);
              return Future.value(true);
            },
          )
        ],
      );
    },
  ) ?? false;
}
}