import 'package:event_app/event.dart' show Event, EventNotification;
import 'package:event_app/test_data.dart' show events;

/// The main store object
class EventStore {
  final List<Event> eventList;
  final List<Event> flaggedList;
  final Map<Event, bool> alarmsList;
  final List<EventNotification> notifications;
  final Event currentSelectedEvent;

  static EventStore loadEventStore() {
    return EventStore(
      events.map((v) => Event.fromDataList(v)).toList(),
      List(),
      null,
      Map(),
      List(),
    );
  }

  EventStore(this.eventList, this.flaggedList, this.currentSelectedEvent,
      this.alarmsList, this.notifications);
}
