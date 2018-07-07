import 'dart:async';
import 'package:event_app/custom_widgets/transition_maker.dart';
import 'package:flutter/material.dart';
import 'package:event_app/screens/event_list/event_card.dart' show EventCard;
import 'package:event_app/event.dart' show Event;
import 'package:event_app/screens/credits.dart' show Credits;

/// Main Page that displays a list of available Events.
/// TODO: Implement a action element in AppBar => PopupMenuButton
class EventListWindow extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventListWindowState();
}

/// State of EventListWindow.
class EventListWindowState extends State<EventListWindow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MORA EVENTS"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.help),
            onPressed: () => _handleCreditsAction(context),
          )
        ],
      ),
      body: EventListBody(),
    );
  }

  void _handleCreditsAction(BuildContext context) {
    TransitionMaker.slideTransition(
      destinationPageCall: () => Credits(),
    ).start(context);
  }
}

/// Body of EventListWindow.
/// Contains of a ListView consisting of Event Cards so Users can scroll
/// through Events.
/// TODO: Use a database to load events.
/// TODO: Connect with internet.
/// Also contains a RefreshIndicator so users can refresh Event Content.
/// TODO: Add Event Refresh Process
class EventListBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => EventListBodyState();
}

/// State of [EventListBody].
class EventListBodyState extends State<EventListBody> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: ListView.builder(
        itemBuilder: (_, index) => EventCard(
              index: index,
              event: Event.fromIndex(index),
            ),
        itemCount: 100,
      ),
      onRefresh: _handleRefresh,
    );
  }

  /// Async function which will update Events when refreshed with
  /// RefreshIndicator.
  /// Currently set to wait 3s and display a SnackBar.
  /// TODO: Add a real refresh method.
  Future<Null> _handleRefresh() {
    final Completer<Null> completer = Completer<Null>();
    Timer(
      Duration(seconds: 3),
      () {
        Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text("Refreshed"),
              ),
            );
        completer.complete(null);
      },
    );
    return completer.future.then((_) {});
  }
}
