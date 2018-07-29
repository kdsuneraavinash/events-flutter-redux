import 'dart:async' show Future;
import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, DocumentSnapshot;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/redux_store/actions.dart' show AddNotification;
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:event_app/state/event.dart';
import 'package:event_app/state/notification.dart';
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:redux/redux.dart' show Store;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  final Store<EventStore> store;

  EventListBody(this.store);

  @override
  EventListBodyState createState() {
    return new EventListBodyState();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Widget buildEventListBody(BuildContext context) {
    Map<String, Event> events = this.store.state.eventList;
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

  Widget buildEventRecievedBottomSheet(BuildContext context, String title,
      String message, String buttonText, VoidCallback buttonAction) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(title,
                  style: TextStyle(fontSize: 24.0, color: Colors.white)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: ListTile(
                leading: Icon(
                  FontAwesomeIcons.infoCircle,
                ),
                title: Text(message),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (buttonAction != null)
                      ? OutlineButton(
                          child: Text(buttonText),
                          onPressed: () {
                            Navigator.pop(context);
                            buttonAction();
                          },
                        )
                      : Container(),
                  OutlineButton(
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Handles when cloud message recieves
  Future<void> handleMessageRecieved(
      Map<String, dynamic> message, BuildContext context) async {
    // Function that shows event window
    dynamic showEvent = (event) => TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventDetails(event),
        )
        .start(context);
    String notification;
    NotificationType notificationType;

    // Check type of message
    switch (message["type"]) {
      // Event was added
      case "EVENT_ADD":
        Event event = await getEventByID(message["eventID"]);
        notification =
            "${event.organizer} added a new Event: ${event.eventName}";
        notificationType = NotificationType.ADD;
        // Show a bottom sheet
        showModalBottomSheet(
          builder: (_) => buildEventRecievedBottomSheet(context, "New Event",
              notification, "View Event", () => showEvent(event)),
          context: context,
        );
        break;
      // Normal message
      default:
        if (message.containsKey('message')) {
          notification = "${message['message']}";
          notificationType = NotificationType.MESSAGE;
          showModalBottomSheet(
            builder: (_) => buildEventRecievedBottomSheet(
                context, "New Notification", notification, "", null),
            context: context,
          );
        }
    }

    this.store.dispatch(AddNotification(
          notification,
          notificationType,
          DateTime.now(),
        ));
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
      onMessage: (v) => widget.handleMessageRecieved(v, context),
      onLaunch: (v) => widget.handleMessageRecieved(v, context),
      onResume: (v) => widget.handleMessageRecieved(v, context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildEventListBody(context);
  }
}
