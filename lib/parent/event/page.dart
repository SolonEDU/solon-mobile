import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventPage extends StatelessWidget {
  final String title;
  final String description;
  final DateTime time;

  EventPage(
    this.title,
    this.description,
    this.time,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Text(description),
          Text(new DateFormat.yMMMMd("en_US").add_jm().format(time)),
        ],
      ),
    );
  }
}
