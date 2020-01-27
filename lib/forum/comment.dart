import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String date;
  final String comment;

  Comment({this.date, this.comment});

  factory Comment.fromJson(Map<String, dynamic> map, String prefLangCode) {
    DateTime timestamp = DateTime.parse(map['timestamp']);
    String timestampParsed = formatDate(timestamp,
        [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    String translatedComment = json.decode(map['comment'])[prefLangCode];
    return Comment(
      date: timestampParsed,
      comment: translatedComment,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          leading: Icon(Icons.account_circle),
          title: Container(
              child: Text(comment),
              margin: EdgeInsets.only(top: 8.0, bottom: 4.0)),
          subtitle: Container(
              child: Text(date), margin: EdgeInsets.only(bottom: 8.0)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0));
  }
}
