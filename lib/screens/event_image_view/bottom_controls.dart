import 'package:event_app/custom_widgets/transition_maker.dart';
import 'package:event_app/event.dart';
import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/rounded_button.dart'
    show RoundedButton;
import 'package:event_app/screens/event_details.dart' show EventDetails;

/// Controls in the bottom of [EventBannerView]
/// Contains a IconButton with an image.
/// TODO: Add Favourite Button here
class BottomControls extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomControlsState();

  BottomControls(this.event);
  final Event event;
}

/// State of BottomControls
class BottomControlsState extends State<BottomControls> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      alignment: Alignment.bottomRight,
      child: RoundedButton(
        buttonIcon: Icons.event_note,
        text: "View Event",
        onPressed: () => _handleEventButtonPress(context),
      ),
    );
  }

  void _handleEventButtonPress(BuildContext context) {
    TransitionMaker
        .slideTransition(
            destinationPageCall: () => EventDetails(
                  event: widget.event,
                ),
            beginOffset: Offset(0.0, 1.0),
            endOffset: Offset(0.0, 0.0),
    )
        .start(context);
  }
}
