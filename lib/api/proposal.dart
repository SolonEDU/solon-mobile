class Proposal {
  final int pid;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final int uid;
  final int numYes;
  final int numNo;

  Proposal({
    this.pid,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.uid,
    this.numYes,
    this.numNo,
  });

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      pid: json['pid'],
      title: json['title'],
      description: json['description'],
      startTime: json['starttime'],
      endTime: json['endtime'],
      uid: json['uid'],
      numYes: json['numyes'],
      numNo: json['numno'],
    );
  }

  Map toProposalMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['description'] = description;
    map['starttime'] = startTime;
    map['endtime'] = endTime;
    map['uid'] = uid;
    return map;
  }
}
