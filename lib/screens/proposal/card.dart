import 'dart:convert';
import 'package:Solon/widgets/text_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/screen_card.dart';
import 'package:Solon/widgets/bars/vote_bar.dart';
import 'package:Solon/screens/proposal/page.dart';

class ProposalCard extends StatefulWidget {
  final Proposal proposal;

  ProposalCard({
    Key key,
    this.proposal,
  }) : super(key: key);

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> {
  bool _voted;
  Future<Map<String, dynamic>> _listFutureProposal;
  final GlobalKey _textKey = GlobalKey();
  double textWidth;

  Future<Map<String, dynamic>> getVote() async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = json.decode(prefs.getString('userData'))['uid'];
    final responseMessage = await ProposalConnect.connectVotes(
      'GET',
      pid: widget.proposal.pid,
      uidUser: userUid,
    );
    return responseMessage;
  }

  @override
  void initState() {
    _listFutureProposal = getVote();
    // WidgetsBinding.instance.addPostFrameCallback((_) => getSize());
    super.initState();
  }

  getSize() {
    RenderBox _textBox = _textKey.currentContext.findRenderObject();
    textWidth = _textBox.size.width;
    print(textWidth);
  }

  @override
  Widget build(BuildContext context) {
    Function function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProposalPage(
            proposal: widget.proposal,
          ),
        ),
      );
    };
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextLayout.fillLinesWithTextAndAppendEllipses(
            rawText: widget.proposal.title),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: widget.proposal.date.difference(DateTime.now()).inDays > 0
                ? Text( // TODO: needa translate "Voting is over!"
                    "${AppLocalizations.of(context).translate("numDaysUntilVotingEnds")} ${widget.proposal.date.difference(DateTime.now()).inDays.toString()}",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  )
                : Text("Voting is over!"),
          ),
          Text(
            "${widget.proposal.yesVotes + widget.proposal.noVotes} ${AppLocalizations.of(context).translate("votes")}",
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _listFutureProposal,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.data == null) {
                return Center();
              } else {
                _voted = (snapshot.data['message'] == 'Error') ? false : true;
                if (_voted) {
                  return VoteBar(
                    numYes: widget.proposal.yesVotes,
                    numNo: widget.proposal.noVotes,
                  );
                } else {
                  return Center();
                }
              }
            },
          ),
        ],
      ),
    );
    return ScreenCard(tile: tile, function: function);
  }
}
