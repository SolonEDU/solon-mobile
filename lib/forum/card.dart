import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'dart:convert'; // for jsonDecode

import './page.dart';
import 'package:intl/intl.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String description;
  final DateTime time;
  final DocumentSnapshot doc;

  PostCard(
    this.title,
    this.description,
    this.time,
    this.doc);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  // final db = Firestore.instance; // db is not used anywhere and idk if this is even needed here

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(widget.title),
              subtitle: Text(widget.description + "\n" + new DateFormat.yMMMMd("en_US").add_jm().format(widget.time)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      widget.title,
                      widget.description,
                      widget.time,
                      widget.doc,
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
