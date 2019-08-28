import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_local.dart';

class Comment extends StatelessWidget {
  final DateTime date;
  final String comment;

  Comment(this.date,this.comment); 

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(comment),
      subtitle: Text(new DateFormat.yMMMMd("en_US").add_jm().format(date)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 32),
    );
  }
}