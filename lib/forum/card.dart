import 'dart:convert';

import 'package:Solon/forum/page.dart';
import 'package:Solon/screen.dart';
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

class _PostCardState extends State<PostCard> with Screen {
  @override
  Widget build(BuildContext context) {
    Function function = () {
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
    };
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
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
              '${widget.description}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Text(widget.timestamp),
          Text('${widget.numcomments} comments'),
        ],
      ),
    );
    return getCard(context, tile, function);
  }
}
