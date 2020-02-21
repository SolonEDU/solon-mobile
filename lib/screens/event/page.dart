import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/services/event_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/bars/page_app_bar.dart';

class EventPage extends StatefulWidget {
  final Event event;

  EventPage({
    this.event,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool attendanceVal;
  StreamController<bool> streamController = StreamController();
  int userUid;

  void _onChanged(bool value) async {
    if (value) {
      EventConnect.changeAttendance('POST', eid: widget.event.eid, uid: userUid);
    } else {
      EventConnect.changeAttendance('DELETE', eid: widget.event.eid, uid: userUid);
    }
    streamController.sink.add(value);
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    userUid = json.decode(prefs.getString('userData'))['uid'];
    streamController
        .add(await EventConnect.getAttendance(eid: widget.event.eid, uid: userUid));
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
      appBar: PageAppBar(),
      body: Container(
        child: StreamBuilder<bool>(
          stream: streamController.stream,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
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
                    widget.event.title,
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
                    widget.event.description,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                  child: Text(widget.event.date),
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
