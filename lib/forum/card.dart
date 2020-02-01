import 'dart:convert';

import 'package:Solon/forum/page.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final int fid;
  final String title;
  final String description;
  final int uid;
  final String timestamp;
  final int numcomments;

  PostCard({
    Key key,
    this.fid,
    this.title,
    this.description,
    this.uid,
    this.timestamp,
    this.numcomments,
  }) : super(key: key);

  factory PostCard.fromJson(Map<String, dynamic> map, String prefLangCode) {
    DateTime timestamp = DateTime.parse(map['timestamp']);
    String timestampParsed = formatDate(timestamp,
        [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return PostCard(
      fid: map['fid'],
      title: translatedTitle,
      description: translatedDescription,
      timestamp: timestampParsed,
      uid: map['uid'],
      numcomments: map['numcomments'],
    );
  }

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.title),
              subtitle: Text(widget.timestamp),
              // subtitle: Text(widget.description +
              //     "\n" +
              //     new DateFormat.yMMMMd("en_US").add_jm().format(widget.time)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      fid: widget.fid,
                      title: widget.title,
                      description: widget.description,
                      uid: widget.uid,
                      timestamp: widget.timestamp,
                      numcomments: widget.numcomments,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
