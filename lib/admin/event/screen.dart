import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './card.dart';
import './create.dart';
import '../../loader.dart';

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
      TimeOfDay(
          hour: int.parse(doc.data['eventTime'].substring(10, 12)),
          minute: int.parse(doc.data['eventTime'].substring(13, 15))),
      doc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('events')
          .orderBy('eventDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          default:
            return Scaffold(
              body: Center(
                child: ListView(
                  padding: EdgeInsets.all(8),
                  children: <Widget>[
                    Column(
                      children: snapshot.data.documents
                          .map((doc) => buildEventCard(doc))
                          .toList(),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(_addEvent)),
                  )
                },
              ),
            );
        }
      },
    );
  }
}
