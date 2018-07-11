import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:event_app/screens/event_image_view.dart' show EventImageView;
import 'package:event_app/event.dart' show Event, FlaggedEvent;
import 'package:event_app/custom_widgets/icon_text.dart' show IconText;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/redux_store/actions.dart';
import 'package:event_app/redux_store/store.dart' show EventStore;

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
          _buildTitleStrip(context, store),
          _buildTimeDateStrip(context, event),
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

  /// Build Time Date Data
  Widget _buildTimeDateStrip(BuildContext context, Event event) {
    return IconText(
      icon: Icons.timer,
      text: "${event.time} | ${event.date}",
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  /// Build Title and flagging controller
  Widget _buildTitleStrip(BuildContext context, Store<EventStore> eventStore) {
    Event event = eventStore.state.eventList[this.index];
    List<FlaggedEvent> flaggedList = eventStore.state.flaggedList;
    bool isFlagged = flaggedList.any((v) => v.equals(event));
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(event.eventName),
        subtitle: Text(event.organizer),
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
    Event currentEvent = store.state.eventList[index];
    store.dispatch(ChangeCurrentSelectedEvent(currentEvent));
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventImageView(currentEvent),
        )
        .start(context);
  }

  /// Handles tap on flag
  /// Toggled its flagged state
  void _handleFlagOnTap(
      BuildContext context, bool isFlagged, Store<EventStore> eventStore) {
    Event event = eventStore.state.eventList[this.index];
    if (isFlagged) {
      eventStore.dispatch(RemoveFromFlaggedList(event));
    } else {
      eventStore.dispatch(AddToFlaggedList(event));
    }
  }

  EventCard(this.index);
  final int index;
}
