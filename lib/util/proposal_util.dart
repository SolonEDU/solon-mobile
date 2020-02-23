import 'dart:convert';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/user_util.dart';
import 'package:http/http.dart' as http;

class ProposalUtil {
  static Stream<List<Proposal>> _getList({
    Function function,
    String query,
  }) async* {
    http.Response response = await function(query: query);
    String prefLangCode = await UserUtil.getPrefLangCode();
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
    final sharedPrefs = await UserUtil.connectSharedPreferences(
      key: 'userData',
    );
    final userUid = sharedPrefs['uid'];
    ProposalConnect.connectVotes(
      'POST',
      pid: pid,
      uidUser: userUid,
      voteVal: voteVal,
    );
  }
}
