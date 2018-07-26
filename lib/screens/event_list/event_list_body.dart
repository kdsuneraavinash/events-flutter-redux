import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;

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
    return events.length > 0
        ? ListView.builder(
            itemBuilder: (_, index) => EventCard(events.keys.elementAt(index)),
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
          );
  }
}
