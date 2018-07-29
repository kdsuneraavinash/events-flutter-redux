import 'package:flutter/material.dart';
import 'package:event_app/state/event.dart';

/// Page to show Event Information/Description
class EventInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        EventInfoCard(
          icon: Icons.location_city,
          title: "Venue",
          description: this.event.location,
        ),
        EventInfoCard(
          icon: Icons.people,
          title: "Organizers",
          description: this.event.organizer,
        ),
        EventInfoCard(
          icon: Icons.description,
          title: "Description",
          description: this.event.description,
        ),
      ],
    );
  }

  final Event event;

  EventInfo(this.event);
}

/// Card to show event information in EventDetailsPage
class EventInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            this.icon,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            this.title,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Text(this.description,
              softWrap: true, textAlign: TextAlign.justify),
        )
      ],
    );
  }

  EventInfoCard({this.icon, this.title, this.description});

  final IconData icon;
  final String title;
  final String description;
}
