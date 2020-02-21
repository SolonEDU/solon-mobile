import 'package:Solon/app_localizations.dart';
import 'package:Solon/doubletap.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:Solon/api/api_connect.dart';

class ProposalPage extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final int uidUser;
  final String endTime;
  final int yesVotes;
  final int noVotes;
  final DateTime date;

  ProposalPage({
    Key key,
    this.pid,
    this.title,
    this.description,
    this.uidUser,
    this.endTime,
    this.yesVotes,
    this.noVotes,
    this.date,
  }) : super(key: key);

  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> with Screen {
  String _voteOutput;
  Future<Map<String, dynamic>> _listFutureProposal;

  Future<Map<String, dynamic>> getVote() async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = json.decode(prefs.getString('userData'))['uid'];
    final responseMessage = await APIConnect.connectVotes(
      'GET',
      pid: widget.pid,
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
      appBar: getPageAppBar(context),
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
                      widget.title,
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
                      widget.description,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                        "${AppLocalizations.of(context).translate('numDaysUntilVotingEnds')} ${widget.date.difference(DateTime.now()).inDays.toString()}"),
                  ),
                  snapshot.data['message'] == 'Error'
                      ? PreventDoubleTap(
                          body: <Map>[
                            {
                              'color': Colors.green,
                              'width': 155.0,
                              'height': 55.0,
                              'function': () async* {
                                yield true;
                                APIConnect.vote(widget.pid, 1);
                              },
                              'margin': const EdgeInsets.all(8),
                              'label':
                                  AppLocalizations.of(context).translate("yes"),
                            },
                            {
                              'color': Colors.red,
                              'width': 155.0,
                              'height': 55.0,
                              'function': () async* {
                                yield true;
                                APIConnect.vote(widget.pid, 0);
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
                      : getVoteBar(context, widget.yesVotes, widget.noVotes)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
