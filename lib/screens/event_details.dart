import 'package:flutter/material.dart';

import 'package:event_app/event.dart' show Event;

class EventDetails extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.event.eventName),
      ),
      body: EventDetailsBody(event: event,),
    );
  }

  EventDetails({this.event});
  final Event event;

}

class EventDetailsBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return PageView(
      children: <Widget>[

      ],
    );
  }

  EventDetailsBody({this.event});
  final Event event;
}

class EventInfo extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container();
  }

}
