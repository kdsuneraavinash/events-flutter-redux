import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:event_app/custom_widgets/event_info_card.dart'
    show EventInfoCard;
import 'package:event_app/event.dart' show Event;
import 'package:event_app/redux_store/store.dart' show EventStore;

/// Page to show Event Information/Description
class EventInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<EventStore, EventStore>(
      converter: (store) => store.state,
      builder: (context, eventStore) =>
          buildEventInfo(context, eventStore.currentSelectedEvent),
    );
  }

  /// Separated build data because StoreConnector is used
  Widget buildEventInfo(BuildContext context, Event event) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "${event.eventName}",
            style: Theme.of(context).textTheme.headline,
            textAlign: TextAlign.center,
          ),
        ),
        EventInfoCard(
          icon: Icons.description,
          title: "Description",
          description: event.description,
        ),
        EventInfoCard(
          icon: Icons.access_time,
          title: "Time",
          description: event.time,
        ),
        EventInfoCard(
          icon: Icons.date_range,
          title: "Date",
          description: event.date,
        ),
        EventInfoCard(
          icon: Icons.location_city,
          title: "Venue",
          description: event.location,
        ),
        EventInfoCard(
          icon: Icons.people,
          title: "Organizers",
          description: event.organizer,
        ),
      ],
    );
  }
}
