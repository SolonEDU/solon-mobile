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

  StreamController dropdownMenuStreamController = StreamController.broadcast();
  Stream<List<EventCard>> stream;

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsSortOption = prefs.getString('eventsSortOption');
    dropdownMenuStreamController.sink.add(eventsSortOption);
    stream = APIConnect.eventListView(widget.uid, eventsSortOption);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    dropdownMenuStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dropdownMenuStreamController.stream,
      builder: (context, optionVal) {
        switch (optionVal.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              //TODO: can be abstracted
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          default:
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: load,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                        bottom: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text("Sort by: "),
                              Container(
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: optionVal.data,
                                      // icon: Icon(Icons.arrow_downward),
                                      iconSize: 24,
                                      elevation: 8,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.pink[400],
                                      ),
                                      onChanged: (String newValue) async {
                                        dropdownMenuStreamController.sink
                                            .add(newValue);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setString(
                                          'eventsSortOption',
                                          newValue,
                                        );
                                      },
                                      items: <String>[
                                        'Furthest',
                                        'Upcoming',
                                        'Most attendees',
                                        'Least attendees',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            // textAlign: TextAlign.left,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: EventsSearch(),
                                );
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.pink[400],
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              // padding: const EdgeInsets.all(15.0),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                          ),
                          // IconButton(
                          //   icon: Icon(Icons.search),
                          //   color: Colors.pinkAccent[400],
                          //   highlightColor: Colors.transparent,
                          //   splashColor: Colors.transparent,
                          //   onPressed: () {
                          //     showSearch(
                          //       context: context,
                          //       delegate: EventsSearch(),
                          //     );
                          //   },
                          // ),
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
              ),
            );
        }
      },
    );
  }
}

// TODO: move to another file after we're done experimenting
class EventsSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') return Container();
    return StreamBuilder(
      stream: Function.apply(
        APIConnect.eventSearchListView,
        [
          query,
        ],
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              children: snapshot.data,
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel => 'Search events';
}
