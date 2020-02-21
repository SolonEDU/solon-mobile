import 'dart:async';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/screen.dart';
import 'package:Solon/widgets/page_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/screens/forum/comment.dart';

class PostPage extends StatefulWidget {
  final ForumPost post;

  PostPage({
    Key key,
    this.post
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
      stream = APIConnect.commentListView(widget.post.fid);
    });
  }

  @override
  void initState() {
    getStream();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppBar(),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              child: Text(
                widget.post.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            Container(
              child: Text(
                widget.post.description,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            ),
            Container(
              child: Text(
                widget.post.timestamp,
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            ),
            Container(
              child: Text(
                AppLocalizations.of(context).translate("commentSection"),
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
            hintText: AppLocalizations.of(context).translate("enterAComment"),
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
                    fid: widget.post.fid,
                    comment: commentText,
                    timestamp: DateTime.now().toIso8601String(),
                    uid: widget.post.uid,
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
