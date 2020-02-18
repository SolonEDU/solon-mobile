import 'dart:convert';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/event/page.dart';
import 'package:Solon/generated/i18n.dart';
import 'package:Solon/screen.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventCard extends StatefulWidget {
  final int eid;
  final String title;
  final String description;
  final String date;
  final bool attending;
  final int numattenders;

  EventCard({
    Key key,
    this.eid,
    this.title,
    this.description,
    this.date,
    this.attending,
    this.numattenders,
  }) : super(key: key);

  factory EventCard.fromJson(Map<String, dynamic> map, int creatorUid, String prefLangCode) {
    DateTime date = DateTime.parse(map['date']);
    String dateParsed = formatDate(
        date, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ' ', am]);
    String translatedTitle = json.decode(map['title'])[prefLangCode];
    String translatedDescription =
        json.decode(map['description'])[prefLangCode];
    return EventCard(
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
  Future<bool> getAttendanceVal() async {
    final prefs = await SharedPreferences.getInstance();
    final userUid = json.decode(prefs.getString('userData'))['uid'];
    final responseMessage = await APIConnect.getAttendance(
      eid: widget.eid,
      uid: userUid,
    );
    return responseMessage;
  }

  @override
  Widget build(BuildContext context) {
    Function function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventPage(
            eid: widget.eid,
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
          (widget.title.length > 40)
              ? '${widget.title.substring(0, 40)}...'
              : widget.title,
          style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
            I18n.of(context).numAttenders(widget.numattenders.toString()),
          ),
          FutureBuilder<bool>(
            future: getAttendanceVal(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == null) {
                return Center();
              } else {
                return Center(); //TODO: fill this in lata; for showing numvotes on cards on events screen
              }
            },
          ),
        ],
      ),
    );
    return getCard(context, tile, function);
  }
}
