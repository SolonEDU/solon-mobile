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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: dropdownMenuStreamController.stream,
        builder: (context, optionVal) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: APIConnect.connectForumPosts,
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
                          if (prefs.get('forumSortOption') != newValue) {
                            dropdownMenuStreamController.sink.add(newValue);
                            prefs.setString(
                              'forumSortOption',
                              newValue,
                            );
                          }
                        },
                        items: <String>[
                          'Newly created',
                          'Oldest created',
                          'Comments: Greatest to Least',
                          'Comments: Least to Greatest',
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
                  child: StreamBuilder<List<PostCard>>(
                    stream: Function.apply(
                      APIConnect.forumListView,
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
          );
        });
  }
}
