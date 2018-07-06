import 'package:flutter/material.dart';

import 'package:event_app/event.dart' show Event;
import 'package:event_app/custom_widgets/network_image.dart'
    show DefParameterNetworkImage;

/// Controls in the middle of [EventBannerView]
/// Contains a PageView with an image.
/// TODO: Implement dynamic no of images
class MiddleControls extends StatefulWidget {
  MiddleControls(this.event);
  final Event event;

  @override
  State<StatefulWidget> createState() => MiddleControlsState(this.event);
}

/// State of MiddleControls
class MiddleControlsState extends State<MiddleControls> {
  @override
  Widget build(BuildContext context) {
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

  MiddleControlsState(this.event);
  final Event event;
}