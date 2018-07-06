import 'package:flutter/material.dart';

import 'package:event_app/event.dart' show Event;
import 'package:event_app/custom_widgets/icon_text.dart' show IconText;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/windows/event_image_view.dart' show EventImageView;

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
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: _buildImageBanner(context),
            onTap: () => _handleBannerOnTap(context),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text(this.event.eventName),
            subtitle: Text(this.event.organizer),
          ),
          IconText(
            icon: Icons.timer,
            text: "${this.event.time} | ${this.event.date}",
            mainAxisAlignment: MainAxisAlignment.center,
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
    Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) {
              return EventImageView(this.event);
            },
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
            },
          ),
        );
  }
}
