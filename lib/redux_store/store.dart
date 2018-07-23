import 'dart:async';

import 'package:redux_epics/redux_epics.dart' show EpicStore;
import 'package:rxdart/rxdart.dart' show Observable, TypeToken;
import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent;
import 'package:event_app/test_data.dart' show events;
import 'package:event_app/redux_store/actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart'
    show DocumentSnapshot, Firestore, QuerySnapshot;

/// The main store object
/// Here this also is the VIew Model (No separate class for view modal)
class EventStore {
  final List<Event> eventList;
  final List<FlaggedEvent> flaggedList;
  final List<EventNotification> notifications;

  factory EventStore.loadEventStore() {
    return EventStore(
      events.map((v) => Event.fromDataList(v)).toList(),
      List<FlaggedEvent>(),
      List<EventNotification>(),
    );
  }

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
      return getEventUpdates()
          // Send each sent update to a Action and dispatch it
          .map((events) => new FirestoreEventsAdded(events))
          // When to stop : when FirestoreEndConnection is fired
          .takeUntil(
              actions.where((action) => action is FirestoreEndConnection)); // 8
    },
  );
}

Observable<List<Event>> getEventUpdates() {
  Observable<QuerySnapshot> obs = new Observable(Stream
      .fromFuture(Firestore.instance.collection("events").getDocuments()));

  return obs.map((QuerySnapshot allDocs) {
    List<Event> allEvents = [];
    for (DocumentSnapshot doc in allDocs.documents) {
      print(doc.data['eventName']);
      allEvents.add(Event.fromFirestoreDoc(doc));
    }
    return allEvents;
  }); // 6
}
