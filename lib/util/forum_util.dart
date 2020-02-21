import 'package:Solon/models/comment.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:http/http.dart' as http;
import 'package:Solon/services/api_connect.dart';
import 'dart:convert';
import 'package:Solon/services/forum_connect.dart';

class ForumUtil {
  static Stream<List<ForumPost>> _getList(
      {Function function, String query}) async* {
    http.Response response = await function(query: query);
    final sharedPrefs = await APIConnect.connectSharedPreferences();
    final prefLangCode = APIConnect.languages[sharedPrefs['lang']];
    List<ForumPost> _posts;
    List collection;
    if (response.statusCode == 200) {
      collection = json.decode(response.body)['forumposts'];
      _posts = collection
          .map((json) =>
              ForumPost.fromJson(map: json, prefLangCode: prefLangCode))
          .toList();
    }
    yield _posts;
  }

  static Stream<List<Comment>> getComments({int fid}) async* {
    http.Response response = await ForumConnect.connectComments(fid: fid);
    final sharedPrefs = await APIConnect.connectSharedPreferences();
    final prefLangCode = APIConnect.languages[sharedPrefs['lang']];
    List<Comment> _comments;
    List collection;
    if (response.statusCode == 200) {
      collection = json.decode(response.body)['comments'];
      _comments = collection.map((json) => Comment.fromJson(map: json, prefLangCode: prefLangCode)).toList();
    }
    yield _comments;
  }

  static Stream<List<ForumPost>> screenView(String query) {
    return _getList(
      function: ForumConnect.connectForumPosts,
      query: query,
    );
  }

  static Stream<List<ForumPost>> searchView(String query) {
    return _getList(
      function: ForumConnect.searchForum,
      query: query,
    );
  }
}
