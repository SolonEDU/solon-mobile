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

  Future<void> getStream() async {
    setState(() {
      stream = APIConnect.forumListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: getStream,
      child: StreamBuilder<List<PostCard>>(
        stream: APIConnect.forumListView,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            default:
              return Scaffold(
                body: ListView(
                  padding: const EdgeInsets.all(4),
                  children: snapshot.data,
                ),
                floatingActionButton: getFAB(
                  context,
                  CreatePost(APIConnect.addForumPost),
                ),
              );
          }
        },
      ),
    );
  }
}