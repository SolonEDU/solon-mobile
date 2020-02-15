import 'dart:async';

import 'package:Solon/generated/i18n.dart';
import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

import 'package:Solon/app_localizations.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:Solon/forum/comment.dart';
// import 'package:Solon/loader.dart';

class PostPage extends StatefulWidget {
  final int fid;
  final String title;
  final String description;
  final int uid;
  final String timestamp;
  final int numcomments;

  PostPage({
    Key key,
    this.fid,
    this.title,
    this.description,
    this.uid,
    this.timestamp,
    this.numcomments,
  }) : super(key: key);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with Screen {
  final translator = GoogleTranslator();
  FocusNode _focusNode = FocusNode();
  static var commentController = TextEditingController();
  Stream<List<Comment>> stream;

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> getStream() async {
    setState(() {
      stream = APIConnect.commentListView(widget.fid);
    });
  }

  @override
  void initState() {
    getStream();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getPageAppBar(context),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            Container(
              child: Text(
                widget.description,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            Container(
              child: Text(
                widget.timestamp,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            ),
            Container(
              child: Text(
                I18n.of(context).commentSection,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20),
            ),
            StreamBuilder(
              stream: stream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: snapshot.data,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        child: TextField(
          controller: commentController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
            ),
            hintText: I18n.of(context).enterAComment,
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  var commentText = commentController.text;
                  Future.delayed(const Duration(milliseconds: 50), () {
                    commentController.clear();
                    _focusNode.unfocus();
                  });
                  APIConnect.addComment(
                    fid: widget.fid,
                    comment: commentText,
                    timestamp: DateTime.now().toIso8601String(),
                    uid: widget.uid,
                  ).then(
                    (message) {
                      getStream();
                    },
                  );
                }
              },
            ),
          ),
        ),
        margin: EdgeInsets.all(12.0),
        color: Colors.white,
      ),
    );
  }
}
