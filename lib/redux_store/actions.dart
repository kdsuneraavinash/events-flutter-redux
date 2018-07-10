import 'package:event_app/event.dart' show Event;

class AddToEventList {
  final Event eventToAdd;
  AddToEventList(this.eventToAdd);
}

class AddToFlaggedList {
  final Event eventToAdd;
  AddToFlaggedList(this.eventToAdd);
}

class RemoveFromEventList {
  final Event eventToRemove;
  RemoveFromEventList(this.eventToRemove);
}

class RemoveFromFlaggedList {
  final Event eventToRemove;
  RemoveFromFlaggedList(this.eventToRemove);
}

class ChangeCurrentEvent {
  final Event currentEvent;
  ChangeCurrentEvent(this.currentEvent);
}
