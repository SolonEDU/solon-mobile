import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/loader.dart';

class EventPage extends StatefulWidget {
  final int eid;
  final int uid;
  final String title;
  final String description;
  final String date;

  EventPage({
    this.eid,
    this.uid,
    this.title,
    this.description,
    this.date,
  });

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Future<bool> _futureAttendanceVal;
  bool _attendanceVal = false;

  void _onChanged(bool value) => setState(() => _attendanceVal = value);

  // Future<Map<String, dynamic>> getAttendance() async {
  //   final responseMessage = await APIConnect.getAttendance(
  //     'GET',
  //     pid: widget.pid,
  //     uidUser: widget.uidUser,
  //   );
  //   return responseMessage;
  // }

  @override
  void initState() {
    super.initState();

    _futureAttendanceVal =
        APIConnect.getAttendance(eid: widget.eid, uid: widget.uid);
    // print(_futureAttendanceVal.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _futureAttendanceVal,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Loader(),
              );
            }
            _attendanceVal = snapshot.data;
            return Column(
              children: <Widget>[
                Text(widget.description),
                Text(widget.date),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // FlatButton(
                    //   child: Icon(Icons.delete),
                    //   onPressed: () => { // send a DELETE request to PG, including the  in the request body to specify
                    //     // db
                    //     //     .collection('events')
                    //     //     .document(widget.doc.documentID)
                    //     //     .delete()
                    //   },
                    // ),
                    Text(AppLocalizations.of(context).translate('attending')),
                    Switch.adaptive(
                      value: _attendanceVal,
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
