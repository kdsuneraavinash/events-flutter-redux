import 'package:flutter/material.dart';
import 'package:event_app/custom_widgets/custom_snackbar.dart'
    show showSnackBar;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/event.dart' show FlaggedEvent;
import 'package:event_app/redux_store/actions.dart'
    show ChangeAlarmState, RemoveFromFlaggedList;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_image_view.dart' show EventImageView;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;

// TODO: Add comments and implement this tool
class EventFlaggedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: (context, store) => buildEventFlaggedItemButton(context, store),
    );
  }

  Widget buildEventFlaggedItemButton(
      BuildContext context, Store<EventStore> store) {
    return ExpansionTile(
      key: Key(this.flaggedEvent.event.id),
      title: Text(
        this.flaggedEvent.event.eventName,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      trailing: this.flaggedEvent.alarmStatus
          ? _buildAlarmDispatchButton(
              icon: Icons.alarm_on,
              color: Theme.of(context).primaryColor,
              store: store,
            )
          : _buildAlarmDispatchButton(
              icon: Icons.alarm_off,
              store: store,
            ),
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(this.flaggedEvent.event.organizer),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Text(
            'Starts at ${this.flaggedEvent.event.startTimeString}',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildActionButtonButton(
              icon: Icons.slideshow,
              label: "View",
              onPressed: () => _handleViewPressed(context, store),
            ),
            _buildActionButtonButton(
              icon: Icons.delete_outline,
              label: "Unpin",
              onPressed: () => _handleUnpinPressed(context, store),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAlarmDispatchButton(
      {IconData icon, Store<EventStore> store, Color color}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => store.dispatch(ChangeAlarmState(
          this.flaggedEvent.event, !this.flaggedEvent.alarmStatus,  DateTime.now())),
      color: color,
    );
  }

  Widget _buildActionButtonButton(
      {IconData icon, String label, VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: FlatButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  /// Will show EventImageView
  void _handleViewPressed(BuildContext context, Store<EventStore> store) {
    TransitionMaker
        .fadeTransition(
          destinationPageCall: () => EventImageView(this.flaggedEvent.event),
        )
        .start(context);
  }

  /// Will unpin Event
  void _handleUnpinPressed(BuildContext context, Store<EventStore> store) {
    store.dispatch(RemoveFromFlaggedList(this.flaggedEvent.event,  DateTime.now()));
    showSnackBar(context, "${this.flaggedEvent.event.eventName} Unpinned");
  }

  EventFlaggedCard(this.flaggedEvent);

  final FlaggedEvent flaggedEvent;
}
