
import 'package:flutter/material.dart';

class Utility {

static showMsg(BuildContext context,String msg)
{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content:  Text(msg),
    duration: const Duration(seconds: 3),

  ));

}
}