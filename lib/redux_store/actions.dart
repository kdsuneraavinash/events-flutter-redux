import 'package:cloud_firestore/cloud_firestore.dart' show QuerySnapshot;

/// Actions:
/// Will only contain classes to distinguish each command for reducer and
/// contain actions

/// Add an event to flagged event list
class AddToFlaggedList {
  final String eventToAddID;
  final DateTime time;

  AddToFlaggedList(this.eventToAddID, this.time);
}

/// Remove an event from flagged event list
class RemoveFromFlaggedList {
  final String eventToRemoveID;
  final DateTime time;

  RemoveFromFlaggedList(this.eventToRemoveID, this.time);
}

/// Change alarm state
class ChangeAlarmState {
  final String alarmEventID;
  final bool state;
  final DateTime time;

  ChangeAlarmState(this.alarmEventID, this.state, this.time);
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
