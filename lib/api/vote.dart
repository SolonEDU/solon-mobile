class Vote {
  final int vid;
  final int pid;
  final int uid;
  final int value;

  Vote({
    this.vid,
    this.pid,
    this.uid,
    this.value,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      vid: json['vid'],
      pid: json['pid'],
      uid: json['uid'],
      value: json['value'],
    );
  }

  Map toVoteMap() {
    var map = new Map<String, dynamic>();
    map['pid'] = pid;
    map['uid'] = uid;
    map['value'] = value;
    print("$pid $uid $value");
    print("MAP $map");
    return map;
  }
}
