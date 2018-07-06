import 'package:flutter/material.dart';

import 'package:event_app/windows/event_list.dart' show EventListWindow;
import 'package:event_app/theme.dart' as Theme;

/// Run main App
void main() => runApp(MoraEventsApp());

/// App Main Entry Point
/// Sets up theme
class MoraEventsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MoraEvents",
      theme: Theme.kAndroidTheme,
      home: EventListWindow(),
    );
  }
}
