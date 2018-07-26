import 'package:event_app/redux_store/actions.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show DocumentSnapshot;
import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent, NotificationType;
import 'package:event_app/redux_store/store.dart' show EventStore;

/// Connect to all reducers
EventStore reducers(EventStore eventStore, dynamic action) {
  switch (action.runtimeType) {
    case AddToFlaggedList:
      return addToFlaggedListReducer(eventStore, action);
    case RemoveFromFlaggedList:
      return removeFromFlaggedListReducer(eventStore, action);
    case ChangeAlarmState:
      return changeAlarmState(eventStore, action);
    case MarkNotificationsAsRead:
      return markNotificationsAsReadReducer(eventStore, action);
    case ClearNotifications:
      return clearNotificationsReducer(eventStore, action);
    case FirestoreDocumentsChanged:
      return firestoreEventsAddedReducer(eventStore, action);
    case SearchOptionsSet:
      return searchOptionsSetReducer(eventStore, action);
    default:
      return eventStore;
  }
}

/// Add event to flagged events list
/// returns a copy of original list
EventStore addToFlaggedListReducer(
    EventStore eventStore, AddToFlaggedList action) {
  List<FlaggedEvent> flaggedList = eventStore.flaggedList;
  List<EventNotification> notifications = eventStore.notifications;
  return EventStore(
    eventStore.eventList,
    List.from(flaggedList)
      ..add(
        // Adds to flagged list: default alarm state is True
        FlaggedEvent(action.eventToAddID, true),
      ),
    List.from(notifications)
      ..add(
        // Add a notification about it
        EventNotification(
          "${eventStore.eventList[action.eventToAddID].eventName} added to pinned events",
          NotificationType.ADD_FLAG,
          action.time,
        ),
      ),
    eventStore.searchOptions,
  );
}

/// Remove event from flagged events list
/// returns a copy of original list
EventStore removeFromFlaggedListReducer(
    EventStore eventStore, RemoveFromFlaggedList action) {
  List<FlaggedEvent> flaggedList = eventStore.flaggedList;
  List<EventNotification> notifications = eventStore.notifications;
  return EventStore(
    eventStore.eventList,
    // Remove item by event ID
    List.from(flaggedList)
      ..removeWhere((v) => v.eventID == action.eventToRemoveID),
    List.from(notifications)
      ..add(
        // Add a notification about it
        EventNotification(
          "${eventStore.eventList[action.eventToRemoveID].eventName} removed from pinned events",
          NotificationType.ADD_FLAG,
          action.time,
        ),
      ),
    eventStore.searchOptions,
  );
}

/// Alarm turned ON or turned OFF
EventStore changeAlarmState(EventStore eventStore, ChangeAlarmState action) {
  List<EventNotification> notifications = eventStore.notifications;
  List<FlaggedEvent> flaggedList = List.from(eventStore.flaggedList);

  // Create new flagged item with alarm state off/on depending on state
  for (int index = 0; index < eventStore.flaggedList.length; index++) {
    if (flaggedList[index].eventID == action.alarmEventID) {
      flaggedList[index] = FlaggedEvent(action.alarmEventID, action.state);
    }
  }

  return EventStore(
    eventStore.eventList,
    flaggedList,
    List.from(notifications)
      ..add(
        // Add a notification
        EventNotification(
          "${eventStore.eventList[action.alarmEventID].eventName} alarm state changed to : ${action
              .state ? "ON" : "OFF"}",
          NotificationType.ALARM,
          action.time,
        ),
      ),
    eventStore.searchOptions,
  );
}

///Marks all notifications as read
EventStore markNotificationsAsReadReducer(
    EventStore eventStore, MarkNotificationsAsRead action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    eventStore.notifications
        .map((v) =>
            // New notification mapping with marked as read
            EventNotification(v.message, v.type, v.timestamp)..markAsRead())
        .toList(),
    eventStore.searchOptions,
  );
}

/// Empty all notifications
EventStore clearNotificationsReducer(
    EventStore eventStore, ClearNotifications action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    // Empty list assigned to event list
    List(),
    eventStore.searchOptions,
  );
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

  // TODO: Notifications when adding, removing editing events removed
  // because it clashes with method to Query
  // FIXME: Find a method to fix notification
  // TODO: Maybe create a new document with notifications and sync with it?
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

  return EventStore(
    allEvents,
    allFlagged,
    eventStore.notifications,
    eventStore.searchOptions,
  );
}

EventStore searchOptionsSetReducer(
    EventStore eventStore, SearchOptionsSet action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    eventStore.notifications,
    action.newSearchOptions,
  );
}
