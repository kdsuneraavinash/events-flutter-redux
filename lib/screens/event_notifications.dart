import 'package:flutter/material.dart';
import 'package:redux/redux.dart' show Store;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/event.dart' show EventNotification;
import 'package:event_app/redux_store/actions.dart'
    show MarkNotificationsAsRead, ClearNotifications;

class EventNotificationsManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<EventStore>(
      builder: buildEventNotificationsManager,
    );
  }

  Widget buildEventNotificationsManager(
      BuildContext context, Store<EventStore> eventStore) {
    List<Widget> listViewChildren = [];
    for (EventNotification notification
        in eventStore.state.notifications.reversed) {
      listViewChildren.add(ListTile(
        leading: Icon(
          notification.getIcon(),
          color: notification.read ? null : Theme.of(context).primaryColor,
        ),
        title: Text(
          notification.message,
          style:
              TextStyle(fontWeight: notification.read ? FontWeight.w400 : null),
        ),
        subtitle: Text(
          notification.timestamp,
          style: TextStyle(
            color: notification.read ? null : Theme.of(context).accentColor,
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: listViewChildren.isEmpty
                ? null
                : () => eventStore.dispatch(ClearNotifications()),
          )
        ],
      ),
      body: listViewChildren.isEmpty
          ? Center(
              child: Text("Nothing Here"),
            )
          : ListView(
              children: listViewChildren,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: listViewChildren.isEmpty
            ? null
            : () => eventStore.dispatch(MarkNotificationsAsRead()),
        child: Icon(Icons.done_all),
      ),
    );
  }
}
