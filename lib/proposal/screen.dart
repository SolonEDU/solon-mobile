import 'dart:async';

import 'package:Solon/proposal/card.dart';
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

  StreamController dropdownMenuStreamController = StreamController.broadcast();
  Stream<List<ProposalCard>> stream;
  TextEditingController editingController = TextEditingController();

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsSortOption = prefs.getString('proposalsSortOption');
    dropdownMenuStreamController.sink.add(proposalsSortOption);
    stream = APIConnect.proposalListView(proposalsSortOption);
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
                                  // TODO: is this Container() needed here ?
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
                                    delegate: ProposalsSearch(),
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
                            //       delegate: ProposalsSearch(),
                            //     );
                            //   },
                            // ),
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
                            if (snapshot.hasError)
                              return Text("${snapshot.error}");
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
                ),
              );
          }
        });
  }
}

// TODO: move to another file after we're done experimenting
class ProposalsSearch extends SearchDelegate {
  StreamController streamController = StreamController();
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
        APIConnect.proposalSearchListView,
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
    // StreamBuilder(
    //   stream: Function.apply(
    //     APIConnect.proposalSearchListView,
    //     [
    //       query,
    //     ],
    //   ),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Center();
    //       default:
    //         if (query == '') {
    //           return Center();
    //         } else if (snapshot.hasError) {
    //           return Center();
    //         }
    //         return ListView(
    //           children: snapshot.data,
    //         );
    //     }
    //   },
    // );
  }

  @override
  String get searchFieldLabel => 'Search proposals';
}
