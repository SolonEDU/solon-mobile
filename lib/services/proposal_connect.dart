import 'dart:convert';

import 'package:Solon/models/message.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:http/http.dart' as http;

class ProposalConnect {
  static Future<http.Response> connectProposals({String query}) async {
    if (query == null) {
      query = 'Newly created';
    }

    Map<String, String> queryMap = {
      'Most votes': 'numvotes.desc',
      'Least votes': 'numvotes.asc',
      'Newly created': 'starttime.desc',
      'Oldest created': 'starttime.asc',
      'Upcoming deadlines': 'endtime.desc',
      'Oldest deadlines': 'endtime.asc',
    };

    return await http.get(
      "${APIConnect.url}/proposals?sort_by=${queryMap[query]}",
      headers: await APIConnect.headers,
    );
  }

  static Future<http.Response> searchProposals({String query}) async {
    return await http.get(
      "${APIConnect.url}/proposals?q=$query",
      headers: await APIConnect.headers,
    );
  }

    static Future<Message> addProposal(
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    int uid,
  ) async {
    final response = await http.post(
    "${APIConnect.url}/proposals",
      body: json.encode({
        'title': title,
        'description': description,
        'starttime': startTime.toIso8601String(),
        'endtime': endTime.toIso8601String(),
        'uid': uid,
      }),
      headers: await APIConnect.headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message field in proposal object not found.');
  }
}
