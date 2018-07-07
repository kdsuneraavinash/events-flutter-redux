import 'package:flutter/material.dart';

import 'package:event_app/event.dart' show Event;

class EventDetails extends StatefulWidget {
  @override
  EventDetailsState createState() {
    return new EventDetailsState();
  }

  EventDetails({this.event});
  final Event event;
  final PageController pageController = new PageController(initialPage: 0);
}

class EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.event.eventName),
      ),
      body: EventDetailsBody(widget.event, widget.pageController),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        onTap: _handleBottomNavigationBarTap,
        currentIndex: this.currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note),
              title: Text("Event Info"),
              backgroundColor: Colors.blue[800]),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_city),
              title: Text("Location"),
              backgroundColor: Colors.cyan[800]),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time),
              title: Text("Time/Date"),
              backgroundColor: Colors.red[800]),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("Organizers"),
              backgroundColor: Colors.green[800]),
        ],
      ),
    );
  }

  void _handleBottomNavigationBarTap(int index) {
    setState(() {
      currentIndex = index;
      widget.pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    });
  }

  int currentIndex = 0;
}

class EventDetailsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: this.pageController,
      children: <Widget>[
        EventInfo(),
        EventLocation(),
        EventTimeDate(),
        EventOrganizer(),
      ],
    );
  }

  EventDetailsBody(this.event, this.pageController);
  final Event event;
  final PageController pageController;
}

class EventInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}

class EventTimeDate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class EventOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
    );
  }
}

class EventLocation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
    );
  }
}
