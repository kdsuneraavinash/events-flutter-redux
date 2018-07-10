import 'package:event_app/redux_store/store.dart';
import 'package:flutter/material.dart';
import 'package:event_app/custom_widgets/event_alarm_button.dart'
    show EventAlarmButton;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;
import 'package:event_app/event.dart' show Event;

/// Window to show pinned events to toggle alarms
/// TODO: All toggle alarms
/// TODO: Remember alarm states
/// TODO Change design
class AlarmsManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Alarms Manager"),
        ),
        body: StoreConnector<EventStore, EventStore>(
          converter: (store) => store.state,
          builder: (context, eventStore) => ListView(
                children: _buildAlarmButtons(eventStore.alarmsList),
              ),
        ));
  }

  List<Widget> _buildAlarmButtons(Map<Event, bool> alarmList){
    List<Widget> list = [];
    for (Event alarm in alarmList.keys){
      list.add(EventAlarmButton(alarm, alarmList[alarm]));
    }
    return list;
  }
}
