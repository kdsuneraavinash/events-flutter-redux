import 'package:flutter/material.dart';
import 'package:event_app/redux_store/reducers.dart' show reducers;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list.dart' show EventListWindow;
import 'package:event_app/theme.dart' as Theme;
import 'package:flutter_redux/flutter_redux.dart' show StoreProvider;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/redux_store/middleware.dart' show readAllDocuments,listenToChanges;
import 'package:redux_epics/redux_epics.dart' show EpicMiddleware, combineEpics;

/// Run main App
void main() {
  // Main store holder (REDUX)
  final store = new Store<EventStore>(
    reducers,
    initialState: EventStore.empty(),
    middleware: [EpicMiddleware<EventStore>(combineEpics([readAllDocuments, listenToChanges]))],
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
