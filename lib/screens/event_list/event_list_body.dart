import 'dart:async';
import 'package:flutter/material.dart';

import 'package:event_app/event.dart' show Event;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:event_app/test_data.dart' show events;

/// Body of EventListWindow.
/// Contains of a ListView consisting of Event Cards so Users can scroll
/// through Events.
/// TODO: Use a database to load events.
/// TODO: Connect with internet.
/// Also contains a RefreshIndicator so users can refresh Event Content.
/// TODO: Add Event Refresh Process
class EventListBody extends StatefulWidget {
  @override
  EventListBodyState createState() {
    return new EventListBodyState();
  }

  /// Async function which will update Events when refreshed with
  /// RefreshIndicator.
  /// Currently set to wait 3s and display a SnackBar.
  /// TODO: Add a real refresh method.
  Future<Null> _handleRefresh(context) {
    final Completer<Null> completer = Completer<Null>();
    Timer(
      Duration(seconds: 3),
      () {
        completer.complete(null);
      },
    );
    return completer.future.then((_) {});
  }
}

class EventListBodyState extends State<EventListBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (_, index) => EventCard(
              index: index,
              event: eventList[index],
            ),
        itemCount: events.length,
      ),
      onRefresh: () => widget._handleRefresh(context),
    );
  }

  List<Event> eventList = events.map((v) => Event.fromDataList(v)).toList();
}
