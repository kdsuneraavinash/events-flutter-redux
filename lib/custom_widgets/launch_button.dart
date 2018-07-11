import 'package:event_app/event.dart' show EventContact;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show canLaunch, launch;

/// Button to Launch Call, Message, Web, etc...
/// Will use info from event
class LaunchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          RaisedButton(
            highlightElevation: 10.0,
            padding: EdgeInsets.all(16.0),
            shape: CircleBorder(),
            child: Icon(
              this.eventContact.getIcon(),
              color: Theme.of(context).primaryColor,
            ),
            onPressed: this.launchAction,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "${this.eventContact.getContactMethodString()} :\n${this
                    .eventContact.contactLink} "
                    "(${this.eventContact.contactPerson})",
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Launch in default app
  void launchAction() async {
    if (this.eventContact == null) return;
    String url = this.eventContact.getUrl();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      return;
    }
  }

  LaunchButton(this.eventContact);

  final EventContact eventContact;
}
