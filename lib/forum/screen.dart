import 'package:Solon/api/api_connect.dart';
import 'package:Solon/api/forumpost.dart';
import 'package:Solon/forum/card.dart';
// import 'package:Solon/forum/create.dart';
import 'package:Solon/loader.dart';
import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
// import 'package:firebase_auth/firebase_auth.dart';

class ForumScreen extends StatefulWidget {
  final int uid;
  ForumScreen({Key key, this.uid}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // final db = Firestore.instance;
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

  // void _addPost(
  //   String title,
  //   String description,
  // ) async {
  //   Map<String, String> languages = {
  //     'English': 'en',
  //     'Chinese (Simplified)': 'zh-cn',
  //     'Chinese (Traditional)': 'zh-tw',
  //     'Bengali': 'bn',
  //     'Korean': 'ko',
  //     'Russian': 'ru',
  //     'Japanese': 'ja',
  //     'Ukrainian': 'uk'
  //   };
  //   Map<String, String> translatedTitles = {};
  //   Map<String, String> translatedDescriptions = {};
  //   List<Map> translated = [translatedTitles, translatedDescriptions];
  //   translated = await translateAll(title, description, translated, languages);
  //   // db.collection('forum').add(
  //   //   {
  //   //     'title': translatedTitles,
  //   //     'description': translatedDescriptions,
  //   //     'time': DateTime.now().toString(),
  //   //     'comments': {}
  //   //   },
  //   // );
  // }

  // Future<List> toNativeLanguage(DocumentSnapshot doc) async {
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   DocumentSnapshot userData =
  //       await db.collection('users').document(user.uid).get();
  //   String nativeLanguage = userData.data['nativeLanguage'];
  //   List translatedForum = List();
  //   translatedForum.add(doc.data['title'][nativeLanguage]);
  //   translatedForum.add(doc.data['description'][nativeLanguage]);
  //   return translatedForum;
  // }

  // Widget buildPostCard(doc) {
  //   return FutureBuilder(
  //     future: toNativeLanguage(doc),
  //     builder: (BuildContext context, AsyncSnapshot<List> translatedForum) {
  //       return PostCard(
  //         translatedForum.hasData ? translatedForum.data[0] : '',
  //         translatedForum.hasData ? translatedForum.data[1] : '',
  //         DateTime.parse(doc.data['time']),
  //         doc,
  //       );
  //     },
  //   );
  // }

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
    return Scaffold(
      body: StreamBuilder<List<ForumPost>>(
        stream: APIConnect.forumListView,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(
                child: Loader(),
              );
            case ConnectionState.waiting:
              return Center(
                child: Loader(),
              );
            case ConnectionState.active:
              return Center(
                child: Loader(),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                List<PostCard> forumposts =
                  snapshot.data.map((i) => buildPostCard(i)).toList();
                return ListView(
                  children: forumposts,
                );
              }
          }
          return Center(
            child: Loader(),
          );
        },
      ),
    );
  }
}
