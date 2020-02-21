import 'package:Solon/api/api_connect.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:Solon/proposal/page.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProposalCard extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final String endTime;
  final int uid;
  final int yesVotes;
  final int noVotes;
  final DateTime date;

  ProposalCard({
    Key key,
    this.pid,
    this.title,
    this.description,
    this.endTime,
    this.uid,
    this.yesVotes,
    this.noVotes,
    this.date,
  }) : super(key: key);

  factory ProposalCard.fromJson(Map<String, dynamic> map, String prefLangCode) {
    DateTime endTime = DateTime.parse(map['endtime']);
    String endTimeParsed = formatDate(
        endTime, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return ProposalCard(
      pid: map['pid'],
      title: translatedTitle,
      description: translatedDescription,
      endTime: endTimeParsed,
      uid: map['uid'],
      yesVotes: map['numyes'],
      noVotes: map['numno'],
      date: endTime,
    );
  }

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> with Screen {
  bool _voted;
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
            pid: widget.pid,
            title: widget.title,
            description: widget.description,
            uidUser: widget.uid,
            endTime: widget.endTime,
            date: widget.date,
            yesVotes: widget.yesVotes,
            noVotes: widget.noVotes,
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
        child: Text(
          (widget.title.length > 40)
              ? '${widget.title.substring(0, 40)}...'
              : widget.title,
          style: TextStyle(
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
            child: Text(
              "${AppLocalizations.of(context).translate("numDaysUntilVotingEnds")} ${widget.date.difference(DateTime.now()).inDays.toString()}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "${widget.yesVotes + widget.noVotes} ${AppLocalizations.of(context).translate("votes")}",
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
                  return getVoteBar(
                    context,
                    widget.yesVotes,
                    widget.noVotes,
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
    return getCard(context, tile, function);
  }
}
