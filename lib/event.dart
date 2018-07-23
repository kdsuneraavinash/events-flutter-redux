import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' show IconData, Icons;

/// Launch method for EventContact
enum LaunchMethod { CALL, MESSAGE, WEB, FACEBOOK }

enum NotificationType { ADD_FLAG, REM_FLAG, ALARM }

/// Hold Event Organizer Contact Data
class EventContact {
  Map<LaunchMethod, List> _methodToPropertyMap = {
    LaunchMethod.CALL: [Icons.call, (v) => "tel:$v", "Call"],
    LaunchMethod.MESSAGE: [Icons.call, (v) => "sms:$v", "Message"],
    LaunchMethod.WEB: [Icons.web, (v) => "$v", "Website"],
    LaunchMethod.FACEBOOK: [Icons.web, (v) => "$v", "Facebook"],
  };

  Map<String, LaunchMethod> _stringToMethodMap = {
    "CALL": LaunchMethod.CALL,
    "MESSAGE": LaunchMethod.MESSAGE,
    "WEB": LaunchMethod.WEB,
    "FACEBOOK": LaunchMethod.FACEBOOK
  };

  String contactPerson;
  String contactLink;
  LaunchMethod method;

  /// Get Icon according to launch method
  IconData getIcon() => _methodToPropertyMap[this.method][0];

  /// Get Url to execute the method
  String getUrl() => _methodToPropertyMap[this.method][1];

  /// Get String according to contact method
  String getContactMethodString() => _methodToPropertyMap[this.method][2];

  EventContact(this.contactPerson, this.contactLink, this.method);

  EventContact.fromList(List<String> contact) {
    this.contactLink = contact[1];
    this.contactPerson = contact[0];
    this.method = _stringToMethodMap[contact[2]];
  }
}

/// Class to hold info on events
/// Will be used as main object to save, load, show info
class Event {
  final String eventName;
  final String organizer;
  final String startTime;
  final String endTime;
  final List<String> images;
  final String headerImage; // Auto assigned
  final String description;
  final String location;
  final String id;
  //List<EventContact> contact = [];
  final List<String> tags = [];

  Event(this.eventName, this.organizer, this.startTime, this.endTime,
      this.images, this.headerImage, this.description, this.location, this.id);

  factory Event.fromFirestoreDoc(DocumentSnapshot doc) {
    return new Event(
        doc.data['eventName'],
        doc.data['organizer'],
        doc.data['start'].toString(),
        doc.data['end'].toString(),
        List<String>.from(doc.data['images']),
        doc.data['images'][0],
        doc.data['description'],
        doc.data['location'],
        doc.documentID);
  }

  /// Create an event for test purposes
  factory Event.fromDataList(List eventData) {
    return Event(
        eventData[0],
        eventData[1],
        eventData[2],
        eventData[3],
        eventData[6],
        eventData[6][0],
        eventData[4],
        eventData[5],
        eventData[0] + eventData[1])
      ..tags.add("Test");
    /*
    TODO: Add functionality later in web
    for (List<String> _contact in eventData[7]) {
      this.contact.add(
            new EventContact.fromList(_contact),
          );
    }

    this.tags.add("Test");
    this.tags.add("Event");
    */
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
