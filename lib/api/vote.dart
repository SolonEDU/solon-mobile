class Vote {
  final int vid;
  final int pid;
  final int uidUser;
  final int voteVal;

  Vote({
    this.vid,
    this.pid,
    this.uidUser,
    this.voteVal,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      vid: json['vid'],
      pid: json['pid'],
      uidUser: json['uid'],
      voteVal: json['value'],
    );
  }

  Map toVoteMap() {
    var map = new Map<String, dynamic>();
    map['pid'] = pid;
    map['uid'] = uidUser;
    map['value'] = voteVal;
    print("$pid $uidUser $voteVal");
    print("MAP $map");
    return map;
  }
}
