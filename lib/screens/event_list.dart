import 'package:event_app/state/query.dart';
import 'package:flutter/material.dart';
import 'dart:async' show Future;
import 'dart:io' show SocketException, InternetAddress;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/redux_store/actions.dart'
    show
        FirestoreEndConnection,
        FirestoreListenToUpdates,
        FirestoreRefreshAll,
        SearchOptionsSet,
        SearchStringSet;
import 'package:event_app/redux_store/store.dart' show EventStore;
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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

/// Main Page that displays a list of available Events.
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
    return SearchBoxedScaffold(
      appBarTitle: Text("Mora Events"),
      appBarActions: <Widget>[
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () => _handleFilterAction(context, store),
        ),
      ],
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
              leading: Icon(FontAwesomeIcons.mapPin),
              title: Text("Pinned Events"),
              subtitle: Text("Show events that you pinned"),
              onTap: () => _handleFlaggedAction(context),
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.questionCircle),
              title: Text("Credits"),
              subtitle: Text("About our team"),
              onTap: () => _handleCreditsAction(context),
            ),
          ],
        ),
      ),
      body: EventListBody(store),
      store: store,
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
      title: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.warning,
            color: Theme.of(context).accentColor,
          ),
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
    Navigator.pop(context);
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
    QueryOptions searchOptions = QueryOptions.original();
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

class SearchBoxedScaffold extends StatefulWidget {
  @override
  _SearchBoxedScaffoldState createState() => _SearchBoxedScaffoldState();

  final Widget appBarTitle;
  final List<Widget> appBarActions;
  final Widget drawer;
  final Widget body;
  final Store<EventStore> store;
  SearchBoxedScaffold(
      {this.appBarTitle,
      this.appBarActions,
      this.drawer,
      this.body,
      this.store});
}

class _SearchBoxedScaffoldState extends State<SearchBoxedScaffold> {
  SearchBar searchBar;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      drawer: widget.drawer,
      body: widget.body,
    );
  }

  void textChanged() {
    widget.store.dispatch(SearchStringSet(controller.text));
  }

  _SearchBoxedScaffoldState() {
    controller.addListener(textChanged);
    searchBar = SearchBar(
      inBar: true,
      setState: setState,
      buildDefaultAppBar: (_) => buildDefaultAppBar(),
      clearOnSubmit: false,
      closeOnSubmit: false,
      controller: controller,
    );
  }

  AppBar buildDefaultAppBar() {
    // When showing default bar, search string = ""
    controller.text = "";
    IconButton searchButton = IconButton(
      icon: Icon(FontAwesomeIcons.search),
      onPressed: searchBar.getSearchAction(context).onPressed,
    );
    return AppBar(
      title: widget.appBarTitle,
      actions: List.from(widget.appBarActions)..add(searchButton),
    );
  }

  @override
  void dispose() {
    controller.removeListener(textChanged);
    super.dispose();
  }
}
