import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './page.dart';
import 'package:intl/intl.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final doc;

  EventCard(
      {Key key, this.title, this.description, this.date, this.time, this.doc})
      : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool attending = false;
  var collection;
  final db = Firestore.instance;

  void getCollection() {
    setState(() {
      collection = db.collection('proposals');
    });
  }

  @override
  Widget build(BuildContext context) {
    getCollection();

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(widget.title),
              subtitle: Text(widget.description +
                  '\n' +
                  'Event Time: ' +
                  DateFormat.yMMMMd("en_US").add_jm().format(widget.date)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      widget.title,
                      widget.description,
                      widget.date,
                      widget.time,
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
                    onPressed: () =>
                        {collection.document(widget.doc.documentID).delete()},
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
