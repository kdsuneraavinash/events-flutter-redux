import 'package:flutter/material.dart';

/// Creates a Round Icon Button which hovers.
///
/// Main Color will be Primary Color.
/// Otherwise works as a normal button.
class RoundedButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: StadiumBorder(),
      padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
      onPressed: onPressed,
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            buttonIcon,
            color: Theme.of(context).primaryTextTheme.body1.color,
          ),
          SizedBox(
            width: 12.0,
          ),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.body1.color,
              fontSize: 16.0,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  RoundedButton({this.buttonIcon, this.text, this.onPressed});
  final IconData buttonIcon;
  final String text;
  final VoidCallback onPressed;
}
