import 'package:cloud_firestore/cloud_firestore.dart' show QuerySnapshot;
import 'package:event_app/event.dart' show Event;

/// Actions:
/// Will only contain classes to distinguish each command for reducer and
/// contain actions

/// Add an event to flagged event list
class AddToFlaggedList {
  final Event eventToAdd;
  final DateTime time;

  AddToFlaggedList(this.eventToAdd, this.time);
}

/// Remove an event from flagged event list
class RemoveFromFlaggedList {
  final Event eventToRemove;
  final DateTime time;

  RemoveFromFlaggedList(this.eventToRemove, this.time);
}

/// Change alarm state
class ChangeAlarmState {
  final Event alarmEvent;
  final bool state;
  final DateTime time;

  ChangeAlarmState(this.alarmEvent, this.state, this.time);
}

class MarkNotificationsAsRead {}

class ClearNotifications {}

class FirestoreStartConnection {}

class FirestoreEndConnection {}

class FirestoreEventsAdded {
  final QuerySnapshot querySnapshot;
  final DateTime time;

  FirestoreEventsAdded(this.querySnapshot, this.time);
}
