import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './card.dart';
import './create.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final db = Firestore.instance;

  void _addEvent(
    title,
    description,
    date,
    time,
  ) {
    db.collection('events').add(
      {
        'eventTitle': title,
        'eventDescription': description,
        'eventDate': date.toString(),
        'eventTime': time.toString(),
      },
    );
  }

  EventCard buildEventCard(doc) {
    return EventCard(
      doc.data['eventTitle'],
      doc.data['eventDescription'],
      DateTime.parse(doc.data['eventDate']),
      TimeOfDay(hour: int.parse(doc.data['eventTime'].substring(10,12)), minute: int.parse(doc.data['eventTime'].substring(13,15))),
      doc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('events').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents
                      .map((doc) => buildEventCard(doc))
                      .toList(),
                );
              }
              return Container();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateEvent(_addEvent),
            ),
          );
        },
      ),
    );
  }
}
