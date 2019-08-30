import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Comment extends StatelessWidget {
  final DateTime date;
  final String comment;

  Comment(this.date,this.comment); 

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
       leading: Icon(Icons.account_circle),
       title: Container(
          child: Text(comment),
          margin: EdgeInsets.only(top: 8.0, bottom: 4.0)
         ),
       subtitle: Container(
          child: Text(new DateFormat.yMMMMd("en_US").add_jm().format(date)),
          margin: EdgeInsets.only(bottom: 8.0)
         ),
       contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      margin: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0)
    );
  }
}