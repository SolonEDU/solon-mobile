import 'package:flutter/material.dart';

import 'package:Solon/models/forum_post.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/screens/forum/page.dart';
import 'package:Solon/widgets/cards/screen_card.dart';
import 'package:Solon/widgets/text_layout.dart';

class ForumCard extends StatefulWidget {
  final ForumPost post;

  ForumCard({Key key, this.post}) : super(key: key);

  @override
  _ForumCardState createState() => _ForumCardState();
}

class _ForumCardState extends State<ForumCard> {
  @override
  Widget build(BuildContext context) {
    Function function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPage(post: widget.post),
        ),
      );
    };
    int _numComments = widget.post.numcomments;
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: TextLayout.fillLinesWithTextAndAppendTrail(
          rawText: widget.post.title,
          trail: '...',
          textStyle: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TextLayout.fillLinesWithTextAndAppendTrail(
              rawText: widget.post.description,
              trail: '...',
              textStyle: TextStyle(
                fontSize: 17,
                color: Colors.black,
              ),
            ),
          ),
          Text(
            widget.post.timestamp,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          Text(
            "$_numComments ${_numComments == 1 ? AppLocalizations.of(context).translate("comment") : AppLocalizations.of(context).translate("comments")}",
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
    return ScreenCard(tile: tile, function: function);
  }
}
