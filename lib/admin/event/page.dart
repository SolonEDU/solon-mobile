import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;

  EventPage(
    this.title,
    this.description,
    this.date,
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
          Text('Event will occur on ' + date.toString().substring(0,10) + ' at ' + time.toString().substring(10,15)),
        ],
      ),
    );
  }
}
