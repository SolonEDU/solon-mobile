class Event {
  final int eid;
  final Map<String, String> title;
  final Map<String, String> description;
  final DateTime date;
  final DateTime datecreated;
  final int numattenders;
  final String entitle;
  final String endescription;

  Event({
    this.eid,
    this.title,
    this.description,
    this.date,
    this.datecreated,
    this.numattenders,
    this.entitle,
    this.endescription,
  });

  factory Event.fromJson() {
    return Event();
  }
}
