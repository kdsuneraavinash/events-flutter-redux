import 'package:event_app/custom_widgets/event_info_card.dart'
    show EventInfoCard;
import 'package:event_app/event.dart' show Event;
import 'package:flutter/material.dart';

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
