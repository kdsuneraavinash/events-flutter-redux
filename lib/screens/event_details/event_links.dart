import 'package:event_app/event.dart' show Event, EventContact;
import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/launch_button.dart' show LaunchButton;

/// Page to show Event Date/Time
class EventTimeDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: event.contact == null
            ? []
            : event.contact.map(mapToLaunchButton).toList());
  }

  LaunchButton mapToLaunchButton(EventContact contact) {
    return LaunchButton(contact);
  }

  EventTimeDate(this.event);
  final Event event;
}
