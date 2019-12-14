import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './card.dart';
import './create.dart';
import '../loader.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final db = Firestore.instance;
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

  void _addPost(
    String title,
    String description,
  ) async {
    Map<String, String> languages = {
      'English': 'en',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Bengali': 'bn',
      'Korean': 'ko',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Ukrainian': 'uk'
    };
    Map<String, String> translatedTitles = {};
    Map<String, String> translatedDescriptions = {};
    List<Map> translated = [translatedTitles, translatedDescriptions];
    translated = await translateAll(title, description, translated, languages);
    db.collection('forum').add(
      {
        'title': translatedTitles,
        'description': translatedDescriptions,
        'time': DateTime.now().toString(),
        'comments': {}
      },
    );
  }

  Future<List> toNativeLanguage(DocumentSnapshot doc) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData =
        await db.collection('users').document(user.uid).get();
    String nativeLanguage = userData.data['nativeLanguage'];
    List translatedForum = List();
    translatedForum.add(doc.data['title'][nativeLanguage]);
    translatedForum.add(doc.data['description'][nativeLanguage]);
    return translatedForum;
  }

  Widget buildPostCard(doc) {
    return FutureBuilder(
      future: toNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<List> translatedForum) {
        return PostCard(
          translatedForum.hasData ? translatedForum.data[0] : '',
          translatedForum.hasData ? translatedForum.data[1] : '',
          DateTime.parse(doc.data['time']),
          doc,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('forum')
          // .orderBy('eventDate', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          default:
            return Scaffold(
              body: Center(
                child: ListView(
                  padding: EdgeInsets.all(8),
                  children: <Widget>[
                    Column(
                      children: snapshot.data.documents
                          .map((doc) => buildPostCard(doc))
                          .toList(),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'unq1',
                child: Icon(Icons.add),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePost(_addPost)),
                  )
                },
              ),
            );
        }
      },
    );
  }
}
