import 'dart:async' show Future;

import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/event.dart';
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:flutter/material.dart';
import 'package:event_app/redux_store/reducers.dart' show reducers;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/screens/event_list.dart' show EventListWindow;
import 'package:event_app/theme.dart' as Theme;
import 'package:flutter_redux/flutter_redux.dart' show StoreProvider;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/redux_store/middleware.dart'
    show readAllDocuments, listenToChanges;
import 'package:redux_epics/redux_epics.dart' show EpicMiddleware, combineEpics;
import 'package:firebase_messaging/firebase_messaging.dart';

/// Run main App
void main() {
  return runApp(MoraEventsApp());
}

/// App Main Entry Point
/// Sets up theme
class MoraEventsApp extends StatelessWidget {
  // Main store holder (REDUX)
  final store = new Store<EventStore>(
    reducers,
    initialState: EventStore.empty(),
    middleware: [
      EpicMiddleware<EventStore>(
          combineEpics([readAllDocuments, listenToChanges]))
    ],
  );

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
