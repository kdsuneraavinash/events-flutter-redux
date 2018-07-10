import 'package:event_app/custom_widgets/network_image.dart';
import 'package:event_app/custom_widgets/rounded_button.dart';
import 'package:event_app/custom_widgets/transition_maker.dart';
import 'package:event_app/screens/event_details.dart';
import 'package:flutter/material.dart';
import 'package:event_app/event.dart' show Event;

/// State of EventImageView
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

  void _handleEventButtonPress(BuildContext context) {
    TransitionMaker
        .slideTransition(
          destinationPageCall: () => EventDetails(),
          beginOffset: Offset(0.0, 1.0),
          endOffset: Offset(0.0, 0.0),
        )
        .start(context);
  }

  EventImageView(this.event);
  final Event event;
}
