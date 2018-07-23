import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/event.dart' show Event;

/// Actions:
/// Will only contain classes to distinguish each command for reducer and
/// contain actions

/// Add an event to flagged event list
class AddToFlaggedList {
  final Event eventToAdd;

  AddToFlaggedList(this.eventToAdd);
}

/// Remove an event from flagged event list
class RemoveFromFlaggedList {
  final Event eventToRemove;

  RemoveFromFlaggedList(this.eventToRemove);
}

/// Change alarm state
class ChangeAlarmState {
  final Event alarmEvent;
  final bool state;

  ChangeAlarmState(this.alarmEvent, this.state);
}

class MarkNotificationsAsRead {}

class ClearNotifications {}

class LoadEvents {}

class FirestoreStartConnection {}

class FirestoreEndConnection {}

class FirestoreEventsAdded {
  final QuerySnapshot querySnapshot;

  FirestoreEventsAdded(this.querySnapshot);
}
