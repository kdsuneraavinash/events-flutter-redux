import 'package:flutter/material.dart';

class EventInfoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: OutlineButton(
        onPressed: this.handleTap,
        highlightElevation: 10.0,
        padding: EdgeInsets.all(8.0),
        child: ListTile(
          leading: Icon(
            this.icon,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            this.title,
            style: this.textStyle != null ? this.textStyle: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }

  EventInfoButton({this.icon, this.title, this.handleTap, this.textStyle});
  final IconData icon;
  final String title;
  final TextStyle textStyle;
  final VoidCallback handleTap;
}
