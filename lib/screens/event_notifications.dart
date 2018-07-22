import 'package:event_app/event.dart' show EventNotification;
import 'package:event_app/redux_store/actions.dart'
    show MarkNotificationsAsRead, ClearNotifications;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;

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
          getStringText(notification.timestamp),
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
            onPressed: () => eventStore.dispatch(ClearNotifications()),
          )
        ],
      ),
      body: listViewChildren.isEmpty
          ? Center(child: Text("Nothing Here"))
          : ListView.builder(
              itemBuilder: (_, index) => listViewChildren[index],
              itemCount: listViewChildren.length,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => eventStore.dispatch(MarkNotificationsAsRead()),
        child: Icon(Icons.done_all),
      ),
    );
  }

  String getStringText(DateTime timestamp) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(timestamp);
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) {
          if (diff.inSeconds <= 15) {
            return "Just now";
          }
          return "${diff.inSeconds} seconds ago";
        }
        return "${diff.inMinutes} minutes ago";
      }
      return "${diff.inHours} hours ago";
    }
    return "${diff.inDays} days ago";
  }
}
