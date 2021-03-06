import 'dart:convert';

import 'package:Solon/models/event.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/models/proposal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserUtil {
  static Map<String, String> languages = {
    'English': 'en',
    'Chinese (Simplified)': 'zhcn',
    'Chinese (Traditional)': 'zhtw',
    'Bengali': 'bn',
    'Korean': 'ko',
    'Russian': 'ru',
    'Japanese': 'ja',
    'Ukrainian': 'uk',
  };

  static Map<String, String> langCodeToLang = {
    'en': 'English',
    'zh': 'Chinese (Simplified)',
    'zhcn': 'Chinese (Simplified)',
    'zhtw': 'Chinese (Traditional)',
    'bn': 'Bengali',
    'ko': 'Korean',
    'ru': 'Russian',
    'ja': 'Japanese',
    'uk': 'Ukrainian',
  };

  static Map<Type, String> typeToSharedPrefsKey = {
    Proposal: 'cachedProposalSearches',
    Event: 'cachedEventSearches',
    ForumPost: 'cachedForumSearches'
  };

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

  static Future<String> getPrefLangCode() async {
    final sharedPrefs = await connectSharedPreferences(key: 'userData');
    return languages[sharedPrefs['lang']];
  }

  static dynamic getCachedSearches<T>() async {
    final cachedSearches = await connectSharedPreferences(
      key: typeToSharedPrefsKey[T],
    ); // TODO: repeated code
    return cachedSearches;
  }

  static void cacheSearchQuery<T>(String query) async {
    if (query == '') return; // exit function if search query is empty
    final String sharedPrefsKey = typeToSharedPrefsKey[T];
    final List cachedSearches = await connectSharedPreferences(
      key: sharedPrefsKey,
    );

    if (cachedSearches.contains(query)) {
      cachedSearches.remove(query);
    } else if (cachedSearches.length == 50) { // stores up to 50 previous search queries
      cachedSearches.removeLast();
    }

    cachedSearches.insert(0, query);

    final sharedPrefs = await SharedPreferences.getInstance();
    String cachedSearchesJSON = json.encode(cachedSearches);
    sharedPrefs.setString(sharedPrefsKey, cachedSearchesJSON);
  }

  static void showToast(String message, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
