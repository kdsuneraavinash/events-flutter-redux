import 'dart:async' show Future;

import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, DocumentSnapshot;
import 'package:event_app/custom_widgets/custom_snackbar.dart'
    show showSnackBar;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;

/// Body of EventListWindow.
/// Contains of a ListView consisting of Event Cards so Users can scroll
/// through Events.
/// TODO: Use a firestore connection to load events.
/// Also contains a RefreshIndicator so users can refresh Event Content.
/// TODO: Add Event Refresh Process
/// Async function which will update Events when refreshed with
/// RefreshIndicator.
/// Currently set to wait 3s and display a SnackBar.
/// TODO: Add a real refresh method
class EventListBody extends StatefulWidget {
  @override
  EventListBodyState createState() {
    return new EventListBodyState();
  }

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

  Widget buildEventListBody(BuildContext context, EventStore store) {
    Map<String, Event> events = store.eventList;
    return events.length > 0
        ? ListView.builder(
            itemBuilder: (_, index) => EventCard(events.keys.elementAt(index)),
            itemCount: events.length,
          )
        : Center(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    child: Text("Loading Data"),
                    padding: EdgeInsets.all(16.0),
                  ),
                  SizedBox(
                    child: LinearProgressIndicator(),
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ],
              ),
            ),
          );
  }

  // Handles when cloud message recieves
  Future<void> handleMessageRecieved(
      Map<String, dynamic> message, BuildContext context,
      [bool snackbar = false]) async {
    // Function that shows event window
    dynamic showEvent = (event) => TransitionMaker
        .slideTransition(
          destinationPageCall: () => EventDetails(event),
        )
        .start(context);

    // Check type of message
    switch (message["type"]) {
      // Event was added
      case "EVENT_ADD":
        Event event = await getEventByID(message["eventID"]);
        if (snackbar) {
          // Show a snackbar
          showSnackBar(
            context,
            "${event.organizer} added a new Event: ${event.eventName}",
            SnackBarAction(
              label: "View",
              onPressed: () => showEvent(event),
            ),
          );
        } else {
          showEvent(event);
          print("Message: $message");
        }
        break;
      // Normal message
      default:
        if (message.containsKey('message')) {
          showSnackBar(context, "${message['message']}");
        }
    }
  }

  Future<Event> getEventByID(String eventID) async {
    DocumentSnapshot doc =
        await Firestore.instance.document("events/$eventID").get();
    return Event.fromFirestoreDoc(doc);
  }
}

class EventListBodyState extends State<EventListBody> {
  @override
  void initState() {
    // Request permissions for receiving Push Notifications
    // https://pub.dartlang.org/packages/firebase_messaging#-readme-tab-
    widget.firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    widget.firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    widget.firebaseMessaging.getToken().then((String token) {
      assert(token != null);
    });

    // Message recieved Functions
    widget.firebaseMessaging.configure(
      // Message recieved when app in foreground
      onMessage: (v) => widget.handleMessageRecieved(v, context, true),
      onLaunch: (v) => widget.handleMessageRecieved(v, context),
      onResume: (v) => widget.handleMessageRecieved(v, context),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
      builder: (context, state) => widget.buildEventListBody(context, state),
      converter: (store) => store.state,
    );
  }
}
