import 'dart:convert';

import 'package:Solon/models/message.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/services/status_codes_handler.dart';
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

  static Future<bool> getAttendance({int eid, int uid}) async {
    final http.Response response = await http.get(
      "${APIConnect.url}/attenders/$eid/$uid",
      headers: await APIConnect.headers,
    );
    String responseMessage = json.decode(response.body)['message'];
    return responseMessage == 'Error' ? false : true;
  }

  static Future<Message> changeAttendance(
    String httpReqType, {
    int eid,
    int uid,
  }) async {
    print('from changeAttendance: $uid');
    http.Response response;
    if (httpReqType == "POST") {
      response = await http.post(
        "${APIConnect.url}/attenders",
        body: json.encode({
          'eid': eid,
          'uid': uid,
        }),
        headers: await APIConnect.headers,
      );
      int status = response.statusCode;
      return status == 201
          ? Message.fromJson(json.decode(response.body)['message'])
          : throw Exception(
              'Attendance value of user $uid could not be created for event $eid.');
    } else if (httpReqType == "DELETE") {
      response = await http.delete(
        "${APIConnect.url}/attenders/$eid/$uid",
        headers: await APIConnect.headers,
      );
      int status = response.statusCode;
      return status == 201
          ? Message.fromJson(json.decode(response.body)['message'])
          : throw Exception(
              'Attendance value of user $uid could not be deleted for event $eid.');
    }
    return StatusCodesHandler.handleStatusCode(response, response.statusCode);
  }
}
