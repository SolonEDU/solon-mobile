import 'dart:convert';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/user_util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProposalUtil {
  static Stream<List<Proposal>> _getList(
      {Function function, String query}) async* {
    http.Response response = await function(query: query);
    final sharedPrefs = await UserUtil.connectSharedPreferences();
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

  static Future<void> vote(int pid, int voteVal) async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = json.decode(prefs.getString('userData'))['uid'];
    ProposalConnect.connectVotes(
      'POST',
      pid: pid,
      uidUser: userUid,
      voteVal: voteVal,
    );
  }

}
