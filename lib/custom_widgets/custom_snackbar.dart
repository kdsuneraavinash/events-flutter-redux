import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message,
    [SnackBarAction action]) {
  Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          action: action,
        ),
      );
}
