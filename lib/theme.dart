import 'package:flutter/material.dart';

ThemeData kAndroidTheme = _buildAndroidTheme();

/// Define default theme for Android devices
ThemeData _buildAndroidTheme(){
  return ThemeData(
    primaryColor: Colors.blue[900],
    accentColor: Colors.redAccent,
    textTheme: TextTheme(
      body1: TextStyle(
        letterSpacing: 0.7,
        fontWeight: FontWeight.w400
      ),
      button: TextStyle(
          letterSpacing: 0.5,
          fontWeight: FontWeight.w500
      ),
      subhead: TextStyle(
          letterSpacing: 0.9,
          fontWeight: FontWeight.w800
      ),
    ),
    dividerColor: Colors.black,
  );
}