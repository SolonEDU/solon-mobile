import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:collection';

// import '../../loader.dart';
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

  void _update() {
    setState(() {
    document = db.collection('forum').document(doc.documentID);
    });
  }

  @override
  initState() {
    super.initState();
    _update();
  }

  Widget build(BuildContext context) {
    var comments;
    document.get().then((docu) => {
          comments = docu.data['forumComments'],
        });
    return FutureBuilder(
      future: document.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            // return Container();
            // return Container();
            // return Center(
              // child: Loader(),
            // );
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(title),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text(description),
                        subtitle: Text(time.toString()),
                      ),
                    ),
                    Text('Comment Section'),
                    Expanded(child: getComments(snapshot)),
                    TextField(
                      style: TextStyle(
                        height: 1,
                      ),
                      controller: commentController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(64),
                        ),
                        hintText: 'Enter a comment',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (commentController.text.length > 0) {
                              document.updateData(
                                {
                                  'forumComments.' + DateTime.now().toString():
                                      commentController.text
                                },
                              );
                              _update();
                              commentController.text = '';
                            }
                          },
                        ),
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

  ListView getComments(snapshot) {
    Map<dynamic, dynamic> text = snapshot.data.data['forumComments'];
    text = SplayTreeMap.from(text);
    List<Widget> textComments = [];
    var textKey;
    text.forEach((key, value) => {
          textKey = key,
          value.forEach((key, value) =>
              {textComments.add(Comment(textKey.toString(), value.toString()))})
        });
    return ListView(
      children: textComments,
    );
  }
}
