class ForumPost {
  final int fid;
  final String title;
  final String description;
  final DateTime timestamp;
  final int uid;

  ForumPost({
    this.fid,
    this.title,
    this.description,
    this.timestamp,
    this.uid,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      fid: json['fid'],
      title: json['title'],
      description: json['description'],
      timestamp: json['timestamp'],
      uid: json['uid'],
    );
  }

  Map toForumPostMap() {
    var map = new Map<String, dynamic>();
    map['title'] = title;
    map['description'] = description;
    map['timestamp'] = timestamp;
    map['uid'] = uid;
    print("${title} ${description} ${timestamp} ${uid}");
    print("MAP ${map}");
    return map;
  }
}


