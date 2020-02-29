import 'dart:convert';

import 'package:Solon/models/model.dart';
import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Utility {
  static Stream<List<T>> getList<T extends Model>({
    @required Function function,
    @required String body,
    String query,
    int fid,
  }) async* {
    http.Response response =
        (fid != null) ? await function(fid: fid) : await function(query: query);
    String prefLangCode = await UserUtil.getPrefLangCode();
    List<T> collection;
    if (response.statusCode == 200) {
      List temp = json.decode(response.body)[body];
      collection = temp
          .map((json) =>
              Model<T>.fromJson(json: json, prefLangCode: prefLangCode))
          .cast<T>()
          .toList();
    }
    yield collection;
  }
}
