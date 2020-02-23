import 'package:flutter/material.dart';
import 'package:Solon/models/comment.dart';
import 'package:Solon/widgets/cards/screen_card.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;

  CommentCard({this.comment});

  @override
  Widget build(BuildContext context) {
    ListTile tile = ListTile(
      contentPadding: EdgeInsets.only(
        top: 5,
        bottom: 5,
        right: 15,
        left: 15,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(comment.comment),
      ),
      subtitle: Container(
        child: Text(comment.date),
        margin: EdgeInsets.only(bottom: 4),
      ),
    );

    return ScreenCard(tile: tile, function: () {});
  }
}
