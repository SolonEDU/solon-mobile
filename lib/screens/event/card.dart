import 'dart:convert';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/screens/event/page.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/widgets/screen_card.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/services/event_connect.dart';
import 'package:Solon/widgets/text_layout.dart';

class EventCard extends StatefulWidget {
  final Event event;

  EventCard({Key key, this.event}) : super(key: key);

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  Future<bool> getAttendanceVal() async {
    final sharedPrefs = await UserUtil.connectSharedPreferences(key: 'userData');
    final userUid = sharedPrefs['uid'];
    final responseMessage = await EventConnect.getAttendance(
      eid: widget.event.eid,
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
            event: widget.event,
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
        child: TextLayout.fillLinesWithTextAndAppendTrail(
          rawText: widget.event.title,
          trail: '...',
          textStyle: TextStyle(
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
              '${widget.event.date}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            "${widget.event.numattenders} ${AppLocalizations.of(context).translate("attenders")}",
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
    return ScreenCard(tile: tile, function: function);
  }
}
