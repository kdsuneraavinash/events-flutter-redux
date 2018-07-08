import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/event_info_button.dart'
    show EventInfoButton;

/// Page to show Event Date/Time
class EventTimeDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        EventInfoButton(
          icon: Icons.web,
          title: "Facebook\n(www.facebook.com/fake.link)",
          handleTap: () => null,
        ),
        EventInfoButton(
          icon: Icons.call,
          title: "Call\n076-9955684 (Ruwan)",
          handleTap: () => null,
        ),
        EventInfoButton(
          icon: Icons.message,
          title: "Message\n076-9955684 (Ruwan)",
          handleTap: () => null,
        ),
      ],
    );
  }
}
