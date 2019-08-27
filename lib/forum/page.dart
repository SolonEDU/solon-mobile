import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './comment.dart';

class PostPage extends StatefulWidget {
  final String title;
  final String description;
  final DateTime time;
  // final comments;
  final DocumentSnapshot doc;
  PostPage(
    this.title, 
    this.description, 
    this.time, 
    // this.comments, 
    this.doc);

  _PostPageState createState() => _PostPageState(
        title,
        description,
        time,
        // comments,
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
    // this.comments,
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
  // final _formKey = GlobalKey<FormState>();

  // List<String> commentParse(String text) {
  //   return text.split(",");
  // }

  Widget build(BuildContext context) {
    // var comments; 
    // document.get().then((docu) => {
    //   comments = docu.data['forumComments'],
    // });
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
              document.updateData({'forumComments.' + DateTime.now().toString(): commentController.text + '\n'}),
              _update()
            }
          ),
          FutureBuilder(
            future: document.get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Text('loading');
                case ConnectionState.done:
                  if(snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  var text = snapshot.data.data['forumComments'].toString().split(",");
                  var comments = <Widget>[];
                  for (int i = 0; i < text.length; i++) {
                    //print(text.elementAt(i));
                    comments.add(Text(text.elementAt(i)));
                  }
                  return Column(children: comments);                  
              }
              return null;
            },
          )
          // Container(
            // child: Text(comments.toString())
          // ),
        ],
      ),
    );
  }
}
