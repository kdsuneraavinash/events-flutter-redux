/// Class to hold info on events
/// Will be used as main object to save, load, show info
class Event {
  String eventName;
  String organizer;
  String time;
  String date;
  List<String> images;
  String headerImage;
  String description;

  /// Create an event for test purposes
  Event.fromIndex(int index) {
    this.eventName = "Event Name";
    this.organizer = "Organizer";
    this.time = "4:40PM";
    this.date = "May 25";
    this.images = [
      "https://picsum.photos/400/400?image=$index",
      "https://picsum.photos/400/400?image=${index + 3}",
      "https://picsum.photos/400/400?image=${index + 23}",
    ];
    this.headerImage = this.images[0];
    this.description =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor "
        "incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis "
        "nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n"
        " Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore "
        "eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt "
        "in culpa qui officia deserunt mollit anim id est laborum.";
  }
}
