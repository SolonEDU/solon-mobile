import 'package:Solon/util/utility.dart';
import 'package:Solon/models/comment.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/services/forum_connect.dart';

class ForumUtil {
  static Stream<List<Comment>> getComments({int fid}) {
    return Utility.getList<Comment>(
      function: ForumConnect.connectComments,
      fid: fid,
      body: 'comments',
    );
  }

  static Stream<List<ForumPost>> screenView(String query) {
    return Utility.getList<ForumPost>(
      function: ForumConnect.connectForumPosts,
      query: query,
      body: 'forumposts',
    );
  }

  static Stream<List<ForumPost>> searchView(String query) {
    return Utility.getList(
      function: ForumConnect.searchForum,
      query: query,
      body: 'forumposts',
    );
  }
}
