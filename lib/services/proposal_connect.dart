// import 'dart:convert';

// import 'package:Solon/models/proposal.dart';
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

    final http.Response response = await http.get(
      "${APIConnect.url}/proposals?sort_by=${queryMap[query]}",
      headers: await APIConnect.headers,
    );
    return response;
  }
}
