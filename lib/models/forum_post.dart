class ForumPost {
  final int fid;
  final Map<String, String> title;
  final Map<String, String> description;
  final int numcomments;
  final DateTime timestamp;
  final int uid;
  final String entitle;
  final String endescription;

  ForumPost({
    this.fid,
    this.title,
    this.description,
    this.numcomments,
    this.timestamp,
    this.uid,
    this.entitle,
    this.endescription,
  });

  factory ForumPost.fromJson() {
    return ForumPost();
  }
}
