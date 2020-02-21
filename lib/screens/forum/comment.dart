import 'dart:convert';
import 'package:Solon/util/screen.dart';
import 'package:Solon/widgets/screen_card.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Comment extends StatelessWidget with Screen {
  final String date;
  final String comment;

  Comment({this.date, this.comment});

  factory Comment.fromJson(Map<String, dynamic> map, String prefLangCode) {
    DateTime timestamp = DateTime.parse(map['timestamp']);
    String timestampParsed = formatDate(
        timestamp, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedComment = json.decode(map['content'])[prefLangCode];
    return Comment(
      date: timestampParsed,
      comment: translatedComment,
    );
  }

  @override
  Widget build(BuildContext context) {
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 5,
        bottom: 5,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(comment),
      ),
      subtitle: Container(
        child: Text(date),
        margin: EdgeInsets.only(bottom: 4),
      ),
    );

    return ScreenCard(tile: tile, function: () {});
  }
}
