import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './comment.dart';

class PostPage extends StatefulWidget {
  final String title;
  final String description;
  final DateTime time;
  final DocumentSnapshot doc;
  PostPage(this.title, this.description, this.time, this.doc);

  _PostPageState createState() => _PostPageState(
        title,
        description,
        time,
        doc,
      );
}

class _PostPageState extends State<PostPage> {
  final String title;
  final String description;
  final DateTime time;
  final db = Firestore.instance;
  var document;
  DocumentSnapshot doc;
  static var commentController = TextEditingController();

  _PostPageState(
    this.title,
    this.description,
    this.time,
    this.doc,
  );
  // final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Text(description),
          Text(time.toString()),
          Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: TextField(
              style: TextStyle(
                height: 0.7,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Enter a comment',
              ),
              controller: commentController,
              maxLengthEnforced: false,
            ),
          ),
          InkWell(
            child: Icon(Icons.send),
            onTap: () async => {
              document = db.collection('forum').document(doc.documentID),
              document.updateData({'forumComments.' + DateTime.now().toString(): commentController.text})
            }
          ),
        ],
      ),
    );
  }
}
