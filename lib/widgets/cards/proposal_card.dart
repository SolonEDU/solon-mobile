import 'dart:convert';
import 'package:Solon/widgets/text_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/cards/screen_card.dart';
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

  Future<Map<String, dynamic>> getVote() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final userUid = json.decode(sharedPrefs.getString('userData'))['uid'];
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
    super.initState();
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

    int _totalVotes = widget.proposal.yesVotes + widget.proposal.noVotes;
    int _differenceDays =
        widget.proposal.date.difference(DateTime.now()).inDays;
    int _differenceHours =
        widget.proposal.date.difference(DateTime.now()).inHours;
    int _differenceMinutes =
        widget.proposal.date.difference(DateTime.now()).inMinutes;
    String _timeOutput;
    if (_differenceDays > 1) {
      _timeOutput =
          "${_differenceDays.toString()} ${AppLocalizations.of(context).translate("days")}";
    } else if (_differenceDays == 1) {
      _timeOutput =
          "${_differenceDays.toString()} ${AppLocalizations.of(context).translate("day")}";
    } else if (_differenceHours > 1) {
      _timeOutput =
          "${_differenceHours.toString()} ${AppLocalizations.of(context).translate("hours")}";
    } else if (_differenceHours == 1) {
      _timeOutput =
          "${_differenceHours.toString()} ${AppLocalizations.of(context).translate("hour")}";
    } else if (_differenceMinutes > 1) {
      _timeOutput =
          "${_differenceMinutes.toString()} ${AppLocalizations.of(context).translate("minutes")}";
    } else if (_differenceMinutes == 1) {
      _timeOutput =
          "${_differenceMinutes.toString()} ${AppLocalizations.of(context).translate("minute")}";
    } else {
      _timeOutput = AppLocalizations.of(context).translate("lessThanOneMinute");
    }

    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: TextLayout.fillLinesWithTextAndAppendTrail(
          rawText: widget.proposal.title,
          trail: '...',
          textStyle: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: widget.proposal.date
                        .difference(DateTime.now())
                        .inMilliseconds >=
                    0
                ? Text(
                    "${AppLocalizations.of(context).translate("timeUntilVotingEnds")} $_timeOutput",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  )
                : Text(
                    AppLocalizations.of(context).translate("votingIsOver"),
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
          ),
          Center(
            child: Text(
              "$_totalVotes ${_totalVotes == 1 ? AppLocalizations.of(context).translate("vote") : AppLocalizations.of(context).translate("votes")}",
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: _listFutureProposal,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.data == null) {
                return Center();
              } else {
                if (snapshot.data['message'] == 'Error' &&
                    widget.proposal.date
                            .difference(DateTime.now())
                            .inMilliseconds >=
                        0) {
                  return Center();
                } else {
                  return VoteBar(
                    numYes: widget.proposal.yesVotes,
                    numNo: widget.proposal.noVotes,
                  );
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
