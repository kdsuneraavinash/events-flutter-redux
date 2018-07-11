import 'package:event_app/redux_store/store.dart';
import 'package:flutter/material.dart';
import 'package:event_app/custom_widgets/event_alarm_button.dart'
    show EventAlarmButton;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;
import 'package:event_app/event.dart' show Event, FlaggedEvent;

/// Window to show pinned events to toggle alarms
/// TODO: All toggle alarms
/// TODO: Remember alarm states
/// TODO Change design
class FlaggedEventManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pinned Events"),
      ),
      body: StoreConnector<EventStore, EventStore>(
        converter: (store) => store.state,
        builder: (context, eventStore) =>
            buildAlarmButtons(eventStore.flaggedList),
      ),
    );
  }

  Widget buildAlarmButtons(List<FlaggedEvent> alarmList) {
    List<Widget> list = [];
    for (FlaggedEvent alarm in alarmList) {
      list.add(EventAlarmButton(alarm.event, alarm.alarmStatus));
    }

    if (list.isEmpty) {
      return Center(child: Text("Pin events and they will show up here."));
    } else {
      return ListView(children: list);
    }
  }
}
