import 'package:Solon/models/comment.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/models/proposal.dart';
import 'package:flutter/material.dart';

class Model<T> {
  Model();

  factory Model.fromJson({
    @required Map<String, dynamic> json,
    @required String prefLangCode,
  }) {
    switch (T) {
      case Proposal:
        return Proposal.fromJson(map: json, prefLangCode: prefLangCode)
            as Model<T>;
      case Event:
        return Event.fromJson(map: json, prefLangCode: prefLangCode)
            as Model<T>;
      case ForumPost:
        return ForumPost.fromJson(map: json, prefLangCode: prefLangCode)
            as Model<T>;
      case Comment:
        return Comment.fromJson(map: json, prefLangCode: prefLangCode)
            as Model<T>;
    }
    return Model();
  }
}
