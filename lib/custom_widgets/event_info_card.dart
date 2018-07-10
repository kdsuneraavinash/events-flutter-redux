import 'package:flutter/material.dart';

/// Card to show event information in EventDetailsPage
class EventInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          style: BorderStyle.solid,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: this.handleTap,
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                this.icon,
                color: Theme.of(context).primaryColor,
              ),
              title: Text(
                this.title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Text(this.description,
                  style: descriptionTextStyle,
                  softWrap: true,
                  textAlign: TextAlign.justify),
            )
          ],
        ),
      ),
    );
  }

  EventInfoCard(
      {this.icon,
      this.title,
      this.description,
      this.descriptionTextStyle,
      this.handleTap});
  final IconData icon;
  final String title;
  final String description;
  final TextStyle descriptionTextStyle;
  final VoidCallback handleTap;
}
