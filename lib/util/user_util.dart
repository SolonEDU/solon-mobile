import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  static Future<Map<String, dynamic>> connectSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return {"errorMessage": "Error"};
    }
    final userData = prefs.getString('userData');
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