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
    var map = new Map<String, dynamic>();
    map['fid'] = fid;
    map['content'] = content;
    map['timestamp'] = timestamp;
    map['uid'] = uid;
    print("$fid $content $timestamp $uid");
    print("MAP $map");
    return map;
  }
}


