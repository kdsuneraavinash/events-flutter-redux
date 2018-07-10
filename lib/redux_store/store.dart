import 'package:event_app/event.dart';

class EventStore{
  final List<Event> eventList;
  final List<Event> flaggedList;
  final Event currentSelectedEvent;

  EventStore(this.eventList, this.flaggedList, this.currentSelectedEvent);
}