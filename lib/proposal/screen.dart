import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/proposal/create.dart';

class ProposalsScreen extends StatefulWidget {
  final int uid;
  ProposalsScreen({Key key, this.uid}) : super(key: key);

  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> with Screen {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController proposalListStreamController = StreamController.broadcast();
  StreamController dropdownMenuStreamController = StreamController.broadcast();

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsSortOption = prefs.getString('proposalsSortOption');
    dropdownMenuStreamController.sink.add(proposalsSortOption);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    proposalListStreamController.close();
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
            return RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: APIConnect.connectProposals,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Sort by: "),
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
                            final prefs = await SharedPreferences.getInstance();
                            if (prefs.get('proposalsSortOption') != newValue) {
                              dropdownMenuStreamController.sink.add(newValue);
                              prefs.setString(
                                'proposalsSortOption',
                                newValue,
                              );
                            }
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
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: Function.apply(
                        APIConnect.proposalListView,
                        [
                          optionVal.data,
                        ],
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) return Text("${snapshot.error}");
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
                                floatingActionButton: getFAB(
                                  context,
                                  CreateProposal(APIConnect.addProposal),
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
        }
      },
    );
  }
}
