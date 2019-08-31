import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './card.dart';
import './create.dart';
import '../../loader.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final db = Firestore.instance;
  final translator = GoogleTranslator();

  void _addPost(title, description) async {
    Map<String, String> translatedForumTitlesMap = {
      'English': await translator.translate(title, to: 'en'),
      'Chinese (Simplified)': await translator.translate(title, to: 'zh-cn'),
      'Chinese (Traditional)': await translator.translate(title, to: 'zh-tw'),
      'Bengali': await translator.translate(title, to: 'bn'),
      'Korean': await translator.translate(title, to: 'ko'),
      'Russian': await translator.translate(title, to: 'ru'),
      'Japanese': await translator.translate(title, to: 'ja'),
      'Ukrainian': await translator.translate(title, to: 'uk'),
    };

    Map<String, String> translatedForumDescriptionsMap = {
      'English': await translator.translate(description, to: 'en'),
      'Chinese (Simplified)': await translator.translate(description, to: 'zh-cn'),
      'Chinese (Traditional)': await translator.translate(description, to: 'zh-tw'),
      'Bengali': await translator.translate(description, to: 'bn'),
      'Korean': await translator.translate(description, to: 'ko'),
      'Russian': await translator.translate(description, to: 'ru'),
      'Japanese': await translator.translate(description, to: 'ja'),
      'Ukrainian': await translator.translate(description, to: 'uk'),
    };

    db.collection('forum').add(
      {
        'forumTitle': translatedForumTitlesMap,
        'forumDescription': translatedForumDescriptionsMap,
        'forumTime': DateTime.now().toString(),
        'forumComments': {},
      },
    );
  }

  PostCard buildPostCard(doc) {
    return PostCard(
      doc.data['forumTitle'],
      doc.data['forumDescription'],
      DateTime.parse(doc.data['forumTime']),
      doc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('forum')
          .orderBy('forumTime', descending: true)
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
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'unq3',
                child: Icon(Icons.add),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreatePost(_addPost)),
                  ),
                },
              ),
            );
        }
      },
    );
  }
}
