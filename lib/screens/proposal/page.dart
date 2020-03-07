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
              } else {
                _voteOutput = snapshot.data['vote']['value'] == 1
                    ? AppLocalizations.of(context).translate("youHaveVotedYes")
                    : AppLocalizations.of(context).translate("youHaveVotedNo");
              }
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
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      widget.proposal.description,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: widget.proposal.date
                                .difference(DateTime.now())
                                .inDays >
                            0
                        ? Text(
                            "${AppLocalizations.of(context).translate("numDaysUntilVotingEnds")} ${widget.proposal.date.difference(DateTime.now()).inDays.toString()}")
                        : Text(
                            AppLocalizations.of(context)
                                .translate("votingIsOver"),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                  ),
                  snapshot.data['message'] == 'Error' && // TODO: check if logic can be cleaner
                          widget.proposal.date
                                  .difference(DateTime.now())
                                  .inDays >
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
                      : Text(_voteOutput),
                  snapshot.data['message'] == 'Error'
                      ? Text('')
                      : VoteBar(
                          numYes: widget.proposal.yesVotes,
                          numNo: widget.proposal.noVotes)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
