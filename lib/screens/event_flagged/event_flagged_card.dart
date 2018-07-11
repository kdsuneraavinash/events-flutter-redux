import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/event.dart' show FlaggedEvent;
import 'package:event_app/redux_store/actions.dart'
    show ChangeAlarmState, RemoveFromFlaggedList;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_image_view.dart' show EventImageView;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/custom_widgets/custom_snackbar.dart'
    show showSnackBar;

// TODO: Add comments and implement this tool
class EventFlaggedCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: (context, store) => buildEventAlarmButton(context, store),
    );
  }

  Widget buildEventAlarmButton(BuildContext context, Store<EventStore> store) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              this.flaggedEvent.event.eventName,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(
              "${this.flaggedEvent.event.time} | ${this.flaggedEvent.event
                  .date}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            leading: this.flaggedEvent.alarmStatus
                ? _buildAlarmDispatchButton(
                    icon: Icons.alarm_on,
                    color: Theme.of(context).primaryColor,
                    store: store,
                  )
                : _buildAlarmDispatchButton(
                    icon: Icons.alarm_off,
                    store: store,
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
      ),
    );
  }

  Widget _buildAlarmDispatchButton(
      {IconData icon, Store<EventStore> store, Color color}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () => store.dispatch(ChangeAlarmState(
          this.flaggedEvent.event, !this.flaggedEvent.alarmStatus)),
      color: color,
    );
  }

  Widget _buildActionButtonButton(
      {IconData icon, String label, VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: OutlineButton.icon(
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
    store.dispatch(RemoveFromFlaggedList(this.flaggedEvent.event));
    showSnackBar(context, "${this.flaggedEvent.event.eventName} Unpinned");
  }

  EventFlaggedCard(this.flaggedEvent);
  final FlaggedEvent flaggedEvent;
}
