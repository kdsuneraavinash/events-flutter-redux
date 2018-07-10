import 'package:event_app/redux_store/actions.dart';
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/event.dart' show Event;

/// Connect to all reducers
EventStore reducers(EventStore eventStore, dynamic action) {
  switch (action.runtimeType) {
    case AddToFlaggedList:
      return addToFlaggedListReducer(eventStore, action);
    case RemoveFromFlaggedList:
      return removeFromFlaggedListReducer(eventStore, action);
    case ChangeCurrentSelectedEvent:
      return changeCurrentEventReducer(eventStore, action);
    case ChangeAlarmState:
      return changeAlarmState(eventStore, action);
    default:
      return eventStore;
  }
}

/// Add event to flagged events list
/// returns a copy of original list
EventStore addToFlaggedListReducer(
    EventStore eventStore, AddToFlaggedList action) {
  List<Event> flaggedList = eventStore.flaggedList;
  List<List<String>> notifications = eventStore.notifications;
  return EventStore(
    eventStore.eventList,
    List.from(flaggedList)..add(action.eventToAdd),
    eventStore.currentSelectedEvent,
    eventStore.alarmsList..putIfAbsent(action.eventToAdd, () => true),
    List.from(notifications)
      ..add([
        "FLAG_ADD",
        "${action.eventToAdd.eventName} added to pinned events",
        DateTime.now().toIso8601String(),
      ]),
  );
}

/// Remove event from flagged events list
/// returns a copy of original list
EventStore removeFromFlaggedListReducer(
    EventStore eventStore, RemoveFromFlaggedList action) {
  List<Event> flaggedList = eventStore.flaggedList;
  List<List<String>> notifications = eventStore.notifications;
  return EventStore(
    eventStore.eventList,
    List.from(flaggedList)..remove(action.eventToRemove),
    eventStore.currentSelectedEvent,
    eventStore.alarmsList..remove(action.eventToRemove),
    List.from(notifications)
      ..add([
        "FLAG_REM",
        "${action.eventToRemove.eventName} removed from pinned events",
        DateTime.now().toIso8601String(),
      ]),
  );
}

/// Change current selected event
/// Current selected event is the event displayed in EventInfo page, etc...
EventStore changeCurrentEventReducer(
    EventStore eventStore, ChangeCurrentSelectedEvent action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    action.selectedEvent,
    eventStore.alarmsList,
    eventStore.notifications,
  );
}

EventStore changeAlarmState(EventStore eventStore, ChangeAlarmState action) {
  List<List<String>> notifications = eventStore.notifications;
  Map<Event, bool> alarmsList = Map.from(eventStore.alarmsList);
  alarmsList[action.alarmEvent] = action.state;
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    eventStore.currentSelectedEvent,
    alarmsList,
    List.from(notifications)
      ..add(
        [
          "ALARM",
          "${action.alarmEvent.eventName} alarm state changed to : ${action.state ? "ON": "OFF"}",
          DateTime.now().toString(),
        ],
      ),
  );
}
