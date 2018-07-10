import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;
import 'package:event_app/redux_store/store.dart' show EventStore;

class EventNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
      converter: (store) => store.state,
      builder: buildEventNotifications,
    );
  }

  Widget buildEventNotifications(BuildContext context, EventStore eventStore) {
    List<Widget> listViewChildren = [];
    for (List<String> notification in eventStore.notifications.reversed) {
      IconData icon;
      switch (notification[0]) {
        case "FLAG_ADD":
          icon = Icons.flag;
          break;
        case "FLAG_REM":
          icon = Icons.outlined_flag;
          break;
        case "ALARM":
          icon = Icons.alarm;
          break;
        default:
          icon = Icons.info;
      }
      listViewChildren.add(ListTile(
        leading: Icon(icon),
        title: Text(
          notification[1],
        ),
        subtitle: Text(notification[2]),
      ));
      listViewChildren.add(Divider(
        color: Colors.black,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body: ListView(
        children: listViewChildren,
      ),
    );
  }
}
