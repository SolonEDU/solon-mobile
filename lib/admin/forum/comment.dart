import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String date;
  final String comment;

  Comment(this.date,this.comment); 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(comment),
      subtitle: Text(date),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
    );
  }
}