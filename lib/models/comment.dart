import 'dart:convert';

import 'package:Solon/models/model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class Comment extends Model<Comment> {
  final String date;
  final String comment;

  Comment({this.date, this.comment});

  factory Comment.fromJson({
    @required Map<String, dynamic> map,
    @required String prefLangCode,
  }) {
    DateTime timestamp = DateTime.parse(map['timestamp']);
    String timestampParsed = formatDate(
        timestamp, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedComment = json.decode(map['content'])[prefLangCode];
    return Comment(
      date: timestampParsed,
      comment: translatedComment,
    );
  }
}
