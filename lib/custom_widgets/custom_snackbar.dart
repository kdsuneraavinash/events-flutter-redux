import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).accentColor,
        ),
      );
}
