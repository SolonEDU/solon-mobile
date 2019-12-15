class Event {
  final int eid;
  final String title;
  final String description;
  final DateTime date;
  final DateTime dateCreated;
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
}