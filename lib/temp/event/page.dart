import 'dart:convert';

import 'package:Solon/app_localizations.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Solon/api/api_connect.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventPage extends StatefulWidget {
  final int eid;
  final String title;
  final String description;
  final String date;
  final int numattenders;

  EventPage({
    this.eid,
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
  int userUid;

  void _onChanged(bool value) async {
    if (value) {
      APIConnect.changeAttendance('POST', eid: widget.eid, uid: userUid);
    } else {
      APIConnect.changeAttendance('DELETE', eid: widget.eid, uid: userUid);
    }
    streamController.sink.add(value);
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    userUid = json.decode(prefs.getString('userData'))['uid'];
    streamController
        .add(await APIConnect.getAttendance(eid: widget.eid, uid: userUid));
  }

  @override
  void initState() {
    load();
    super.initState();
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
                    AppLocalizations.of(context).translate("description"),
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
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                      child: Text(
                          AppLocalizations.of(context).translate("attending")),
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
