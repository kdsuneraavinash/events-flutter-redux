import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/event_info_card.dart'
    show EventInfoCard;

/// Page to show Event Date/Time
class EventTimeDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        EventInfoCard(
          icon: Icons.web,
          title: "Facebook",
          description: "www.facebook.com/fake.link",
          handleTap: () => null,
        ),
        EventInfoCard(
          icon: Icons.call,
          title: "Call",
          description: "076-9955684 (Ruwan)",
          handleTap: () => null,
        ),
        EventInfoCard(
          icon: Icons.message,
          title: "Message",
          description: "076-9955684 (Ruwan)",
          handleTap: () => null,
        ),
      ],
    );
  }
}
