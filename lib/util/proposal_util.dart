import 'dart:convert';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:http/http.dart' as http;

class ProposalUtil {
  static Stream<List<Proposal>> _getList(
      {Function function, String query}) async* {
    http.Response response = await function(query: query);
    final sharedPrefs = await APIConnect.connectSharedPreferences();
    final prefLangCode = APIConnect.languages[sharedPrefs['lang']];
    List<Proposal> _proposals;
    List collection;
    if (response.statusCode == 200) {
      collection = json.decode(response.body)['proposals'];
      _proposals = collection
          .map((json) =>
              Proposal.fromJson(map: json, prefLangCode: prefLangCode))
          .toList();
    }
    yield _proposals;
  }

  static Stream<List<Proposal>> screenView(String query) {
    return _getList(
      function: ProposalConnect.connectProposals,
      query: query,
    );
  }

  static Stream<List<Proposal>> searchView(String query) {
    return _getList(
      function: ProposalConnect.searchProposals,
      query: query,
    );
  }
}
