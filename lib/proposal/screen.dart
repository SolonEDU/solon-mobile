import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/proposal/card.dart';
import 'package:Solon/proposal/create.dart';

class ProposalsScreen extends StatefulWidget {
  final int uid;
  ProposalsScreen({Key key, this.uid}) : super(key: key);

  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> with Screen {
  final translator = GoogleTranslator();
  Stream<List<ProposalCard>> stream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController proposalListStreamController = StreamController.broadcast();
  StreamController dropdownMenuStreamController = StreamController.broadcast();
  String _sortOption;

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsSortOption = prefs.getString('proposalsSortOption');
    dropdownMenuStreamController.sink.add(proposalsSortOption);
    print(proposalsSortOption + " sharedPrefs");
    // setState(() {
    //   _sortOption = prefs.getString('proposalsSortOption');
    //   print(_sortOption + " setState");
    // });
  }

  @override
  void initState() {
    load();
    super.initState();
    print(_sortOption);
  }

  Future<void> getStream(String query) async {
    proposalListStreamController.sink
        .add(await APIConnect.connectProposals(query: query));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dropdownMenuStreamController.stream,
        builder: (context, optionVal) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: APIConnect.connectProposals,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Sort by: "),
                    DropdownButton<String>(
                      value: optionVal.data,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.pink[400],
                      ),
                      onChanged: (String newValue) async {
                        dropdownMenuStreamController.sink.add(newValue);
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString(
                          'proposalsSortOption',
                          newValue,
                        );
                      },
                      items: <String>[
                        'Most votes',
                        'Least votes',
                        'Newly created',
                        'Oldest created',
                        'Upcoming deadlines',
                        'Oldest deadlines',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: Function.apply(
                        APIConnect.proposalListView, [optionVal.data]),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) return Text("${snapshot.error}");
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          print(snapshot.data);
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
                              floatingActionButton: getFAB(
                                context,
                                CreateProposal(APIConnect.addProposal),
                                getStream,
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
