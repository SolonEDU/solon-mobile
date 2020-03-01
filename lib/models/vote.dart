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

  factory Vote.fromJson() {
    return Vote();
  }
}
