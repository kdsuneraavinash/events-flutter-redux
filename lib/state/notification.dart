import 'package:flutter/material.dart' show IconData, Icons;

enum NotificationType { ADD, MESSAGE }

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
      case NotificationType.ADD:
        return Icons.event;
      case NotificationType.MESSAGE:
        return Icons.message;
      default:
        return Icons.info;
    }
  }

  static NotificationType getTypeFromString(String type) {
    switch (type) {
      case 'ADD':
        return NotificationType.ADD;
      case 'MESSAGE':
      default:
        return NotificationType.MESSAGE;
    }
  }

  static String getStringFromType(NotificationType type) {
    switch (type) {
      case NotificationType.ADD:
        return 'ADD';
      case NotificationType.MESSAGE:
      default:
        return 'MESSAGE';
    }
  }

  // Parse from JSON
  factory EventNotification.fromJson(Map<String, dynamic> json) {
    // Notification type convert from String
    return EventNotification(
      json["message"], // String
      EventNotification.getTypeFromString(json["type"]), // NotificationType
      DateTime.fromMillisecondsSinceEpoch(json["timestamp"]), // Date Time
    );
  }

  Map toJson() {
    return {
      "message": this.message,
      "type": getStringFromType(this.type),
      "timestamp": this.timestamp.millisecondsSinceEpoch
    };
  }
}
