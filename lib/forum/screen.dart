import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:Solon/screen.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/forum/card.dart';
import 'package:Solon/forum/create.dart';
// import 'package:Solon/loader.dart';

class ForumScreen extends StatefulWidget {
  final int uid;
  ForumScreen({Key key, this.uid}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> with Screen {
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

  final translator = GoogleTranslator();

  Future<String> translateText(text, code) async {
    return await translator.translate(text, to: code);
  }

  Future<List<Map>> translateAll(String title, String description,
      List<Map> maps, Map<String, String> languages) async {
    for (var language in languages.keys) {
      maps[0][language] = await translateText(title, languages[language]);
      maps[1][language] = await translateText(description, languages[language]);
    }
    return maps;
  }

  PostCard buildPostCard(data) {
    return PostCard(
      key: UniqueKey(),
      title: data.title,
      description: data.description,
      uid: data.uid,
      fid: data.fid,
    );
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
                    children: snapshot.data,
                  ),
                  floatingActionButton:
                      getFAB(context, CreatePost(APIConnect.addForumPost)),
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
