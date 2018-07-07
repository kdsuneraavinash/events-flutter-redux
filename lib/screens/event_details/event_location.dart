import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/event_info_card.dart'
    show EventInfoCard;

/// Page to show Event Location
class EventLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EventInfoCard(
      icon: Icons.map,
      title: "Link Google Maps",
      description: "",
    );
  }
}
