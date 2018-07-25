import 'dart:async';
import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter_redux/flutter_redux.dart'
    show StoreBuilder, StoreConnector;
import 'package:event_app/redux_store/actions.dart' show FirestoreRefreshAll;

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
      builder: (context, state) => buildEventListBody(context, state),
      converter: (store) => store.state,
    );
  }

  Widget buildEventListBody(BuildContext context, EventStore store) {
    Map<String, Event> events = store.eventList;
    return RefreshAllPullToRefresh(
      child: events.length > 0
          ? ListView.builder(
              itemBuilder: (_, index) =>
                  EventCard(events.keys.elementAt(index)),
              itemCount: events.length,
            )
          : Center(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      child: Text("Loading Data"),
                      padding: EdgeInsets.all(16.0),
                    ),
                    SizedBox(
                      child: LinearProgressIndicator(),
                      width: MediaQuery.of(context).size.width / 2,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class RefreshAllPullToRefresh extends StatelessWidget {
  final Widget child;

  const RefreshAllPullToRefresh({this.child});

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: (context, store) => RefreshIndicator(
            child: this.child,
            // Refresh indicator method (Placeholder)
            onRefresh: () async {
              // TODO: Add a method to detect FirestoreStartConnection success and close
              store.dispatch(FirestoreRefreshAll());
              // Currently implement to close after 4 seconds
              await Future.delayed(Duration(seconds: 4));
              return;
            },
          ),
    );
  }
}
