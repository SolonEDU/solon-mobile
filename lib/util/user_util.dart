import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  static Map<String, String> languages = {
    'English': 'en',
    'Chinese (Simplified)': 'zh-CN',
    'Chinese (Traditional)': 'zh-TW',
    'Bengali': 'bn',
    'Korean': 'ko',
    'Russian': 'ru',
    'Japanese': 'ja',
    'Ukrainian': 'uk',
  };

  static Map<String, String> langCodeToLang = {
    'en': 'English',
    'zh': 'Chinese (Simplified)',
    'zh-CN': 'Chinese (Simplified)',
    'zh-TW': 'Chinese (Traditional)',
    'bn': 'Bengali',
    'ko': 'Korean',
    'ru': 'Russian',
    'ja': 'Japanese',
    'uk': 'Ukrainian',
  };

  static Future<String> getPrefLangCode() async {
    final sharedPref = await connectSharedPreferences(key: 'userData');
    return languages[sharedPref['lang']];
  }

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
