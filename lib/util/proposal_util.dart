import 'dart:convert';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:http/http.dart' as http;

class ProposalUtil {
  static Stream<List<Proposal>> proposalListView(String query) async* {
    http.Response response =
        await ProposalConnect.connectProposals(query: query);
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
}
