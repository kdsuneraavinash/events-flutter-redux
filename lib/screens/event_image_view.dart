import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/screens/event_image_view/middle_controls.dart'
    show MiddleControls;
import 'package:event_app/screens/event_image_view/bottom_controls.dart'
    show BottomControls;

/// State of EventImageView
/// Controls Star Marking State.
class EventImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(this.event.eventName),
        actions: <Widget>[],
      ),
      backgroundColor: Colors.black,
      body: EventImageBody(this.event),
    );
  }

  EventImageView(this.event);
  final Event event;
}

/// Body of EventImageView
/// Hosts PageView and buttons.
class EventImageBody extends StatelessWidget {
  EventImageBody(this.event);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MiddleControls(this.event),
        BottomControls(this.event),
      ],
    );
  }
}
