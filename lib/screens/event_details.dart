import 'package:flutter/material.dart';

import 'package:event_app/screens/event_details/event_info.dart' show EventInfo;
import 'package:event_app/screens/event_details/event_location.dart'
    show EventLocation;
import 'package:event_app/screens/event_details/event_organizer.dart'
    show EventOrganizer;
import 'package:event_app/screens/event_details/event_time.dart'
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
        title: Text(this.widget.event.eventName),
      ),
      body: PageView(
        controller: widget.pageController,
        onPageChanged: _handlePageChanged,
        children: <Widget>[
          EventInfo(),
          EventLocation(),
          EventTimeDate(),
          EventOrganizer(),
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
            backgroundColor: Colors.blue[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city),
            title: Text("Location"),
            backgroundColor: Colors.cyan[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text("Time/Date"),
            backgroundColor: Colors.red[800],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("Organizers"),
            backgroundColor: Colors.green[800],
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
