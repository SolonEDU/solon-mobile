import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/proposal_util.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';
import 'package:Solon/widgets/buttons/preventable_button.dart';
import 'package:Solon/widgets/bars/vote_bar.dart';

class ProposalPage extends StatefulWidget {
  final Proposal proposal;

  ProposalPage({
    Key key,
    this.proposal,
  }) : super(key: key);

  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  String _voteOutput;
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
    super.initState();

    _listFutureProposal = getVote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Map<String, dynamic>>(
            future: _listFutureProposal,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data['message'] == 'Error') {
                _voteOutput = "You have not voted yet!";
                if ( // TODO: check if logic can be cleaner
                    widget.proposal.date
                            .difference(DateTime.now())
                            .inMilliseconds <
                        0) {
                  _voteOutput = "You did not vote!";
                }
              } else {
                _voteOutput = snapshot.data['vote']['value'] == 1
                    ? AppLocalizations.of(context).translate("youHaveVotedYes")
                    : AppLocalizations.of(context).translate("youHaveVotedNo");
              }
              int _totalVotes =
                  widget.proposal.yesVotes + widget.proposal.noVotes;
              return ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.proposal.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: "Raleway",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppLocalizations.of(context).translate("description"),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 24.0),
                    child: Text(
                      widget.proposal.description,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 24.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: widget.proposal.date
                                .difference(DateTime.now())
                                .inMilliseconds >=
                            0
                        ? Text(
                            "${AppLocalizations.of(context).translate("timeUntilVotingEnds")} ${widget.proposal.date.difference(DateTime.now()).inDays.toString()}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          )
                        : Text(
                            AppLocalizations.of(context)
                                .translate("votingIsOver"),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  Center(
                    child: Text(
                      "$_totalVotes ${_totalVotes == 1 ? AppLocalizations.of(context).translate("vote") : AppLocalizations.of(context).translate("votes")}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  snapshot.data['message'] ==
                              'Error' && // TODO: check if logic can be cleaner
                          widget.proposal.date
                                  .difference(DateTime.now())
                                  .inMilliseconds >=
                              0
                      ? PreventableButton(
                          body: <Map>[
                            {
                              'color': Colors.green,
                              'height': 55.0,
                              'function': () async* {
                                yield true;
                                ProposalUtil.vote(widget.proposal.pid, 1);
                              },
                              'margin': const EdgeInsets.all(8),
                              'label':
                                  AppLocalizations.of(context).translate("yes"),
                            },
                            {
                              'color': Colors.red,
                              'height': 55.0,
                              'function': () async* {
                                yield true;
                                ProposalUtil.vote(widget.proposal.pid, 0);
                              },
                              'margin': const EdgeInsets.all(8),
                              'label':
                                  AppLocalizations.of(context).translate("no"),
                            }
                          ],
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 8.0),
                          child: Center(
                            child: Text(
                              _voteOutput,
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                  snapshot.data['message'] ==
                              'Error' && // TODO: check if logic can be cleaner
                          widget.proposal.date
                                  .difference(DateTime.now())
                                  .inMilliseconds >=
                              0
                      ? Text('')
                      : VoteBar(
                          numYes: widget.proposal.yesVotes,
                          numNo: widget.proposal.noVotes,
                        )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
