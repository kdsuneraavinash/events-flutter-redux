import 'package:event_app/redux_store/actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:event_app/state/event.dart';
import 'package:event_app/state/flagged.dart';
import 'package:event_app/state/notification.dart';
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:redux_persist/redux_persist.dart' show PersistLoadedAction;

/// Connect to all reducers
EventStore reducers(EventStore eventStore, dynamic action) {
  if (action is AddToFlaggedList) {
    return addToFlaggedListReducer(eventStore, action);
  } else if (action is RemoveFromFlaggedList) {
    return removeFromFlaggedListReducer(eventStore, action);
  } else if (action is ChangeAlarmState) {
    return changeAlarmState(eventStore, action);
  } else if (action is MarkNotificationsAsRead) {
    return markNotificationsAsReadReducer(eventStore, action);
  } else if (action is ClearNotifications) {
    return clearNotificationsReducer(eventStore, action);
  } else if (action is FirestoreDocumentsChanged) {
    return firestoreEventsAddedReducer(eventStore, action);
  } else if (action is SearchOptionsSet) {
    return searchOptionsSetReducer(eventStore, action);
  } else if (action is AddNotification) {
    return addNotificationReducer(eventStore, action);
  } else if (action is PersistLoadedAction<EventStore>) {
    return persistLoadedActionReducer(eventStore, action);
  } else {
    return eventStore.copyWith();
  }
}

/// Event Store Loaded
/// flutter_redux_persist action
EventStore persistLoadedActionReducer(
    EventStore eventStore, PersistLoadedAction action) {
  if (action.state == null) return eventStore;
  return action.state;
}

/// Add event to flagged events list
/// returns a copy of original list
EventStore addToFlaggedListReducer(
    EventStore eventStore, AddToFlaggedList action) {
  return eventStore.copyWith(
    flaggedList: List.from(eventStore.flaggedList)
      ..add(
        // Adds to flagged list: default alarm state is True
        FlaggedEvent(action.eventToAddID, true),
      ),
  );
}

/// Remove event from flagged events list
/// returns a copy of original list
EventStore removeFromFlaggedListReducer(
    EventStore eventStore, RemoveFromFlaggedList action) {
  return eventStore.copyWith(
    flaggedList: List.from(eventStore.flaggedList)
      ..removeWhere((v) => v.eventID == action.eventToRemoveID),
  );
}

EventStore addNotificationReducer(
    EventStore eventStore, AddNotification action) {
  return eventStore.copyWith(
    notifications: List.from(eventStore.notifications)
      ..add(
        // Add a notification
        EventNotification(
          action.text,
          action.type,
          action.time,
        ),
      ),
  );
}

/// Alarm turned ON or turned OFF
EventStore changeAlarmState(EventStore eventStore, ChangeAlarmState action) {
  List<FlaggedEvent> flaggedList = List.from(eventStore.flaggedList);

  // Create new flagged item with alarm state off/on depending on state
  for (int index = 0; index < eventStore.flaggedList.length; index++) {
    if (flaggedList[index].eventID == action.alarmEventID) {
      flaggedList[index] = FlaggedEvent(action.alarmEventID, action.state);
    }
  }

  return eventStore.copyWith(flaggedList: flaggedList);
}

///Marks all notifications as read
EventStore markNotificationsAsReadReducer(
    EventStore eventStore, MarkNotificationsAsRead action) {
  return eventStore.copyWith(
    notifications: eventStore.notifications
        .map((v) =>
            // New notification mapping with marked as read
            EventNotification(v.message, v.type, v.timestamp)..markAsRead())
        .toList(),
  );
}

/// Empty all notifications
EventStore clearNotificationsReducer(
    EventStore eventStore, ClearNotifications action) {
  return eventStore.copyWith(notifications: List());
}

/// Loaded all events from Firebase
/// Have to do few tasks
/// * load all events to allEvents
/// * Filter flagged items which are only present in both
/// (Remove flagged items which are not in new list)
/// * Detect unchanged documents
/// * Detect changed content documents (Add a notification)
/// * Detect removed documents (Add a notification)
/// * Detect newly added documents (Add a notification)
/// TODO: Find if these can be done easily using Data Streams in FireStore
EventStore firestoreEventsAddedReducer(
    EventStore eventStore, FirestoreDocumentsChanged action) {
  // Get all events
  Map<String, Event> allEvents = {};
  List<DocumentSnapshot> documents = action.querySnapshot.documents;

  for (DocumentSnapshot doc in documents) {
    allEvents[doc.documentID] = Event.fromFirestoreDoc(doc);
  }

  // Get all flagged events that are in current events and update their event property
  List<FlaggedEvent> allFlagged = [];
  // For each old event
  for (String newEventID in allEvents.keys) {
    // check new events
    for (FlaggedEvent flagged in eventStore.flaggedList) {
      // whether there is a item with same id
      if (flagged.eventID == newEventID) {
        // if there is; add that event to flagged events because it is present in both lists
        allFlagged.add(FlaggedEvent(newEventID, flagged.alarmStatus));
        break;
      }
    }
  }
  return eventStore.copyWith(eventList: allEvents, flaggedList: allFlagged);
}

EventStore searchOptionsSetReducer(
    EventStore eventStore, SearchOptionsSet action) {
  return eventStore.copyWith(searchOptions: action.newSearchOptions);
}
