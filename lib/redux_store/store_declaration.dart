import 'package:event_app/redux_store/reducers.dart' show reducers;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:redux/redux.dart' show Store;
import 'package:event_app/redux_store/middleware.dart'
    show readAllDocuments, listenToChanges;
import 'package:redux_epics/redux_epics.dart' show EpicMiddleware, combineEpics;
  
  // Main store holder (REDUX)
  final baseStore = new Store<EventStore>(
    reducers,
    initialState: EventStore.empty(),
    middleware: [
      EpicMiddleware<EventStore>(
          combineEpics([readAllDocuments, listenToChanges]))
    ],
  );