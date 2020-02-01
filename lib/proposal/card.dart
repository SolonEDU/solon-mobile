import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

import 'package:Solon/proposal/page.dart';
import 'dart:convert';

class ProposalCard extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final String endTime;
  final int uid;
  final int totalVotes;
  final DateTime date;

  ProposalCard({
    Key key,
    this.pid,
    this.title,
    this.description,
    this.endTime,
    this.uid,
    this.totalVotes,
    this.date,
  }) : super(key: key);

  factory ProposalCard.fromJson(Map<String, dynamic> map, String prefLangCode) {
    DateTime endTime = DateTime.parse(map['endtime']);
    String endTimeParsed = formatDate(
        endTime, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return ProposalCard(
      pid: map['pid'],
      title: translatedTitle,
      description: translatedDescription,
      endTime: endTimeParsed,
      uid: map['uid'],
      totalVotes: map['numyes'] + map['numno'],
      date: endTime,
    );
  }

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> with Screen {
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
          widget.title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
                'Ends in ${widget.date.difference(DateTime.now()).inDays} days'),
          ),
          Text(
            '${widget.totalVotes} votes',
          )
        ],
      ),
    );
    return getCard(context, tile, function);
  }
}
