import 'package:flutter/material.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/screen.dart';
import 'package:Solon/screens/forum/page.dart';
import 'package:Solon/widgets/screen_card.dart';

class PostCard extends StatefulWidget {
  final ForumPost post;

  PostCard({
    Key key,
    this.post
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with Screen {
  @override
  Widget build(BuildContext context) {
    Function function = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostPage(
            post: widget.post
          ),
        ),
      );
    };
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          (widget.post.title.length > 40)
              ? '${widget.post.title.substring(0, 40)}...'
              : widget.post.title,
          style: TextStyle(
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
            child: Text(
              '${widget.post.description}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          ),
          Text(widget.post.timestamp),
          Text(
              "${widget.post.numcomments} ${AppLocalizations.of(context).translate("comments")}"),
        ],
      ),
    );
    return ScreenCard(tile: tile, function: function);
  }
}
