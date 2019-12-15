class Comment {
  final int cid;
  final int fid;
  final String content;
  final DateTime date;
  final int uid;

  Comment({
    this.cid,
    this.fid,
    this.content,
    this.date,
    this.uid,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      cid: json['cid'],
      fid: json['fid'],
      content: json['content'],
      date: json['date'],
      uid: json['uid'],
    );
  }
}


