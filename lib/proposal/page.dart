import 'package:Solon/auth/button.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/app_localizations.dart';
// import 'package:Solon/loader.dart';

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
    // print('HELLO $userUid $responseMessage');
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
                    ? "You have voted Yea!"
                    : "You have voted Nay!";
              }
              return ListView(
                children: <Widget>[
                  Text(widget.title),
                  Text(widget.description),
                  Text('Voting on proposal ends ' + widget.endTime),
                  snapshot.data['message'] == 'Error'
                      ? PreventDoubleTap(
                          pid: widget.pid,
                          uidUser: widget.uidUser,
                          voted: snapshot.data['message'] == 'Error'
                              ? false
                              : true,
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

class PreventDoubleTap extends StatefulWidget {
  final int pid;
  final int uidUser;
  final bool voted;

  PreventDoubleTap({
    Key key,
    this.pid,
    this.uidUser,
    this.voted,
  }) : super(key: key);

  @override
  PreventDoubleTapState createState() {
    return new PreventDoubleTapState();
  }
}

class PreventDoubleTapState extends State<PreventDoubleTap> {
  //boolean value to determine whether button is tapped
  bool _isButtonTapped = false;

  Future<void> vote(int pid, int voteVal) async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = json.decode(prefs.getString('userData'))['uid'];
    APIConnect.connectVotes('POST',
        pid: pid, uidUser: userUid, voteVal: voteVal);
  }

  _onYeaTapped() async {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    // print('is button tapped? yea $_isButtonTapped');
    vote(widget.pid, 1);
  }

  _onNayTapped() async {
    setState(() => _isButtonTapped =
        !_isButtonTapped); //tapping the button once, disables the button from being tapped again
    // print('is button tapped? nay $_isButtonTapped');
    vote(widget.pid, 0);
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        Button(
          color: Colors.green,
          function: _isButtonTapped ? null : _onYeaTapped,
          label: 'Yes',
          margin: const EdgeInsets.all(8),
          width: 155,
          height: 55,
        ),
        Button(
          color: Colors.red,
          function: _isButtonTapped ? null : _onNayTapped,
          label: 'No',
          margin: const EdgeInsets.all(8),
          width: 155,
          height: 55,
        ),
      ],
    );
  }
}
