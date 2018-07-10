import 'package:event_app/redux_store/actions.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart';

EventStore reducers(EventStore eventStore, dynamic action) {
  switch (action.runtimeType) {
    case AddToEventList:
      return addToEventListReducer(eventStore, action);
    case AddToFlaggedList:
      return addToFlaggedListReducer(eventStore, action);
    case ChangeCurrentEvent:
      return changeCurrentEventReducer(eventStore, action);
    default:
      return eventStore;
  }
}

EventStore addToEventListReducer(EventStore eventStore, AddToEventList action) {
  List<Event> eventList = eventStore.eventList;
  return EventStore(
    List.from(eventList)..add(action.eventToAdd),
    eventStore.flaggedList,
    eventStore.currentSelectedEvent,
  );
}

EventStore addToFlaggedListReducer(
    EventStore eventStore, AddToFlaggedList action) {
  List<Event> flaggedList = eventStore.flaggedList;
  return EventStore(
    eventStore.eventList,
    List.from(flaggedList)..add(action.eventToAdd),
    eventStore.currentSelectedEvent,
  );
}

EventStore changeCurrentEventReducer(
    EventStore eventStore, ChangeCurrentEvent action) {
  return EventStore(
    eventStore.eventList,
    eventStore.flaggedList,
    action.currentEvent,
  );
}
