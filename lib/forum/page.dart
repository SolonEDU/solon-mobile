import 'package:Solon/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  final int attenders;

  PostPage({
    Key key,
    this.fid,
    this.title,
    this.description,
    this.uid,
    this.timestamp,
    this.numcomments,
    this.attenders,
  }) : super(key: key);

  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with Screen {
  final translator = GoogleTranslator();
  FocusNode _focusNode = FocusNode();
  var document;
  static var commentController = TextEditingController();
  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getPageAppBar(context),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
                child: Card(
                    child: ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Container(
                          child: Text(widget.description),
                          margin: EdgeInsets.only(top: 8.0, bottom: 4.0)),
                      subtitle: Container(
                          child: Text(widget.timestamp),
                          margin: EdgeInsets.only(bottom: 4.0)),
                    ),
                    margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0)),
                margin: EdgeInsets.only(bottom: 8.0)),
            Container(
                child: Text(
                    AppLocalizations.of(context).translate('commentSection')),
                margin: EdgeInsets.only(top: 4.0, bottom: 8.0)),
            StreamBuilder(
              stream: Function.apply(
                APIConnect.commentListView,
                [widget.fid],
              ),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return Column(
                        children: snapshot.data,
                      );
                    }
                }
                return Center(
                  child: CircularProgressIndicator(),
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
              borderRadius: BorderRadius.circular(16),
            ),
            hintText: AppLocalizations.of(context).translate('enterAComment'),
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: () async {
                if (commentController.text.isNotEmpty) {
                  var commentText = commentController.text;
                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    FocusScope.of(context).unfocus();
                    commentController.clear();
                  });
                  await APIConnect.addComment(
                    fid: widget.fid,
                    comment: commentText,
                    timestamp: widget.timestamp,
                    uid: widget.uid,
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
