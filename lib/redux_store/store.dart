import 'package:event_app/event.dart' show Event;

/// The main store object
class EventStore{
  final List<Event> eventList;
  final List<Event> flaggedList;
  final Map<Event, bool> alarmsList;
  final Event currentSelectedEvent;

  EventStore(this.eventList, this.flaggedList, this.currentSelectedEvent, this.alarmsList);
}
