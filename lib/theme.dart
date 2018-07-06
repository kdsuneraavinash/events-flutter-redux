import 'package:flutter/material.dart';

ThemeData kAndroidTheme = _buildAndroidTheme();

/// Define default theme for Android devices
ThemeData _buildAndroidTheme(){
  return ThemeData(
    primaryColor: Colors.blue[900],
    accentColor: Colors.redAccent,
  );
}