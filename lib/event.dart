import 'package:flutter/material.dart' show IconData, Icons;

/// Launch method for EventContact
enum LaunchMethod { CALL, MESSAGE, WEB, FACEBOOK }

enum NotificationType { ADD_FLAG, REM_FLAG, ALARM }

/// Hold Event Organizer Contact Data
class EventContact {
  String contactPerson;
  String contactLink;
  LaunchMethod method;

  /// Get Icon according to launch method
  IconData getIcon() {
    switch (this.method) {
      case LaunchMethod.CALL:
        return Icons.call;
      case LaunchMethod.MESSAGE:
        return Icons.sms;
      case LaunchMethod.WEB:
      case LaunchMethod.FACEBOOK:
        return Icons.web;
      default:
        return Icons.info;
    }
  }

  /// Get Url to execute the method
  String getUrl() {
    switch (this.method) {
      case LaunchMethod.CALL:
        return "tel:${this.contactLink}";
      case LaunchMethod.MESSAGE:
        return "sms:${this.contactLink}";
      case LaunchMethod.WEB:
      case LaunchMethod.FACEBOOK:
        return "${this.contactLink}";
      default:
        return "";
    }
  }

  /// Get String according to contact method
  String getContactMethodString() {
    switch (this.method) {
      case LaunchMethod.CALL:
        return "Call";
      case LaunchMethod.MESSAGE:
        return "Message";
      case LaunchMethod.WEB:
        return "Website";
      case LaunchMethod.FACEBOOK:
        return "Facebook";
      default:
        return "";
    }
  }

  EventContact({this.contactPerson, this.contactLink, this.method});

  EventContact.fromList(List<String> contact) {
    this.contactLink = contact[1];
    this.contactPerson = contact[0];
    switch (contact[2]) {
      case "CALL":
        this.method = LaunchMethod.CALL;
        break;
      case "MESSAGE":
        this.method = LaunchMethod.MESSAGE;
        break;
      case "WEB":
        this.method = LaunchMethod.WEB;
        break;
      case "FACEBOOK":
        this.method = LaunchMethod.FACEBOOK;
        break;
      default:
        this.method = null;
    }
  }
}

/// Class to hold info on events
/// Will be used as main object to save, load, show info
class Event {
  String eventName;
  String organizer;
  String time;
  String date;
  List<String> images;
  String headerImage;
  String description;
  String location;
  bool flagged = false;
  List<EventContact> contact = [];
  List<String> tags = [];

  /// Create an event for test purposes
  Event.fromDataList(List eventData) {
    this.eventName = eventData[0];
    this.organizer = eventData[1];
    this.time = eventData[2];
    this.date = eventData[3];
    this.location = eventData[4];
    this.description = eventData[5];
    this.images = eventData[6];
    this.headerImage = this.images[0];
    for (List<String> _contact in eventData[7]) {
      this.contact.add(
            new EventContact.fromList(_contact),
          );
    }
    this.tags.add("Test");
    this.tags.add("Event");
  }
}

class EventNotification {
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool read = false;

  EventNotification(this.message, this.type, this.timestamp);

  void markAsRead() {
    read = true;
  }

  IconData getIcon() {
    switch (this.type) {
      case NotificationType.ADD_FLAG:
        return Icons.flag;
      case NotificationType.REM_FLAG:
        return Icons.outlined_flag;
      case NotificationType.ALARM:
        return Icons.alarm;
      default:
        return Icons.info;
    }
  }
}

class FlaggedEvent {
  final Event event;
  final bool alarmStatus;

  FlaggedEvent(this.event, this.alarmStatus);

  bool equals(Event event) {
    return this.event == event;
  }
}
