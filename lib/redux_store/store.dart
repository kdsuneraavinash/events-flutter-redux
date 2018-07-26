import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent;

/// The main store object
/// Here this also is the VIew Model (No separate class for view modal)
class EventStore {
  final Map<String, Event> eventList;
  final List<FlaggedEvent> flaggedList;
  final List<EventNotification> notifications;
  final Map<QueryOptions, String> searchOptions;

  factory EventStore.empty() {
    return EventStore(Map<String, Event>(), List<FlaggedEvent>(),
        List<EventNotification>(), Map());
  }

  EventStore(
      this.eventList, this.flaggedList, this.notifications, this.searchOptions);
}

enum QueryOptions {
  // Order by
  BYSTART,
  BYEND,
  BYNAME,
  // Order Direction
  DESCENDING,
  // Limit to a number
  ALL,
  LIMIT,
}
