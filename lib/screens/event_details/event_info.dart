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
          icon: Icons.arrow_drop_down_circle  ,
          title: "Description",
          description: this.event.description,
        ),
      ],
    );
  }

  EventInfo(this.event);
  final Event event;
}
