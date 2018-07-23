import 'package:event_app/event.dart'
    show EventNotification, FlaggedEvent, NotificationType;
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

EventStore firestoreEventsAddedReducer(EventStore eventStore,FirestoreEventsAdded action){
  return EventStore(
    action.events,
    eventStore.flaggedList,
    List(),
  );
}