//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './page.dart';

class CommentCard extends StatefulWidget {
  final String description;
  final String time;
  //DocumentSnapshot doc;
  CommentCard(this.description, this.time);

  @override
  _CommentCardState createState() => _CommentCardState(description, time,);
}

class _CommentCardState extends State<CommentCard> {
  final String description;
  final String time;
  //bool attending = false;
  //DocumentSnapshot doc;
  //final db = Firestore.instance;

  _CommentCardState(
    this.description,
    this.time,
    //this.doc,
  );

  Widget build(BuildContext context) {
    return Card();
  }

}
