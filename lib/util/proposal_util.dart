import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/user_util.dart';
import 'package:Solon/util/utility.dart';

class ProposalUtil {

  static Stream<List<Proposal>> screenView(String query) {
    return Utility.getList<Proposal>(
      function: ProposalConnect.connectProposals,
      query: query,
      type: Proposal,
      body: 'proposals',
    );
  }

  static Stream<List<Proposal>> searchView(String query) {
    return Utility.getList(
      function: ProposalConnect.searchProposals,
      query: query,
      type: Proposal,
      body: 'proposals',
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
