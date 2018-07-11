import 'package:event_app/custom_widgets/launch_button.dart' show LaunchButton;
import 'package:event_app/event.dart' show Event;
import 'package:flutter/material.dart';

/// Page to show Event Contact Links/Phone Numbers
class EventLinks extends StatelessWidget {
  EventLinks(this.event);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: this.event.contact == null
          ? []
          : this.event.contact.map((tmp) => LaunchButton(tmp)).toList(),
    );
  }

  final Event event;
}
