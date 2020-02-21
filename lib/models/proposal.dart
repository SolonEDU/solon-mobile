class Proposal {
  final int pid;
  final Map<String, String> title;
  final Map<String, String> description;
  final DateTime starttime;
  final DateTime endtime;
  final int uid;
  final int numyes;
  final int numno;
  final int numvotes;
  final String entitle;
  final String endescription;

  Proposal({
    this.pid,
    this.title,
    this.description,
    this.starttime,
    this.endtime,
    this.uid,
    this.numyes,
    this.numno,
    this.numvotes,
    this.entitle,
    this.endescription,
  });

  factory Proposal.fromJson() {
    return Proposal();
  }
}
