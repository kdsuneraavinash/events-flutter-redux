import 'package:flutter/material.dart';
import 'package:redux/redux.dart' show Store;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/redux_store/actions.dart' show ChangeAlarmState;

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
              this.event.eventName,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text(
              "${this.event.time} | ${this.event.date}",
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
            leading: this.selected
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
              OutlineButton.icon(
                icon: Icon(Icons.slideshow),
                label: Text("View"),
                onPressed: () => null,
              ),
              OutlineButton.icon(
                icon: Icon(Icons.delete_outline),
                label: Text("Unpin"),
                onPressed: () => null,
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
      onPressed: () =>
          store.dispatch(ChangeAlarmState(this.event, !this.selected)),
      color: color,
    );
  }

  EventFlaggedCard(this.event, this.selected);
  final Event event;
  final bool selected;
}
