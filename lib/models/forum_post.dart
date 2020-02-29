import 'dart:convert';

import 'package:Solon/models/model.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class ForumPost extends Model {
  final int fid;
  final String title;
  final String description;
  final int uid;
  final String timestamp;
  final int numcomments;

  ForumPost({
    this.fid,
    this.title,
    this.description,
    this.uid,
    this.timestamp,
    this.numcomments,
  });

  factory ForumPost.fromJson({
    @required Map<String, dynamic> map,
    @required String prefLangCode,
  }) {
    DateTime timestamp = DateTime.parse(map['timestamp']);
    String timestampParsed = formatDate(
        timestamp, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return ForumPost(
      fid: map['fid'],
      title: translatedTitle,
      description: translatedDescription,
      timestamp: timestampParsed,
      uid: map['uid'],
      numcomments: map['numcomments'],
    );
  }
}
