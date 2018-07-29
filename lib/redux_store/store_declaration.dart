import 'package:event_app/redux_store/reducers.dart' show reducers;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/redux_store/middleware.dart'
    show readAllDocuments, listenToChanges;
import 'package:redux_epics/redux_epics.dart' show EpicMiddleware, combineEpics;
import 'package:redux_persist/redux_persist.dart' show Persistor;
import 'package:redux_persist_flutter/redux_persist_flutter.dart'
    show FlutterStorage;

// Main store holder (REDUX)

// Create Persistor
// https://pub.dartlang.org/packages/redux_persist_flutter#-readme-tab-
Persistor<EventStore> persistor = Persistor<EventStore>(
  // TODO: Save to documents folder if it is stable
  storage: FlutterStorage("my-app"), // Or use other engines
  decoder: EventStore.fromJson,
);

final baseStore = Store<EventStore>(
  reducers,
  initialState: EventStore.empty(),
  middleware: [
    EpicMiddleware<EventStore>(
        combineEpics([readAllDocuments, listenToChanges])),
    persistor.createMiddleware()
  ],
);
