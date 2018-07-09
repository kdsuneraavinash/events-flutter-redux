import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/event_info_card.dart'
    show EventInfoCard;
import 'package:event_app/event.dart' show Event;

/// Page to show Event Information/Description
class EventInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "${this.event.eventName}",
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ),
        EventInfoCard(
          icon: Icons.description,
          title: "Description",
          description: this.event.description,
        ),
        EventInfoCard(
          icon: Icons.access_time,
          title: "Time",
          description: this.event.time,
        ),
        EventInfoCard(
          icon: Icons.date_range,
          title: "Date",
          description: this.event.date,
        ),
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
      ],
    );
  }

  EventInfo(this.event);
  final Event event;
}
