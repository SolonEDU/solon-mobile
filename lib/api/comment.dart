class Comment {
  final int cid;
  final int fid;
  final String content;
  final String timestamp;
  final int uid;

  Comment({
    this.cid,
    this.fid,
    this.content,
    this.timestamp,
    this.uid,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      cid: json['cid'],
      fid: json['fid'],
      content: json['content'],
      timestamp: json['timestamp'],
      uid: json['uid'],
    );
  }

  Map toCommentMap() {
    return {
      'fid': fid,
      'content': content,
      'timestamp': timestamp,
      'uid': uid,
    };
  }
}


