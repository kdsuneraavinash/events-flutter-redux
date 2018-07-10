import 'package:flutter/material.dart';
import 'package:redux/redux.dart' show Store;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/redux_store/actions.dart' show ChangeAlarmState;

// TODO: Add comments and implement this tool
class EventAlarmButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: (context, store) => buildEventAlarmButton(context, store),
    );
  }

  Widget buildEventAlarmButton(BuildContext context, Store<EventStore> store) {
    return Container(
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: ListTile(
        leading: IconButton(
          icon: this.selected
              ? Icon(
                  Icons.alarm_on,
                  color: Colors.black,
                )
              : Icon(
                  Icons.alarm_off,
                  color: null,
                ),
          onPressed: () =>
              store.dispatch(ChangeAlarmState(this.event, !this.selected)),
        ),
        title: Text(
          this.event.eventName,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        subtitle: Text(
          "${this.event.time} | ${this.event.date}",
          style: TextStyle(color: Theme.of(context).accentColor),
        ),
      ),
    );
  }

  EventAlarmButton(this.event, this.selected);
  final Event event;
  final bool selected;
}
