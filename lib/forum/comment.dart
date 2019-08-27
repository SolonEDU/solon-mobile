//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './page.dart';

class CommentCard extends StatefulWidget {
  final String comment;
  final DateTime time;
  //DocumentSnapshot doc;
  CommentCard(this.comment, this.time);

  @override
  _CommentCardState createState() => _CommentCardState(comment, time,);
}

class _CommentCardState extends State<CommentCard> {
  final String comment;
  final DateTime time;
  //bool attending = false;
  //DocumentSnapshot doc;
  //final db = Firestore.instance;

  _CommentCardState(
    this.comment,
    this.time,
    //this.doc,
  );

  Widget build(BuildContext context) {
    return Card(
      child: Text(comment),
    );
  }

}
