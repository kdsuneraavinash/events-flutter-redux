import 'package:event_app/screens/event_details.dart';
import 'package:flutter/material.dart';
import 'package:event_app/custom_widgets/custom_snackbar.dart'
    show showSnackBar;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/state/flagged.dart';
import 'package:event_app/redux_store/actions.dart'
    show ChangeAlarmState, RemoveFromFlaggedList;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;

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
      key: Key(this.flaggedEvent.eventID),
      title: Text(
        store.state.eventList[this.flaggedEvent.eventID].eventName,
      ),
      trailing: this.flaggedEvent.alarmStatus
          ? _buildAlarmDispatchButton(
              icon: Icons.alarm_on,
              store: store,
            )
          : _buildAlarmDispatchButton(
              icon: Icons.alarm_off, store: store, color: Colors.grey),
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child:
              Text(store.state.eventList[this.flaggedEvent.eventID].organizer),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
          child: Text(
            'Starts at ${store.state.eventList[this.flaggedEvent.eventID].startTimeString}',
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildActionButtonButton(
                icon: Icons.remove_red_eye,
                label: "View",
                onPressed: () => _handleViewPressed(context, store),
                context: context),
            _buildActionButtonButton(
                icon: Icons.delete_outline,
                label: "Unpin",
                onPressed: () => _handleUnpinPressed(context, store),
                context: context),
          ],
        ),
      ],
    );
  }

  Widget _buildAlarmDispatchButton(
      {IconData icon, Store<EventStore> store, Color color}) {
    return IconButton(
      icon: CircleAvatar(
        child: Icon(icon),
        backgroundColor: color,
      ),
      onPressed: () => store.dispatch(ChangeAlarmState(
          this.flaggedEvent.eventID,
          !this.flaggedEvent.alarmStatus,
          DateTime.now())),
    );
  }

  Widget _buildActionButtonButton(
      {IconData icon,
      String label,
      VoidCallback onPressed,
      BuildContext context}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: OutlineButton.icon(
        borderSide: BorderSide(color: Theme.of(context).primaryColor),
        icon: Icon(icon),
        label: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  /// Will show EventImageView
  void _handleViewPressed(BuildContext context, Store<EventStore> store) {
    TransitionMaker
        .slideTransition(
          destinationPageCall: () =>
              EventDetails(store.state.eventList[this.flaggedEvent.eventID]),
        )
        .start(context);
  }

  /// Will unpin Event
  void _handleUnpinPressed(BuildContext context, Store<EventStore> store) {
    store.dispatch(
        RemoveFromFlaggedList(this.flaggedEvent.eventID, DateTime.now()));
    showSnackBar(context,
        "${store.state.eventList[this.flaggedEvent.eventID].eventName} Unpinned");
  }

  EventFlaggedCard(this.flaggedEvent);

  final FlaggedEvent flaggedEvent;
}
