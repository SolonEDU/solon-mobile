import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './card.dart';
import './create.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final db = Firestore.instance;

  void _addPost(title, description) {
    db.collection('forum').add(
      {
        'forumTitle': title,
        'forumDescription': description,
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
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('forum').snapshots(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents
                      .map((doc) => buildPostCard(doc))
                      .toList(),
                );
              }
              return Container();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePost(_addPost),
            ),
          );
        },
      ),
    );
  }
}
