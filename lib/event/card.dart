import 'dart:convert';

import 'package:Solon/event/page.dart';
import 'package:Solon/screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
// import 'package:Solon/app_localizations.dart';

class EventCard extends StatefulWidget {
  final int eid;
  final int uid;
  final String title;
  final String description;
  final String date;
  final bool attending;
  final int numattenders;

  EventCard({
    Key key,
    this.eid,
    this.uid,
    this.title,
    this.description,
    this.date,
    this.attending,
    this.numattenders,
  }) : super(key: key);

  factory EventCard.fromJson(
      Map<String, dynamic> map, int uid, String prefLangCode) {
    DateTime date = DateTime.parse(map['date']);
    String dateParsed = formatDate(
        date, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return EventCard(
      uid: uid,
      eid: map['eid'],
      title: translatedTitle,
      description: translatedDescription,
      date: dateParsed,
      numattenders: map['numattenders'],
    );
  }

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with Screen {
  @override
  Widget build(BuildContext context) {
    Function function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventPage(
            eid: widget.eid,
            uid: widget.uid,
            title: widget.title,
            description: widget.description,
            date: widget.date,
            numattenders: widget.numattenders,
          ),
        ),
      );
    };
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              '${widget.date}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            '${widget.numattenders} attenders',
          ),
        ],
      ),
    );
    return getCard(context, tile, function);
  }
}
