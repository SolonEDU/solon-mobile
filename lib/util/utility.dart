import 'dart:convert';

import 'package:Solon/models/comment.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/models/model.dart';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Utility {
  static Stream<List<T>> getList<T extends Model>({
    @required Function function,
    @required String body,
    @required Type type,
    String query,
    int fid,
  }) async* {
    http.Response response = (fid != null) ? await function(fid: fid) : await function(query: query);
    String prefLangCode = await UserUtil.getPrefLangCode();
    List temp;
    List<Model> collection;
    if (response.statusCode == 200) {
      temp = json.decode(response.body)[body];
      switch (type) {
        case Proposal:
          collection = temp
              .map((json) =>
                  Proposal.fromJson(map: json, prefLangCode: prefLangCode))
              .toList();
          break;
        case ForumPost:
          collection = temp
              .map((json) =>
                  ForumPost.fromJson(map: json, prefLangCode: prefLangCode))
              .toList();
          break;
        case Event:
          collection = temp
              .map((json) =>
                  Event.fromJson(map: json, prefLangCode: prefLangCode))
              .toList();
          break;
        case Comment:
          collection = temp
              .map((json) =>
                  Comment.fromJson(map: json, prefLangCode: prefLangCode))
              .toList();
          break;
      }
    }
    yield collection;
  }
}
