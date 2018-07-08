import 'package:flutter/material.dart';

import 'package:event_app/screens/event_details/event_info.dart' show EventInfo;
import 'package:event_app/screens/event_details/event_links.dart'
    show EventTimeDate;

import 'package:event_app/event.dart' show Event;

/// Event Details Page which hosts a PageView to show all info
class EventDetails extends StatefulWidget {
  @override
  EventDetailsState createState() {
    return new EventDetailsState();
  }

  EventDetails({this.event});
  final Event event;
  final PageController pageController = new PageController(initialPage: 0);
}

/// State of EventDetails
/// Will contain a PageView and a BottomNavigationBar to navigate
class EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event Info"),
      ),
      body: PageView(
        controller: widget.pageController,
        onPageChanged: _handlePageChanged,
        children: <Widget>[
          EventInfo(widget.event),
          EventTimeDate(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: _handleBottomNavigationBarTap,
        currentIndex: this.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note),
            title: Text("Event Info"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.link),
            title: Text("Contact"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  /// Animate PageView when BottomNavigationBar is tapped
  /// If the page is far away jump to that page without animating
  void _handleBottomNavigationBarTap(int index) {
    setState(() {
      if ((currentIndex - index).abs() <= 1) {
        widget.pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );
      } else {
        widget.pageController.jumpToPage(index);
      }
      currentIndex = index;
    });
  }

  /// Change index of BottomNavigationBar if PageView is turned
  void _handlePageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  int currentIndex = 0;
}
