import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;
import 'package:event_app/custom_widgets/rounded_button.dart'
    show RoundedButton;
import 'package:event_app/custom_widgets/transition_maker.dart'
    show TransitionMaker;
import 'package:event_app/event.dart' show Event;
import 'package:event_app/screens/event_details.dart' show EventDetails;
import 'package:flutter/material.dart';

/// Hosts PageView and buttons.
class EventImageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(this.event.eventName),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _buildImageBox(),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  /// Build Page View with Images
  /// TODO: Add images Pan ability
  Widget _buildImageBox() {
    return Center(
      child: Hero(
        tag: this.event,
        child: PageView(
            children: this
                .event
                .images
                .map((v) => DefParameterNetworkImage(imageUrl: v))
                .toList()),
      ),
    );
  }

  /// Bottom button
  Widget _buildBottomButton(BuildContext context) {
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

  /// Bottom button pressed
  void _handleEventButtonPress(BuildContext context) {
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => EventDetails(this.event),
          beginOffset: Offset(0.0, 1.0),
          endOffset: Offset(0.0, 0.0),
        )
        .start(context);
  }

  EventImageView(this.event);

  final Event event;
}
