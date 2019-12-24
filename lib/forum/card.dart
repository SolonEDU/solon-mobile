// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:convert'; // for jsonDecode

import './page.dart';
// import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final int fid;
  final String title;
  final String description;
  final int uid;
  final String timestamp;

  PostCard({
    Key key,
    this.fid,
    this.title,
    this.description,
    this.uid,
    this.timestamp,
  }) : super(key: key);

  factory PostCard.fromJson(Map<String, dynamic> json) {
    return PostCard(
      fid: json['fid'],
      title: json['title'],
      description: json['description'],
      timestamp: json['timestamp'],
      uid: json['uid'],
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
