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
}
