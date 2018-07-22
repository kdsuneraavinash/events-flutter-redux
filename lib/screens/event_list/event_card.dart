import 'package:event_app/custom_widgets/icon_text.dart' show IconText;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/event.dart' show Event, FlaggedEvent;
import 'package:event_app/redux_store/actions.dart'
    show RemoveFromFlaggedList, AddToFlaggedList;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_image_view.dart' show EventImageView;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

/// Individual Card.
/// Displays a Banner, Event Title and Organizers, and Time and Date.
/// When clicked on Image, shows a Image Banner Window of Pagination of Images.
/// Image will act as a Hero.
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

  /// Separated build method because StoreBuilder is used
  Widget buildEventCard(BuildContext context, Store<EventStore> store) {
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular((8.0)))),
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: _buildImageBanner(),
            onTap: () => _handleBannerOnTap(context, store),
          ),
          _buildTitleStrip(context, store),
          _buildTimeDateStrip(context),
        ],
      ),
    );
  }

  /// Builds CachedNetworkImage as Banner.
  /// This will also act as a Hero.
  Widget _buildImageBanner() {
    return Hero(
      tag: this.event,
      child: DefParameterNetworkImage(
        imageUrl: this.event.headerImage,
      ),
    );
  }

  /// Build Time Date Data
  Widget _buildTimeDateStrip(BuildContext context) {
    return IconText(
      icon: Icons.timer,
      text: "${this.event.startTime}",
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  /// Build Title and flagging controller
  Widget _buildTitleStrip(BuildContext context, Store<EventStore> eventStore) {
    List<FlaggedEvent> flaggedList = eventStore.state.flaggedList;
    bool isFlagged = flaggedList.any((v) => v.equals(this.event));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(this.event.eventName),
        subtitle: Text(this.event.organizer),
        trailing: IconButton(
          icon: Icon(
            isFlagged ? Icons.bookmark : Icons.bookmark_border,
            color: isFlagged ? Theme.of(context).accentColor : null,
          ),
          onPressed: () => _handleFlagOnTap(context, isFlagged, eventStore),
        ),
      ),
    );
  }

  /// Handles Tap on Banner.
  /// Will show EventImageView and animates Banner as a Hero.
  /// Use Fade animation as transition.
  void _handleBannerOnTap(BuildContext context, Store<EventStore> store) {
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventImageView(this.event),
        )
        .start(context);
  }

  /// Handles tap on flag
  /// Toggled its flagged state
  void _handleFlagOnTap(
      BuildContext context, bool isFlagged, Store<EventStore> eventStore) {
    if (isFlagged) {
      eventStore.dispatch(RemoveFromFlaggedList(this.event));
    } else {
      eventStore.dispatch(AddToFlaggedList(this.event));
    }
  }

  EventCard(this.event);

  final Event event;
}
