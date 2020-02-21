import 'package:Solon/services/api_connect.dart';
import 'package:http/http.dart' as http;

class EventConnect {
  static Future<http.Response> connectEvents({int uid, String query}) async {
    if (query == null) {
      query = 'Newly created';
    }

    Map<String, String> queryMap = {
      'Furthest': 'date.desc',
      'Upcoming': 'date.asc',
      'Most attendees': 'numattenders.desc',
      'Least attendees': 'numattenders.asc',
    };

    return await http.get(
      "${APIConnect.url}/events?sort_by=${queryMap[query]}",
      headers: await APIConnect.headers,
    );
  }


  static Future<http.Response> searchEvents({String query}) async {
    return await http.get(
      "${APIConnect.url}/events?q=$query",
      headers: await APIConnect.headers,
    );
  }
}
