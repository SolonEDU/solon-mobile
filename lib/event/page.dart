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
            return Column(
              children: <Widget>[
                Text(widget.description),
                Text(widget.date),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(AppLocalizations.of(context).translate('attending')),
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
