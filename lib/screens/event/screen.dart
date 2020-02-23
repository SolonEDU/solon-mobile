import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/screens/event/card.dart';
import 'package:Solon/screens/event/search.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/event_util.dart';
import 'package:Solon/widgets/buttons/search_button.dart';
import 'package:Solon/widgets/sort_dropdown_menu.dart';

class EventsScreen extends StatefulWidget {
  EventsScreen({Key key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController<String> dropdownMenuStreamController =
      StreamController.broadcast();
  Stream<List<Event>> stream;
  int userUid;

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsSortOption = prefs.getString('eventsSortOption');
    dropdownMenuStreamController.sink.add(eventsSortOption);
    stream = EventUtil.screenView(eventsSortOption);
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
    return StreamBuilder<String>(
      stream: dropdownMenuStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<String> optionVal) {
        switch (optionVal.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
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
                          Flexible(
                            flex: 9,
                            child: SortDropdownMenu(
                              preferences: 'eventsSortOption',
                              streamController: dropdownMenuStreamController,
                              value: optionVal.data,
                              items: <String>[
                                'Furthest',
                                'Upcoming',
                                'Most attendees',
                                'Least attendees',
                              ].map<DropdownMenuItem<String>>((String value) {
                                Map<String, String> itemsMap = {
                                  'Furthest': AppLocalizations.of(context)
                                      .translate("furthest"),
                                  'Upcoming': AppLocalizations.of(context)
                                      .translate("upcoming"),
                                  'Most attendees': AppLocalizations.of(context)
                                      .translate("mostAttendees"),
                                  'Least attendees':
                                      AppLocalizations.of(context)
                                          .translate("leastAttendees"),
                                };
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    itemsMap[value],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SearchButton(
                              delegate: EventsSearch(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Event>>(
                        stream: Function.apply(
                            EventUtil.screenView, [optionVal.data]),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Event>> snapshot) {
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Scaffold(
                                  key: _scaffoldKey,
                                  body: ListView(
                                    padding: const EdgeInsets.all(4),
                                    children: snapshot.data
                                        .map((json) => EventCard(event: json))
                                        .toList(),
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
