import 'package:event_app/test_data.dart' show events;

import 'package:flutter/material.dart' show IconData, Icons;

enum LaunchMethod { CALL, MESSAGE, WEB, FACEBOOK }

class EventContact {
  String contactPerson;
  String contactLink;
  LaunchMethod method;

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

  /// Create an event for test purposes
  Event.fromIndex(int index) {
    if (events.length <= index) {
      this.eventName = "Event Name";
      this.organizer = "Organizer";
      this.time = "4:40PM";
      this.date = "May 25";
      this.location = "BMICH";
      this.images = [
        "https://picsum.photos/400/400?image=$index",
        "https://picsum.photos/400/400?image=${index + 3}",
        "https://picsum.photos/400/400?image=${index + 5}",
      ];
      this.headerImage = this.images[0];
      this.description =
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor "
          "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis "
          "nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n"
          " Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore "
          "eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt "
          "in culpa qui officia deserunt mollit anim id est laborum.";
    } else {
      this.eventName = events[index][0];
      this.organizer = events[index][1];
      this.time = events[index][2];
      this.date = events[index][3];
      this.location = events[index][4];
      this.description = events[index][5];
      this.images = events[index][6];
      this.headerImage = this.images[0];
    }
  }

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
  }
}
