// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';
// import 'dart:convert'; // for jsonDecode

import './page.dart';
// import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  // final doc;

  EventCard({Key key, this.title, this.description, this.date})
      : super(key: key);

  factory EventCard.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['date']);
    String dateParsed = formatDate(date,
        [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    return EventCard(
      title: json['title'],
      description: json['description'],
      date: dateParsed,
    );
  }

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool attending = false;
  // final db = Firestore.instance; // connect to PG, then decode

  @override
  Widget build(BuildContext context) {
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
                  widget.date),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      widget.title,
                      widget.description,
                      widget.date,
                    ),
                  ),
                );
              },
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.delete),
                  onPressed: () => { // send a DELETE request to PG, including the  in the request body to specify
                    // db
                    //     .collection('events')
                    //     .document(widget.doc.documentID)
                    //     .delete()
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
                Text(AppLocalizations.of(context).translate('attending'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
