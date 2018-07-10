import 'package:event_app/event.dart' show Event;
import 'package:flutter/material.dart';

class EventAlarmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.alarm_on),
          onPressed: () => null,
        ),
        title: Text(this.event.eventName),
        subtitle: Text(this.event.organizer),
      ),
    );
  }

  EventAlarmButton(this.event);
  final Event event;
}
