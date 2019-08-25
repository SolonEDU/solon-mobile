import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Column(
        children: <Widget>[
          Text('this is the second page'),
        ],
      ),
    );
  }
}
