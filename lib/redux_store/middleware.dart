import 'dart:async';
import 'package:event_app/state/query.dart';
import 'package:redux_epics/redux_epics.dart' show EpicStore;
import 'package:rxdart/rxdart.dart' show Observable, TypeToken;
import 'package:event_app/redux_store/actions.dart'
    show
        FirestoreRefreshAll,
        FirestoreListenToUpdates,
        FirestoreDocumentsChanged;
import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, Query, QuerySnapshot;
import 'package:event_app/redux_store/store.dart' show EventStore;

Stream<dynamic> readAllDocuments(
    Stream<dynamic> actions, EpicStore<EventStore> store) {
  return new Observable(actions)
      // Only take these type actions
      // This will be done when FirestoreStartConnection is fired
      // Then stream is initialized
      // Stream will send Actions as Firestore sends undates
      .ofType(TypeToken<FirestoreRefreshAll>())
      // Switch map will cancel operation done before and start new one
      // So only one getAllEvents will run at a time
      .switchMap(
    // This function will take the FirestoreStartConnection and start the stream
    (FirestoreRefreshAll requestAction) {
      return getAllEvents(store)
          // Send each sent update to a Action and dispatch it
          .map((querySnapshot) =>
              FirestoreDocumentsChanged(querySnapshot, DateTime.now()));
    },
  );
}

// Observe the stream and issue events
Observable<QuerySnapshot> getAllEvents(EpicStore<EventStore> store) {
  // Get documents
  // Convert resulting QuerySnapshot to a list of events
  return Observable(
      Stream.fromFuture(getStream(store.state.searchOptions).getDocuments()));
}

// Starts the stream of listening to changes
Stream<dynamic> listenToChanges(
    Stream<dynamic> actions, EpicStore<EventStore> store) {
  return Observable(actions)
      // Triggered by FirestoreListenToUpdates actions
      .ofType(TypeToken<FirestoreListenToUpdates>())
      // Switch map because we need this to stop and begin from start
      // when new FirestoreListenToUpdates Comes
      .switchMap(
    // This function will start the stream of data
    (FirestoreListenToUpdates requestAction) {
      // If detected change get changed documents and do this on each
      return getChanges(store).map(
        (QuerySnapshot data) {
          // What to do to every document change
          return FirestoreDocumentsChanged(data, DateTime.now());
        },
      );
    },
  );
}

// Observe the stream and issue events when document changed
Observable<QuerySnapshot> getChanges(EpicStore<EventStore> store) {
  // Get stream of changing snapshots
  return Observable(getStream(store.state.searchOptions).snapshots());
}

Query getStream(QueryOptions options) {
  Query query = Firestore.instance.collection("events");
  bool isDescending = options.orderOption == QueryOptionsOrder.DESCENDING;

  switch (options.sortOption) {
    case QueryOptionsSort.START:
      query = query.orderBy("start", descending: isDescending);
      break;
    case QueryOptionsSort.END:
      query = query.orderBy("end", descending: isDescending);
      break;
    case QueryOptionsSort.NAME:
      query = query.orderBy("eventName", descending: isDescending);
      break;
  }

  if (options.limitOption == QueryOptionsLimit.LIMIT) {
    query = query.limit(options.limitOptionData);
  }

  return query;
}
