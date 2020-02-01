import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

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
  final translator = GoogleTranslator();
  Stream<List<PostCard>> stream;

  @override
  void initState() {
    super.initState();

    stream = APIConnect.forumListView;
  }

  Future<void> getStream() async {
    setState(() {
      stream = APIConnect.forumListView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: getStream,
      child: StreamBuilder<List<PostCard>>(
        stream: APIConnect.forumListView,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              break;
            case ConnectionState.waiting:
              break;
            case ConnectionState.active:
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Scaffold(
                  body: ListView(
                    padding: const EdgeInsets.all(8),
                    children: snapshot.data,
                  ),
                  floatingActionButton: getFAB(
                    context,
                    CreatePost(APIConnect.addForumPost),
                    getStream,
                  ),
                );
              }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
