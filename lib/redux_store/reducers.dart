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
    case FirestoreEventsAdded:
      return firestoreEventsAddedReducer(eventStore, action);
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
    EventStore eventStore, FirestoreEventsAdded action) {
  // Get all events
  Map<String, Event> allEvents = {};
  for (DocumentSnapshot doc in action.querySnapshot.documents) {
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

  // Check for event detail changes [ID same but some other field different]
  // For each old event
  for (String oldEventID in eventStore.eventList.keys) {
    if (allEvents.containsKey(oldEventID)) {
      // If the same element exists in new list, stop; because it has not changed then
      if (allEvents[oldEventID].similar(eventStore.eventList[oldEventID])) {
        continue;
      } else {
        // If there is element with same id [Remember there cant be events with same id twice in list]
        eventStore.notifications.add(
          EventNotification(
            "${allEvents[oldEventID].organizer} changed some details in Event ${allEvents[oldEventID].eventName}.",
            NotificationType.CHANGE,
            action.time,
          ),
        );
      }
    } else {
      // No element with atlease same id
      // So this is removed
      eventStore.notifications.add(
        EventNotification(
          "${eventStore.eventList[oldEventID].organizer} removed Event: ${eventStore.eventList[oldEventID].eventName}.",
          NotificationType.REMOVE,
          action.time,
        ),
      );
    }
  }

  // For each new event
  for (String newEventID in allEvents.keys) {
    // if its id contains in a old event pass
    if (eventStore.eventList.containsKey(newEventID)) {
      continue;
    } else {
      // If not add a notification
      eventStore.notifications.add(
        EventNotification(
          "${allEvents[newEventID].organizer} added a new Event: ${allEvents[newEventID].eventName}.",
          NotificationType.ADD,
          action.time,
        ),
      );
    }
  }

  // TODO: Find changed data and add notifications
  return EventStore(
    allEvents,
    allFlagged,
    eventStore.notifications,
  );
}

// FIX: W/linker  (19716): "/data/app/com.google.android.gms-rADQWXpGsd1vzZWseM1VqQ==/base.apk!/lib/x86/libconscrypt_gmscore_jni.so" unused DT entry: type 0xf arg 0x119
