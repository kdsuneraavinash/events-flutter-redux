import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/windows/event_image_view/middle_controls.dart'
    show MiddleControls;
import 'package:event_app/windows/event_image_view/bottom_controls.dart'
    show BottomControls;

/// Window that shows Event Banner Separately
class EventImageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventImageViewState(event);

  /// Constructor to pass image Url and tag to identify hero
  /// Will create new DataStore object and pass that down Widget Tree
  /// TODO: Implement a method better than passing data down
  EventImageView(this.event);
  final Event event;
}

/// State of EventImageView
/// Controls Star Marking State.
class EventImageViewState extends State<EventImageView> {
  EventImageViewState(this.event);
  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(this.event.eventName),
        centerTitle: true,
        actions: <Widget>[],
      ),
      backgroundColor: Colors.black,
      body: EventImageBody(this.event),
    );
  }
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
        BottomControls(),
      ],
    );
  }
}
