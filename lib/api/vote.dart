class Vote {
  final int pid;
  final int uid;
  final int value;
  
  Vote({
    this.pid,
    this.uid,
    this.value,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      pid: json['uid'],
      uid: json['firstname'],
      value: json['lastname'],
    );
  }
}
