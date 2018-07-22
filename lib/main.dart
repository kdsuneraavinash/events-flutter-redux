import 'package:event_app/redux_store/reducers.dart' show reducers;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list.dart' show EventListWindow;
import 'package:event_app/theme.dart' as Theme;
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart'
    show StoreBuilder, StoreProvider;
import 'package:redux/redux.dart' show Store;

/// Run main App
void main() {
  // Main store holder (REDUX)
  final store = new Store<EventStore>(
    reducers,
    initialState: EventStore.loadEventStore(),
  );
  return runApp(MoraEventsApp(store));
}

/// App Main Entry Point
/// Sets up theme
class MoraEventsApp extends StatelessWidget {
  final Store<EventStore> store;

  MoraEventsApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      child: MaterialApp(
        title: "MoraEvents",
        theme: Theme.buildTheme(context),
        home: EventListWindow(),
      ),
      store: this.store,
    );
  }
}
