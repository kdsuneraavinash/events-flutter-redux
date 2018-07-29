import 'package:event_app/redux_store/store_declaration.dart'
    show baseStore, persistor;
import 'package:flutter/material.dart';
import 'package:event_app/screens/event_list.dart' show EventListWindow;
import 'package:event_app/theme.dart' as Theme;
import 'package:flutter_redux/flutter_redux.dart' show StoreProvider;
import 'package:redux_persist_flutter/redux_persist_flutter.dart'
    show PersistorGate;

/// Run main App
void main() {
  return runApp(MoraEventsApp());
}

/// App Main Entry Point
/// Sets up theme
class MoraEventsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PersistorGate(
      persistor: persistor,
      builder: (context) => StoreProvider(
            store: baseStore,
            child: StoreProvider(
              child: MaterialApp(
                title: "MoraEvents",
                theme: Theme.buildTheme(context),
                home: EventListWindow(),
              ),
              store: baseStore,
            ),
          ),
    );
  }

  MoraEventsApp() {
    persistor.load(baseStore);
  }
}
