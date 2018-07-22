import 'package:event_app/event.dart'
    show Event, EventNotification, FlaggedEvent;
import 'package:event_app/test_data.dart' show events;

/// The main store object
/// Here this also is the VIew Model (No separate class for view modal)
class EventStore {
  final List<Event> eventList;
  final List<FlaggedEvent> flaggedList;
  final List<EventNotification> notifications;

  factory EventStore.loadEventStore(){
    return EventStore(
      events.map((v) => Event.fromDataList(v)).toList(),
      List<FlaggedEvent>(),
      List<EventNotification>(),
    );
  }

  EventStore(this.eventList, this.flaggedList,
      this.notifications);
}
