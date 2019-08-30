import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './page.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final DocumentSnapshot doc;
  EventCard(this.title, this.description, this.date, this.time, this.doc);

  @override
  _EventCardState createState() => _EventCardState(
        title,
        description,
        date,
        time,
        doc,
      );
}

class _EventCardState extends State<EventCard> {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  bool attending = false;
  DocumentSnapshot doc;
  final db = Firestore.instance;

  _EventCardState(
    this.title,
    this.description,
    this.date,
    this.time,
    this.doc,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(title),
              subtitle: Text(description + '\n' + 'Event will occur on '  + date.toString().substring(0,10) + ' at ' + time.toString().substring(10,15)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      title,
                      description,
                      date,
                      time,
                    ),
                  ),
                );
              },
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: Icon(Icons.delete),
                    onPressed: () async => {
                      await db
                          .collection('events')
                          .document(doc.documentID)
                          .delete()
                    },
                  ),
                  Switch.adaptive(
                    value: attending,
                    onChanged: (value) {
                      setState(
                        () => attending = value,
                      );
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  Text('Attending?')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}