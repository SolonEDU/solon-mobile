class Proposal {
  final int pid;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final int uid;
  final int numYes;
  final int numNo;

  Proposal(
      {this.pid,
      this.title,
      this.startTime,
      this.endTime,
      this.uid,
      this.numYes,
      this.numNo});

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      pid: json['pid'],
      title: json['title'],
      startTime: json['starttime'],
      endTime: json['endtime'],
      uid: json['uid'],
      numYes: json['numyes'],
      numNo: json['numno'],
    );
  }
}
