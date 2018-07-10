import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;
import 'package:event_app/custom_widgets/launch_button.dart' show LaunchButton;
import 'package:flutter_redux/flutter_redux.dart' show StoreConnector;

/// Page to show Event Contact Links/Phone Numbers
class EventLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
        converter: (store) => store.state,
        builder: (context, eventStore) =>
            buildEventLinks(context, eventStore.currentSelectedEvent));
  }

  /// Separated build method because StoreConnector is used
  Widget buildEventLinks(BuildContext context, Event event) {
    return ListView(
      children: event.contact == null
          ? []
          : event.contact.map((tmp) => LaunchButton(tmp)).toList(),
    );
  }
}
