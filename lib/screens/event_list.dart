import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io' show SocketException, InternetAddress;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/redux_store/actions.dart'
    show
        FirestoreListenToUpdates,
        FirestoreEndConnection,
        FirestoreRefreshAll,
        SearchOptionsSet;
import 'package:event_app/redux_store/store.dart' show EventStore, QueryOptions;
import 'package:event_app/screens/credits.dart' show Credits;
import 'package:event_app/screens/event_flagged.dart' show FlaggedEventManager;
import 'package:event_app/screens/event_list/event_list_body.dart'
    show EventListBody;
import 'package:event_app/screens/event_notifications.dart'
    show EventNotificationsManager;
import 'package:flutter_redux/flutter_redux.dart' show StoreBuilder;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/screens/event_list/filter_options.dart'
    show FilterOptions;

/// Main Page that displays a list of available Events.
/// TODO: Implement a action element in AppBar => PopupMenuButton
class EventListWindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: buildEventListWindow,
      onInit: (store) {
        store.dispatch(FirestoreRefreshAll());
        store.dispatch(FirestoreListenToUpdates());
      },
      onDispose: (store) => store.dispatch(FirestoreEndConnection()),
    );
  }

  Widget buildEventListWindow(BuildContext context, Store<EventStore> store) {
    EventStore eventStore = store.state;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mora Events"),
        actions: <Widget>[
          // TODO: Implement Searchbutton
          /*
          IconButton(
            icon: new Icon(Icons.search),
            onPressed: () => _handleSearchAction(context),
          ),
          */
          IconButton(
            icon: new Icon(Icons.help),
            onPressed: () => _handleCreditsAction(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text(
                "Mora Events",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            ),
            ListTile(
              leading: eventStore.notifications.any((v) => !v.read)
                  ? Icon(
                      Icons.notifications_active,
                      color: Theme.of(context).accentColor,
                    )
                  : Icon(Icons.notifications_none),
              title: Text("Notifications"),
              subtitle: Text("View latest event notifications"),
              onTap: () => _handleNotificationsAction(context),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text("Pinned Events"),
              subtitle: Text("Show events that you pinned"),
              onTap: () => _handleFlaggedAction(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: new Icon(Icons.filter_list),
        onPressed: () => _handleFilterAction(context, store),
      ),
      body: EventListBody(store),
    );
  }

  Widget _buildNoInternetDialog(BuildContext context) {
    return AlertDialog(
      content: Text(
        "Please make sure that you are connected to internet. "
            "Filter feature is available only in online mode",
        style: Theme.of(context).textTheme.body1,
      ),
      contentPadding: EdgeInsets.all(16.0),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.warning, color: Theme.of(context).accentColor,),
        ),
        Text("Filter"),
      ]),
      actions: <Widget>[
        FlatButton(
          child: Text("Close"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }

  /// Show credits window
  void _handleCreditsAction(BuildContext context) {
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => Credits(),
        )
        .start(context);
  }

  void _handleFilterAction(
      BuildContext context, Store<EventStore> store) async {
    bool isConnected = await makeSureIsConnected();
    if (!isConnected) {
      await showDialog(context: context, builder: _buildNoInternetDialog);
      return;
    }
    Map<QueryOptions, String> searchOptions = {};
    searchOptions = await TransitionMaker
        .slideTransition(
          destinationPageCall: () =>
              FilterOptions.fromEventStore(store.state.searchOptions),
        )
        .startAndWait(context);
    if (searchOptions != null) {
      store.dispatch(SearchOptionsSet(searchOptions));
      store.dispatch(FirestoreRefreshAll());
    }
  }

  /// Show alarms page
  void _handleFlaggedAction(BuildContext context) {
    Navigator.pop(context);
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => FlaggedEventManager(),
        )
        .start(context);
  }

  /// Show notifications page
  void _handleNotificationsAction(BuildContext context) {
    Navigator.pop(context);
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => EventNotificationsManager(),
        )
        .start(context);
  }
}

Future<bool> makeSureIsConnected() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
    return false;
  } on SocketException catch (_) {}
  return false;
}
