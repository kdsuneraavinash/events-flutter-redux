class Event {
  String eventName;
  String organizer;
  String time;
  String date;
  List<String> images;
  String headerImage;

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
  }
}
