import 'package:Solon/generated/i18n.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:intl/intl.dart';

import 'package:Solon/app_localizations.dart';
import 'package:Solon/api/api_connect.dart';
// import 'package:Solon/loader.dart';

class EventPage extends StatefulWidget {
  final int eid;
  final int uid;
  final String title;
  final String description;
  final String date;
  final int numattenders;

  EventPage({
    this.eid,
    this.uid,
    this.title,
    this.description,
    this.date,
    this.numattenders,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with Screen {
  bool attendanceVal;
  StreamController streamController = StreamController();

  void _onChanged(bool value) async {
    if (value) {
      APIConnect.changeAttendance('POST', eid: widget.eid, uid: widget.uid);
    } else {
      APIConnect.changeAttendance('DELETE', eid: widget.eid, uid: widget.uid);
    }
    streamController.sink.add(value);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  void load() async {
    streamController
        .add(await APIConnect.getAttendance(eid: widget.eid, uid: widget.uid));
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getPageAppBar(context),
      body: Container(
        child: StreamBuilder(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            attendanceVal = snapshot.data;
            return ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 8, top: 8),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      fontFamily: "Raleway",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 8, top: 8),
                  child: Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Text(widget.date),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Text(I18n.of(context).attending),
                    ),
                    Switch.adaptive(
                      value: attendanceVal,
                      onChanged: _onChanged,
                      activeTrackColor: Colors.purpleAccent,
                      activeColor: Colors.purple,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
