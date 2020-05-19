import 'dart:convert';

import 'package:Solon/models/model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Proposal extends Model<Proposal> {
  final int pid;
  final String title;
  final String description;
  final String endTime;
  final int uid;
  final int yesVotes;
  final int noVotes;
  final DateTime date;

  Proposal({
    this.pid,
    this.title,
    this.description,
    this.endTime,
    this.uid,
    this.yesVotes,
    this.noVotes,
    this.date,
  });

  factory Proposal.fromJson({
    @required Map<String, dynamic> map,
    @required String prefLangCode,
  }) {
    print("get proposal endtime string: ${map['endtime']}");
    DateTime endTime = DateTime.parse(map['endtime']);
    print(
        "get proposal utc endtime string: ${endTime.toLocal().difference(DateTime.now()).inHours}");
    print("${endTime.timeZoneOffset}");
    print("${endTime.toLocal().toIso8601String()}");
    // print("endtime: ${endTime.isUtc}");
    print("now: ${DateTime.now()}");
    String endTimeParsed = formatDate(
        endTime, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return Proposal(
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
}
