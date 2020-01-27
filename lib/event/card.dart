import 'dart:convert';

import 'package:Solon/event/page.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
// import 'package:Solon/app_localizations.dart';
// import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/loader.dart';

class EventCard extends StatefulWidget {
  final int eid;
  final int uid;
  final String title;
  final String description;
  final String date;
  // final doc;
  final bool attending;

  EventCard(
      {Key key,
      this.eid,
      this.uid,
      this.title,
      this.description,
      this.date,
      this.attending})
      : super(key: key);

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
    );
  }

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  // final db = Firestore.instance; // connect to PG, then decode
  // Future<bool> _futureAttendance;

  // Future<bool> getAttendance() async {
  //   final responseMessage = await APIConnect.getAttendance(
  //     eid: widget.eid,
  //     uid: widget.uid,
  //   );
  //   return responseMessage;
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //   _futureAttendance = getAttendance();
  }

  @override
  Widget build(BuildContext context) {
    // attending = false;
    // print(widget.attending);
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text(widget.title),
              subtitle: Text(
                  // widget.description + '\n' +
                  'Event Time: ' + widget.date),
              onTap: () {
                print("${widget.eid} ${widget.uid}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventPage(
                      eid: widget.eid,
                      uid: widget.uid,
                      title: widget.title,
                      description: widget.description,
                      date: widget.date,
                    ),
                  ),
                );
              },
            ),
            // ButtonBar(
            //   alignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     // FlatButton(
            //     //   child: Icon(Icons.delete),
            //     //   onPressed: () => { // send a DELETE request to PG, including the  in the request body to specify
            //     //     // db
            //     //     //     .collection('events')
            //     //     //     .document(widget.doc.documentID)
            //     //     //     .delete()
            //     //   },
            //     // ),
            //     Text(AppLocalizations.of(context).translate('attending')),
            //     FutureBuilder(
            //         future: _futureAttendance,
            //         builder:
            //             (BuildContext context, AsyncSnapshot<bool> snapshot) {
            //           if (snapshot.data == null) {
            //             return Center(
            //               child: Loader(),
            //             );
            //           }
            //           return Switch.adaptive(
            //             value: snapshot.data,
            //             onChanged: (value) {
            //               // setState(
            //               //   () => attending = value,
            //               // );
            //               // APIConnect.changeAttendance();
            //             },
            //             activeTrackColor: Colors.purpleAccent,
            //             activeColor: Colors.purple,
            //           );
            //         }),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
