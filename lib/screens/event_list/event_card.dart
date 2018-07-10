import 'package:event_app/redux_store/actions.dart';
import 'package:event_app/redux_store/store.dart';
import 'package:flutter/material.dart';

import 'package:event_app/screens/event_image_view.dart' show EventImageView;

import 'package:event_app/event.dart' show Event;
import 'package:event_app/custom_widgets/icon_text.dart' show IconText;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// Individual Card.
/// Displays a Banner, Event Title and Organizers, and Time and Date.
/// When clicked on Image, shows a Image Banner Window of Pagination of Images.
/// Image will act as a Hero.
/// When clicked on Event Title, goes straight to Event Page.
/// TODO: Implement Event Page
/// TODO: Implement Going to Event Page
/// When clicked on Time and Date, shows a calendar showing the date.
/// User can add this event straight to Google Calendars from here.
/// TODO: Implement Calendar Viewing
/// TODO: Implement Google Calendar event adding
class EventCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: (context, store) => buildEventCard(context, store),
    );
  }

  Widget buildEventCard(BuildContext context, Store<EventStore> store) {
    Event event = store.state.eventList[this.index];
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: _buildImageBanner(event),
            onTap: () => _handleBannerOnTap(context, store),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(event.eventName),
              subtitle: Text(event.organizer),
              trailing: IconButton(
                icon: Icon(
                  event.flagged ? Icons.bookmark : Icons.bookmark_border,
                  color: event.flagged ? Theme.of(context).primaryColor : null,
                ),
                onPressed: () => null,
              ),
            ),
          ),
          GestureDetector(
            child: IconText(
              icon: Icons.timer,
              text: "${event.time} | ${event.date}",
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            onTap: () => _handleDateTimeOnTap(context, event),
          ),
        ],
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  /// This will also act as a Hero.
  Widget _buildImageBanner(Event event) {
    return Hero(
      tag: event,
      child: DefParameterNetworkImage(
        imageUrl: event.headerImage,
      ),
    );
  }

  /// Handles Tap on Banner.
  /// Will show EventImageView and animates Banner as a Hero.
  /// Use Fade animation as transition.
  void _handleBannerOnTap(BuildContext context, Store<EventStore> store) {
    Event currentEvent = store.state.eventList[index];
    store.dispatch(ChangeCurrentEvent(currentEvent));
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventImageView(currentEvent),
        )
        .start(context);
  }

  void _handleDateTimeOnTap(BuildContext context, Event event) {
    Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("Will start on ${event.date} at ${event.time}."),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
  }

  EventCard(this.index);
  final int index;
}
