import 'dart:math';

import 'package:all_road/MyColors.dart';
import 'package:flutter/material.dart';

ThemeData basicTheme() {

  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline1: base.headline1.copyWith(
          color:Colors.black87,
            fontFamily: 'Quicksand',
          fontSize: 22.0,
          fontWeight: FontWeight.w500
        ),
        headline2: base.headline2.copyWith(
            fontFamily: 'Quicksand',
            fontSize: 18.0,
            color:Colors.black87,
            fontWeight: FontWeight.w400
        ),
        headline3: base.headline3.copyWith(
            fontSize: 14,
            fontFamily: 'Quicksand',
            color:Colors.grey[800],
            fontWeight: FontWeight.w400
        ),
        headline4: base.headline4.copyWith(
            color:Colors.black,
            fontFamily: 'Quicksand',
            fontSize: 14,
            fontWeight: FontWeight.w700
        ),
        headline5: base.headline5.copyWith(
            color:Colors.black,
            fontFamily: 'Quicksand',
            fontSize: 20.0,
            fontWeight: FontWeight.w700
        ),
       /* caption: base.caption.copyWith(
          color: Color(0xFFCCC5AF),
        )*/
      bodyText1: base.bodyText1.copyWith(
          fontFamily: 'Quicksand',
      //    color: Color(0xFF807A6B)
      ),
        bodyText2: base.bodyText2.copyWith(
          fontFamily: 'Quicksand',
          fontWeight: FontWeight.w500
     )

    );
  }
  final ThemeData base = ThemeData.light();

  return ThemeData(
      textTheme: _basicTextTheme(base.textTheme),
      fontFamily: 'Quicksand',


     // primarySwatch: generateMaterialColor(Color(0xFFebf7ef)));
      primaryColor: Color(0xFF77ba1c),
    //  primaryColor: Color(0xFFC9E3A4),
       primaryColorDark: Color(0xFF8FAD15),
     accentColor: Color(0xFF77ba1c),
       popupMenuTheme: PopupMenuThemeData( color: Colors.orange),
    colorScheme: ColorScheme.light().copyWith(
      primary: Color(0xFF77ba1c),

      primaryVariant: Color(0xFF8FAD15)
    ),

    );


 /* base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      primarySwatch: generateMaterialColor(Color(0xFFED1B24)),
    //  primaryColor: generateMaterialColor(Color(0xFFED1B24)),
    //  primaryColorDark: Colors.blueGrey[900],
    //  primaryColorLight: Colors.blueGrey[100],
      //primaryColor: Color(0xff4829b2),
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      accentColor: Color(0xFFFFF8E1),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      buttonColor: Colors.white,
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));*/


}


MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}
int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
