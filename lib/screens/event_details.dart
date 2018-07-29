import 'package:flutter/material.dart';
import 'package:event_app/state/event.dart';
import 'package:event_app/screens/event_details/event_info.dart' show EventInfo;
import 'package:event_app/screens/event_details/event_links.dart'
    show EventLinks;
import 'package:event_app/screens/event_details/event_images.dart'
    show ImageGrid;

/// Event Details Page which hosts a PageView to show all info
class EventDetails extends StatefulWidget {
  @override
  EventDetailsState createState() {
    return new EventDetailsState();
  }

  final PageController pageController = new PageController(initialPage: 0);
  final Event event;

  EventDetails(this.event);
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
      body: _buildPagedWindow(
        widget.event,
        PageView(
          controller: widget.pageController,
          onPageChanged: _handlePageChanged,
          children: <Widget>[
            EventInfo(widget.event),
            ImageGrid(widget.event),
            EventLinks(),
          ],
        ),
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
            icon: Icon(Icons.image),
            title: Text("Images"),
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

  Widget _buildPagedWindow(Event event, Widget child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildInlineListTile(
          "Start Date",
          event.startTimeString,
          Icons.hourglass_full,
          context,
        ),
        _buildInlineListTile(
          "End Date",
          event.endTimeString,
          Icons.hourglass_empty,
          context,
        ),
        Expanded(
          child: child,
        )
      ],
    );
  }

  Widget _buildInlineListTile(
      String title, String text, IconData icon, BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).cardColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).cardColor,
          ),
        ),
        trailing: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).cardColor,
          ),
        ),
      ),
    );
  }

  /// Animate PageView when BottomNavigationBar is tapped
  void _handleBottomNavigationBarTap(int index) {
    if ((currentIndex - index).abs() > 1) {
      // Jump to page if page is far away
      widget.pageController.jumpToPage(
        index,
      );
    } else {
      widget.pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    }
    setState(() {
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
