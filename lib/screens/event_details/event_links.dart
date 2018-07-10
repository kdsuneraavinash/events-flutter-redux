import 'package:event_app/event.dart' show Event, EventContact;
import 'package:event_app/redux_store/store.dart';
import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/launch_button.dart' show LaunchButton;
import 'package:flutter_redux/flutter_redux.dart';

/// Page to show Event Date/Time
class EventLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
        converter: (store) => store.state,
        builder: (context, eventStore) =>
            buildEventLinks(context, eventStore.currentSelectedEvent));
  }

  Widget buildEventLinks(BuildContext context, Event event) {
    return ListView(
        children: event.contact == null
            ? []
            : event.contact.map(mapToLaunchButton).toList());
  }

  LaunchButton mapToLaunchButton(EventContact contact) {
    return LaunchButton(contact);
  }
}
