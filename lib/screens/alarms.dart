import 'package:event_app/event.dart' show Event;
import 'package:event_app/test_data.dart' show events;
import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/event_alarm_button.dart' show EventAlarmButton;

class AlarmsManager extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Alarms Manager"),
      ),
      body: ListView(
        children: this.alarmEvents.map(this.mapToButton).toList(),
      ),
    );
  }

  EventAlarmButton mapToButton(Event event) {
    return EventAlarmButton(event);
  }

  final List<Event> alarmEvents = events.map((v) => Event.fromDataList(v)).toList();
}