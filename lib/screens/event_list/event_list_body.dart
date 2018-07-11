import 'dart:async';

import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// Body of EventListWindow.
/// Contains of a ListView consisting of Event Cards so Users can scroll
/// through Events.
/// TODO: Use a firestore connection to load events.
/// Also contains a RefreshIndicator so users can refresh Event Content.
/// TODO: Add Event Refresh Process
/// Async function which will update Events when refreshed with
/// RefreshIndicator.
/// Currently set to wait 3s and display a SnackBar.
/// TODO: Add a real refresh method
class EventListBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
      builder: (context, store) => buildEventListBody(context, store.eventList),
      converter: (store) => store.state,
    );
  }

  Widget buildEventListBody(BuildContext context, List<Event> events) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (_, index) => EventCard(events[index]),
        itemCount: events.length,
      ),
      onRefresh: () => _handleRefresh(context),
    );
  }

  /// Refresh indicator method (Placeholder)
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
