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
    return EventStore(
        Map<String, Event>(), List<FlaggedEvent>(), List<EventNotification>(), {
      QueryOptions.BYNAME: "",
      QueryOptions.ALL: "",
      QueryOptions.ASCENDING: ""
    });
  }

  EventStore(
      this.eventList, this.flaggedList, this.notifications, this.searchOptions);

  EventStore copyWith(
      {Map<String, Event> eventList,
      List<FlaggedEvent> flaggedList,
      List<EventNotification> notifications,
      Map<QueryOptions, String> searchOptions}) {
    eventList ??= this.eventList;
    flaggedList ??= this.flaggedList;
    notifications ??= this.notifications;
    searchOptions ??= this.searchOptions;
    return EventStore(eventList, flaggedList, notifications, searchOptions);
  }

  ///
  /// json is a map like
  /// {
  /// 'eventList':[{'eventName':'Event 101', 'organizer': 'Nobody', ...}, {..}, ...]
  /// 'flaggedList': [{'eventID':'HHfd8sDDS', 'alarmStatus': true}, {..}, ...]
  /// 'notifications' : [{'message':'Event Added by Boo Boo', 'type': 'ADD'}, {..}, ...]
  /// TODO: Add Query Options
  /// }
  ///
  static EventStore fromJson(dynamic json) {
    // Parse Events
    Map<String, Event> eventList = {};
    for (Map<String, dynamic> parsedEvent in List.from(json["eventList"])) {
      Event newEvent = Event.fromJson(parsedEvent.values.elementAt(0));
      eventList[newEvent.id] = newEvent;
    }

    // Parse Flagged Events
    List<FlaggedEvent> flaggedList = [];
    for (Map<String, dynamic> parsedFlagged in List.from(json["flaggedList"])) {
      flaggedList.add(FlaggedEvent.fromJson(parsedFlagged));
    }

    // Parse Flagged Events
    List<EventNotification> notifications = [];
    for (Map<String, dynamic> parsedNotification
        in List.from(json["notifications"])) {
      notifications.add(EventNotification.fromJson(parsedNotification));
    }

    // TODO: Add Query Options parse
    return EventStore(eventList, flaggedList, notifications, Map());
  }

  // Convert to Json
  dynamic toJson() {
    Map<String, dynamic> json = {};

    // Parse EventList to JSON
    List toParseEventList = [];
    for (String eventID in this.eventList.keys) {
      Event event = this.eventList[eventID];
      toParseEventList.add({eventID: event.toJson()});
    }
    json['eventList'] = toParseEventList;

    // Parse EventList to JSON
    List toParseFlaggedList = [];
    for (FlaggedEvent flagged in this.flaggedList) {
      toParseFlaggedList.add(flagged.toJson());
    }
    json['flaggedList'] = toParseFlaggedList;

    // Parse EventList to JSON
    List toParseNotificationsList = [];
    for (EventNotification notification in this.notifications) {
      toParseNotificationsList.add(notification.toJson());
    }
    json['notifications'] = toParseNotificationsList;

    json['searchOptions'] = {};

    return json;
  }
}

enum QueryOptions {
  // Order by
  BYSTART,
  BYEND,
  BYNAME,
  // Order Direction
  DESCENDING,
  ASCENDING,
  // Limit to a number
  ALL,
  LIMIT,
}
