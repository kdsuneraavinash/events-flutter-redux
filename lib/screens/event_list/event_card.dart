import 'package:flutter/material.dart';

import 'package:event_app/screens/event_image_view.dart' show EventImageView;

import 'package:event_app/event.dart' show Event;
import 'package:event_app/custom_widgets/icon_text.dart' show IconText;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/screens/event_details.dart' show EventDetails;

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
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: _buildImageBanner(context),
            onTap: () => _handleBannerOnTap(context),
          ),
          GestureDetector(
            child: ListTile(
              leading: Icon(Icons.event),
              title: Text(this.event.eventName),
              subtitle: Text(this.event.organizer),
            ),
            onTap: () => _handleEventOnTap(context),
          ),
          GestureDetector(
            child: IconText(
              icon: Icons.timer,
              text: "${this.event.time} | ${this.event.date}",
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            onTap: () => _handleDateTimeOnTap(context),
          ),
        ],
      ),
    );
  }

  /// Constructor ->
  /// index is card position,
  /// event is event details
  EventCard({this.index, this.event});
  final int index;
  final Event event;

  /// Builds CachedNetworkImage as Banner.
  /// This will also act as a Hero.
  Widget _buildImageBanner(BuildContext context) {
    return Hero(
      tag: this.event,
      child: DefParameterNetworkImage(
        imageUrl: this.event.headerImage,
      ),
    );
  }

  /// Handles Tap on Banner.
  /// Will show EventImageView and animates Banner as a Hero.
  /// Use Fade animation as transition.
  void _handleBannerOnTap(BuildContext context) {
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventImageView(this.event),
        )
        .start(context);
  }

  void _handleDateTimeOnTap(BuildContext context) {
    Scaffold.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Will start on ${this.event.date} at ${this.event.time}."),
            backgroundColor: Theme.of(context).accentColor,
          ),
        );
  }

  void _handleEventOnTap(BuildContext context) {
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventDetails(
                event: this.event,
              ),
        )
        .start(context);
  }
}
