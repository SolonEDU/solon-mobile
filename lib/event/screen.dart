import 'package:flutter/material.dart';

import './card.dart';
import './create.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Widget> _eventsList = [];

  void _addEvent(title,description) {
    setState(() {
     _eventsList.add(Event(title,description));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _eventsList.length,
        itemBuilder: (BuildContext context, int index) {
          return _eventsList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateEventPage(_addEvent)));
        }
      ),
    );
  }
}
