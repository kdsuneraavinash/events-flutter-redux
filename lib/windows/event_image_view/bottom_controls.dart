import 'package:flutter/material.dart';

import 'package:event_app/custom_widgets/rounded_button.dart'
    show RoundedButton;

/// Controls in the bottom of [EventBannerView]
/// Contains a IconButton with an image.
/// TODO: Add Favourite Button here
class BottomControls extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomControlsState();
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
        onPressed: () => null,
      ),
    );
  }
}
