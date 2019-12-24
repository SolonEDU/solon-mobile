class Event {
  final int eid;
  final String title;
  final String description;
  final String date;
  final String dateCreated;
  final int numAttenders;

  Event({
    this.eid,
    this.title,
    this.description,
    this.date,
    this.dateCreated,
    this.numAttenders,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eid: json['eid'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      dateCreated: json['datecreated'],
      numAttenders: json['numattenders'],
    );
  }

  Map toEventMap() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
