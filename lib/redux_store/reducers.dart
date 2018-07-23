import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent, NotificationType;
import 'package:event_app/redux_store/actions.dart';
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
    case LoadEvents:
      return loadEventsReducer(eventStore, action);
    case FirestoreStartConnection:
      return eventStore;
    case FirestoreEndConnection:
      return eventStore;
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
        FlaggedEvent(action.eventToAdd, true),
      ),
    List.from(notifications)
      ..add(
        EventNotification(
          "${action.eventToAdd.eventName} added to pinned events",
          NotificationType.ADD_FLAG,
          DateTime.now(),
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
    List.from(flaggedList)..removeWhere((v) => v.equals(action.eventToRemove)),
    List.from(notifications)
      ..add(
        EventNotification(
          "${action.eventToRemove.eventName} removed from pinned events",
          NotificationType.ADD_FLAG,
          DateTime.now(),
        ),
      ),
  );
}

EventStore changeAlarmState(EventStore eventStore, ChangeAlarmState action) {
  List<EventNotification> notifications = eventStore.notifications;
  List<FlaggedEvent> flaggedList = List.from(eventStore.flaggedList);

  for (int index = 0; index < eventStore.flaggedList.length; index++) {
    if (flaggedList[index].equals(action.alarmEvent)) {
      flaggedList[index] = FlaggedEvent(action.alarmEvent, action.state);
    }
  }

  return EventStore(
    eventStore.eventList,
    flaggedList,
    List.from(notifications)
      ..add(
        EventNotification(
          "${action.alarmEvent.eventName} alarm state changed to : ${action
              .state ? "ON" : "OFF"}",
          NotificationType.ALARM,
          DateTime.now(),
        ),
      ),
  );
}

EventStore markNotificationsAsReadReducer(
    EventStore eventStore, MarkNotificationsAsRead action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    eventStore.notifications
        .map((v) =>
            EventNotification(v.message, v.type, v.timestamp)..markAsRead())
        .toList(),
  );
}

EventStore clearNotificationsReducer(
    EventStore eventStore, ClearNotifications action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    List(),
  );
}

EventStore loadEventsReducer(EventStore eventStore, LoadEvents action) {
  return EventStore.loadEventStore();
}

EventStore firestoreEventsAddedReducer(
    EventStore eventStore, FirestoreEventsAdded action) {
  // Get all events
  List<Event> allEvents = [];
  for (DocumentSnapshot doc in action.querySnapshot.documents) {
    allEvents.add(Event.fromFirestoreDoc(doc));
  }

  // Get all flagged events that are in current events and update their event property
  List<FlaggedEvent> allFlagged = [];
  // For each old event
  for (Event newEvent in allEvents) {
    // check new events
    for (FlaggedEvent flagged in eventStore.flaggedList) {
      // whether there is a item with same id
      if (flagged.event.id == newEvent.id) {
        // if there is; add that event to flagged events because it is present in both lists
        allFlagged.add(FlaggedEvent(newEvent, flagged.alarmStatus));
        break;
      }
    }
  }

  // Check for event detail changes [ID same but some other field different]
  // For each old event
  for (Event oldEvent in eventStore.eventList) {
    // If the same element exists in new list, stop; because it has not changed then
    if (allEvents.any((v) => v.similar(oldEvent))) continue;
    // If there is element with same id [Remember there cant be events with same id twice in list]
    if (allEvents.any((v) => v.id == oldEvent.id)) {
      // Add a notification
      eventStore.notifications.add(
        EventNotification(
          "${oldEvent.eventName} event details changed.",
          NotificationType.CHANGE,
          DateTime.now(),
        ),
      );
    } else {
      // No element with atlease same id
      // So this is removed
      eventStore.notifications.add(
        EventNotification(
          "${oldEvent.organizer} removed Event: ${oldEvent.eventName}.",
          NotificationType.REMOVE,
          DateTime.now(),
        ),
      );
    }
  }

  for (Event newEvent in allEvents){
    if (eventStore.eventList.any((v) => v.id == newEvent.id)) continue;
    eventStore.notifications.add(
        EventNotification(
          "${newEvent.organizer} added a new Event: ${newEvent.eventName}.",
          NotificationType.ADD,
          DateTime.now(),
        ),
      );
  }

  // TODO: Find changed data and add notifications
  return EventStore(
    allEvents,
    allFlagged,
    eventStore.notifications,
  );
}

// FIX: W/linker  (19716): "/data/app/com.google.android.gms-rADQWXpGsd1vzZWseM1VqQ==/base.apk!/lib/x86/libconscrypt_gmscore_jni.so" unused DT entry: type 0xf arg 0x119
