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
}


