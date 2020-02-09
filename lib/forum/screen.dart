import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/forum/card.dart';
import 'package:Solon/forum/create.dart';

class ForumScreen extends StatefulWidget {
  final int uid;
  ForumScreen({Key key, this.uid}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> with Screen {
  Stream<List<PostCard>> stream;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  StreamController forumPostListStreamController = StreamController.broadcast();
  StreamController dropdownMenuStreamController = StreamController.broadcast();

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final forumSortOption = prefs.getString('forumSortOption');
    dropdownMenuStreamController.sink.add(forumSortOption);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    forumPostListStreamController.close();
    dropdownMenuStreamController.close();
    super.dispose();
  }

  // Future<void> getStream(String query) async {
  //   forumPostListStreamController.sink.add(await APIConnect.connectProposals(
  //     query: query,
  //   ));
  // }

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
                onRefresh: APIConnect.connectForumPosts,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
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
                                      icon: Icon(Icons.arrow_downward),
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
                                        final prefs =
                                            await SharedPreferences.getInstance();
                                        prefs.setString(
                                          'forumSortOption',
                                          newValue,
                                        );
                                      },
                                      items: <String>[
                                        'Newly created',
                                        'Oldest created',
                                        'Most comments',
                                        'Least comments',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.search),
                            color: Colors.pinkAccent[400],
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: ForumSearch(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<PostCard>>(
                        stream: Function.apply(
                          APIConnect.forumListView,
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
                                    CreatePost(APIConnect.addForumPost),
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
class ForumSearch extends SearchDelegate {
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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text(query);
  }

  @override
  String get searchFieldLabel => 'Search forum';
}
