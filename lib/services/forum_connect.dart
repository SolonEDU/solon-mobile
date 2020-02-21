import 'dart:convert';

import 'package:Solon/models/comment.dart';
import 'package:Solon/models/message.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:http/http.dart' as http;

class ForumConnect {

  static Future<http.Response> connectForumPosts({String query}) async {
    if (query == null) {
      query = 'Newly created';
    }

    Map<String, String> queryMap = {
      'Newly created': 'timestamp.desc',
      'Oldest created': 'timestamp.asc',
      'Most comments': 'numcomments.desc',
      'Least comments': 'numcomments.asc',
    };

    return await http.get(
      "${APIConnect.url}/forumposts?sort_by=${queryMap[query]}",
      headers: await APIConnect.headers,
    );
  }

  static Future<http.Response> searchForum({String query}) async {
    return await http.get(
      "${APIConnect.url}/forumposts?q=$query",
      headers: await APIConnect.headers,
    );
  }

  static Future<Message> addForumPost(
    String title,
    String description,
    DateTime timestamp,
  ) async {
    final userData = await APIConnect.connectSharedPreferences();
    final response = await http.post(
      "${APIConnect.url}/forumposts",
      body: json.encode({
        'title': title,
        'description': description,
        'timestamp': timestamp.toIso8601String(),
        'uid': userData['uid'],
      }),
      headers: await APIConnect.headers,
    );

    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message field in forum post object not found.');
  }

    static Future<List<Comment>> connectComments({int fid}) async {
    final http.Response response = await http.get(
      "${APIConnect.url}/comments/forumpost/$fid",
      headers: await APIConnect.headers,
    );

    final sharedPrefs = await APIConnect.connectSharedPreferences();
    final prefLangCode = APIConnect.languages[sharedPrefs['lang']];

    List collection = json.decode(response.body)['comments'];
    // List<Comment> _comments =
    //     collection.map((json) => Comment.fromJson(json, prefLangCode)).toList();
    // return _comments;
  }

  static Future<Message> addComment({
    int fid,
    String comment,
    String timestamp,
    int uid,
  }) async {
    final userData = await APIConnect.connectSharedPreferences();
    final response = await http.post(
      "${APIConnect.url}/comments",
      body: json.encode({
        'fid': fid,
        'content': comment,
        'timestamp': timestamp,
        'uid': userData['uid'],
      }),
      headers: await APIConnect.headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message field in comment object not found.');
  }
}
