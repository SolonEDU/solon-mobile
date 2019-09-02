import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'dart:collection';

import 'package:Solon/app_localizations.dart';

// import '../../loader.dart';
import './comment.dart';

class PostPage extends StatefulWidget {
  final String title;
  final String description;
  final DateTime time;
  final DocumentSnapshot doc;
  PostPage(this.title, this.description, this.time, this.doc);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final db = Firestore.instance;
  FocusNode _focusNode;
  var document;
  static var commentController = TextEditingController();

  void _update() {
    setState(() {
      document = db.collection('forum').document(widget.doc.documentID);
    });
  }

  @override
  initState() {
    super.initState();
    _update();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  ListView getComments(snapshot) {
    Map<dynamic, dynamic> text = snapshot.data.data['comments'];
    text = SplayTreeMap.from(text);
    List<Widget> textComments = [];
    var textKey;
    text.forEach((key, value) => {
          textKey = key,
          value.forEach((key, value) => {
                textComments
                    .add(Comment(DateTime.parse(textKey), value.toString()))
              })
        });
    return ListView(
      children: textComments,
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: document.get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          // return Container();
          // return Center(
          // child: Loader(),
          // );
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                        child: Card(
                            child: ListTile(
                              leading: Icon(Icons.account_box),
                              title: Container(
                                  child: Text(widget.description),
                                  margin:
                                      EdgeInsets.only(top: 8.0, bottom: 4.0)),
                              subtitle: Container(
                                  child: Text(new DateFormat.yMMMMd("en_US")
                                      .add_jm()
                                      .format(widget.time)),
                                  margin: EdgeInsets.only(bottom: 4.0)),
                            ),
                            margin: EdgeInsets.only(
                                top: 8.0, left: 8.0, right: 8.0)),
                        margin: EdgeInsets.only(bottom: 8.0)),
                    Container(
                        child: Text(AppLocalizations.of(context)
                            .translate('commentSection')),
                        margin: EdgeInsets.only(top: 4.0, bottom: 8.0)),
                    Expanded(child: getComments(snapshot)),
                    Container(
                      child: TextField(
                        style: TextStyle(height: .4),
                        controller: commentController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          hintText: AppLocalizations.of(context)
                              .translate('enterAComment'),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              if (commentController.text.isNotEmpty) {
                                document.updateData(
                                  {
                                    'comments.' + DateTime.now().toString():
                                        commentController.text
                                  },
                                );
                                SchedulerBinding.instance
                                    .addPostFrameCallback((_) {
                                  FocusScope.of(context).unfocus();
                                  commentController.clear();
                                  _update();
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      margin: EdgeInsets.all(12.0),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
