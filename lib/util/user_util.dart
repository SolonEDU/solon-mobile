import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  static Future<dynamic> connectSharedPreferences({
    @required String key,
  }) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (!sharedPrefs.containsKey(key)) {
      return {"errorMessage": "Error"};
    }
    final userData = sharedPrefs.getString(key);
    final userDataMap = json.decode(userData);
    return userDataMap;
  }

  static void showToast(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
