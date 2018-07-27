import 'dart:async' show Future;
import 'package:cloud_firestore/cloud_firestore.dart'
    show Firestore, DocumentSnapshot;
import 'package:event_app/custom_widgets/custom_snackbar.dart'
    show showSnackBar;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/redux_store/actions.dart' show AddNotification;
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event, NotificationType;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:flutter/services.dart';
import 'package:redux/redux.dart' show Store;

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

  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();

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
    return Container(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(title, style: Theme.of(context).textTheme.title),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: ListTile(
              leading: new Icon(
                Icons.info_outline,
              ),
              title: new Text(message),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Close",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                (buttonAction != null)
                    ? FlatButton(
                        child: Text(
                          buttonText,
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          buttonAction();
                        },
                      )
                    : null,
              ],
            ),
          ),
        ],
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
        showBottomSheet(
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
          showBottomSheet(
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
