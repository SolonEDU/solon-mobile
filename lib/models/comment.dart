import 'dart:convert';

import 'package:date_format/date_format.dart';

class Comment {
  final String date;
  final String comment;

  Comment({this.date, this.comment});

  factory Comment.fromJson({Map<String, dynamic> map, String prefLangCode}) {
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
