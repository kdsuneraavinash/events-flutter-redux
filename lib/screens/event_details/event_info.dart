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
        _buildInlineListTile(
          "Start Date",
          this.event.startTime,
          Icons.hourglass_full,
          context,
        ),
        _buildInlineListTile(
          "End Date",
          this.event.endTime,
          Icons.hourglass_empty,
          context,
        ),
        Divider(),
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

  Widget _buildInlineListTile(
      String title, String text, IconData icon, BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(title),
      trailing: Text(text),
    );
  }

  final Event event;

  EventInfo(this.event);
}
