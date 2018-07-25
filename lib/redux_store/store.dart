import 'dart:async';
import 'package:redux_epics/redux_epics.dart' show EpicStore;
import 'package:rxdart/rxdart.dart' show Observable, TypeToken;
import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent;
import 'package:event_app/redux_store/actions.dart'
    show FirestoreStartConnection, FirestoreEventsAdded;
import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, QuerySnapshot;

/// The main store object
/// Here this also is the VIew Model (No separate class for view modal)
class EventStore {
  final List<Event> eventList;
  final List<FlaggedEvent> flaggedList;
  final List<EventNotification> notifications;

  factory EventStore.empty() {
    return EventStore(
      List<Event>(),
      List<FlaggedEvent>(),
      List<EventNotification>(),
    );
  }

  EventStore(this.eventList, this.flaggedList, this.notifications);
}

Stream<dynamic> readAllDocuments(
    Stream<dynamic> actions, EpicStore<EventStore> store) {
  return new Observable(actions)
      // Only take these type actions
      // This will be done when FirestoreStartConnection is fired
      // Then stream is initialized
      // Stream will send Actions as Firestore sends undates
      .ofType(new TypeToken<FirestoreStartConnection>())
      //
      .switchMap(
    // This function will take the FirestoreStartConnection and start the stream
    (FirestoreStartConnection requestAction) {
      return getAllEvents()
          // Send each sent update to a Action and dispatch it
          .map((querySnapshot) => new FirestoreEventsAdded(querySnapshot, DateTime.now()));
    },
  );
}

// Observe the stream and issue events
Observable<QuerySnapshot> getAllEvents() {
  // Get documents
  // Convert resulting QuerySnapshot to a list of events
  return Observable(Stream
      .fromFuture(Firestore.instance.collection("events").getDocuments()));
}
