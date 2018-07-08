import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Define default theme for All devices
ThemeData buildTheme(BuildContext context){
  return ThemeData(
    primaryColor: Colors.blue[900],
    accentColor: Colors.red[900],
    textTheme: TextTheme(
      body1: TextStyle(
        fontWeight: FontWeight.w700,
      ),
      button: TextStyle(
          letterSpacing: 2.0,
          fontWeight: FontWeight.w500
      ),
      subhead: TextStyle(
          letterSpacing: 1.2,
          fontWeight: FontWeight.w800
      ),
      headline: TextStyle(
          letterSpacing: 2.0,
          fontWeight: FontWeight.w800,
          decoration: TextDecoration.underline,
        fontSize: 20.0,
        color: Colors.blue[900],
      ),
      body2: TextStyle(
          letterSpacing: 2.0,
          fontWeight: FontWeight.w800
      ),
    ),
    dividerColor: Colors.blue[700],
    splashColor: Colors.blue[500],
    primaryColorDark: Colors.black,
    secondaryHeaderColor: Colors.black,
    platform: defaultTargetPlatform,
  );
}