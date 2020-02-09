import 'dart:async';

import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/api/api_connect.dart';
import 'package:Solon/event/card.dart';
// import 'package:Solon/loader.dart';

class EventsScreen extends StatefulWidget {
  final int uid;
  EventsScreen({Key key, this.uid}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with Screen {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController eventListStreamController = StreamController.broadcast();
  StreamController dropdownMenuStreamController = StreamController.broadcast();

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsSortOption = prefs.getString('eventsSortOption');
    dropdownMenuStreamController.sink.add(eventsSortOption);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    eventListStreamController.close();
    dropdownMenuStreamController.close();
    super.dispose();
  }

  Future<void> getStream(String query) async {
    eventListStreamController.sink
        .add(await APIConnect.connectEvents(uid: widget.uid, query: query));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dropdownMenuStreamController.stream,
        builder: (context, optionVal) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: () => APIConnect.connectEvents(
              uid: widget.uid,
              query: optionVal.data,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: optionVal.data,
                        icon: Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 8,
                        style: TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: Colors.pink[400],
                        ),
                        onChanged: (String newValue) async {
                          dropdownMenuStreamController.sink.add(newValue);
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setString(
                            'eventsSortOption',
                            newValue,
                          );
                        },
                        items: <String>[
                          'Newly created',
                          'Oldest created',
                          'Attendees: High to Low',
                          'Attendees: Low to High',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Function.apply(
                      APIConnect.eventListView,
                      [
                        widget.uid,
                        optionVal.data,
                      ],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Scaffold(
                              body: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        default:
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Scaffold(
                              key: _scaffoldKey,
                              body: ListView(
                                padding: const EdgeInsets.all(4),
                                children: snapshot.data,
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}
