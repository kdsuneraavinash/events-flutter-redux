import 'dart:async';
import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/redux_store/actions.dart'
    show FirestoreStartConnection;

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
    return StoreBuilder<EventStore>(
      builder: (context, store) => buildEventListBody(context, store),
    );
  }

  Widget buildEventListBody(BuildContext context, Store<EventStore> store) {
    Map<String, Event> events = store.state.eventList;
    return RefreshIndicator(
      child: events.length > 0
          ? ListView.builder(
              itemBuilder: (_, index) =>
                  EventCard(events[events.keys.elementAt(index)]),
              itemCount: events.length,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      onRefresh: () => _handleRefresh(context, store),
    );
  }

  /// Refresh indicator method (Placeholder)
  Future<Null> _handleRefresh(context, Store<EventStore> store) async {
    // TODO: Add a method to detect FirestoreStartConnection success and close
    store.dispatch(FirestoreStartConnection());
    // Currently implement to close after 4 seconds
    await Future.delayed(Duration(seconds: 4));
    return;
  }
}
