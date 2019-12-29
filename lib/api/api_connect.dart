import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:Solon/api/message.dart';

import 'package:Solon/proposal/card.dart';
import 'package:Solon/forum/card.dart';
import 'package:Solon/forum/comment.dart';
import 'package:Solon/api/user.dart';
import 'package:Solon/event/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIConnect {
  static final String _url = "https://api.solonedu.com";

  static final Future<Map<String, String>> headers = getHeaders();

  static Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.authorizationHeader:
          await rootBundle.loadString('assets/secret'),
      HttpHeaders.contentTypeHeader: "application/json"
    };
  }

  static Stream<List<ProposalCard>> get proposalListView async* {
    yield await connectProposals();
  }

  static Stream<List<PostCard>> get forumListView async* {
    yield await connectForumPosts();
  }

  static Stream<List<Comment>> commentListView(int fid) async* {
    yield await connectComments(fid: fid);
  }

  static Stream<List<EventCard>> eventListView(int uid) async* {
    yield await connectEvents(uid: uid);
  }

  // static Stream<List<EventCard>> get eventListView async* {
  //   yield await connectEvents();
  // }

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

  static Future<Message> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message for root not found.');
  }

  static Future<List<ProposalCard>> connectProposals() async {
    final http.Response response = await http.get(
      "$_url/proposals",
      headers: await headers,
    );
    List collection = json.decode(response.body)['proposals'];
    List<ProposalCard> _proposals =
        collection.map((json) => ProposalCard.fromJson(json)).toList();
    return _proposals;
  }

  static Future<List<PostCard>> connectForumPosts() async {
    final http.Response response = await http.get(
      "$_url/forumposts",
      headers: await headers,
    );

    List collection = json.decode(response.body)['forumposts'];
    List<PostCard> _proposals =
        collection.map((json) => PostCard.fromJson(json)).toList();
    return _proposals;
  }

  // static Future<List<EventCard>> connectEvents() async {
  //   final http.Response response = await http.get(
  //     "$_url/events",
  //     headers: await headers,
  //   );
  //   List collection = json.decode(response.body)['events'];
  //   List<EventCard> _events =
  //       collection.map((json) => EventCard.fromJson(json)).toList();
  //   return _events;
  // }

  static Future<Message> addProposal(
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    int uid,
  ) async {
    final response = await http.post(
      "$_url/proposals",
      body: json.encode({
        'title': title,
        'description': description,
        'starttime': startTime.toIso8601String(),
        'endtime': endTime.toIso8601String(),
        'uid': uid,
      }),
      headers: await headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message field in proposal object not found.');
  }

  static Future<Map<String, dynamic>> registerUser(
    String lang,
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final response = await http.post(
      "$_url/users/register",
      body: json.encode({
        'lang': languages[lang],
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'password': password,
      }),
      headers: await headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final http.Response response = await http.post(
        "$_url/users/login",
        body: json.encode({'email': email, 'password': password}),
        headers: await headers,
      );

      final userUid = json.decode(response.body)["uid"];
      // print(userUid);

      final http.Response userDataResponse = await http.get(
        "$_url/users/$userUid",
        headers: await headers,
      );
      final userDataResponseJson = json.decode(userDataResponse.body)['user'];
      userDataResponseJson['lang'] = langCodeToLang[userDataResponseJson['lang']];
      // print(json.encode(json.decode(userDataResponse.body)['user']));
      print(userDataResponseJson);
      final userData = json.encode(userDataResponseJson);
      // final userData = ;
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', userData);
      print("${prefs.getString('userData')}");
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  static Future<Map<String, dynamic>> connectSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return null;
    }
    final userData = prefs.getString('userData');
    final userDataMap = json.decode(userData);
    return userDataMap;
  }

  static Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    return true;
  }

  static Future<Map<String, dynamic>> connectVotes(String httpReqType,
      {int pid, int uidUser, int voteVal}) async {
    Map vote = {
      'pid': pid,
      'uid': uidUser,
      'value': voteVal,
    };
    var response = (httpReqType == 'POST') // need pid, uid, and voteVal
        ? await http.post(
            "$_url/votes",
            body: json.encode(vote),
            headers: await headers,
          )
        : (httpReqType == 'GET') // need pid and uidUser
            ? await http.get(
                "$_url/votes/$pid/$uidUser",
                headers: await headers,
              )
            : await http.patch(
                // need pid, uid, and voteVal
                "$_url/votes",
                body: json.encode(vote),
                headers: await headers,
              );
    return json.decode(response.body);
  }

  static Future<List<Comment>> connectComments({int fid}) async {
    final http.Response response = await http.get(
      "$_url/comments/forumpost/$fid",
      headers: await headers,
    );

    List collection = json.decode(response.body)['comments'];
    List<Comment> _comments =
        collection.map((json) => Comment.fromJson(json)).toList();
    return _comments;
  }

  static Future<Message> addComment({
    int fid,
    String content,
    String timestamp,
    int uid,
  }) async {
    final response = await http.post(
      "$_url/comments",
      body: json.encode({
        'fid': fid,
        'content': content,
        'timestamp': timestamp,
        'uid': uid,
      }),
      headers: await headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message field in comment object not found.');
  }

  static Future<User> connectUser({int uid}) async {
    final http.Response response = await http.get(
      "$_url/users/$uid",
      headers: await headers,
    );
    // print(json.decode(response.body)['user'].toString());
    Map collection = json.decode(response.body)['user'];
    print('PRINT COLLECTION ${collection.toString()}');
    User _user = User.fromJson(collection);
    return _user;
  }

  static Future<Message> changeLanguage({int uid, String updatedLang}) async {
    String updatedLangISO6391Code = languages[updatedLang];
    final response = await http.patch(
      "$_url/users/language",
      body: json.encode({
        'uid': uid,
        'lang': updatedLangISO6391Code,
      }),
      headers: await headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception(
            'Language could not be changed to $updatedLang for user with uid $uid');
  }

  static Future<List<EventCard>> connectEvents({int uid}) async {
    final http.Response response = await http.get(
      "$_url/events",
      headers: await headers,
    );

    List collection = json.decode(response.body)['events'];
    List<EventCard> _events =
        collection.map((json) => EventCard.fromJson(json, uid)).toList();
    return _events;
  }

  static Future<Message> addEvent({
    String title,
    String description,
    DateTime date,
  }) async {
    final response = await http.post(
      "$_url/events",
      body: json.encode({
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
      }),
      headers: await headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Event could not be created.');
  }

  static Future<bool> getAttendance({int eid, int uid}) async {
    final response = await http.get(
      "$_url/attenders/$eid/$uid",
      headers: await headers,
    );
    print("$_url/attenders/$eid/$uid");
    String responseMessage = json.decode(response.body)['message'];
    // print(responseMessage);
    return responseMessage == 'Error' ? false : true;
  }

  static Future<Message> changeAttendance(String httpReqType,
      {int eid, int uid}) async {
    http.Response response;
    if (httpReqType == "POST") {
      response = await http.post(
        "$_url/attenders",
        body: json.encode({
          'eid': eid,
          'uid': uid,
        }),
        headers: await headers,
      );
      int status = response.statusCode;
      return status == 201
          ? Message.fromJson(json.decode(response.body)['message'])
          : throw Exception(
              'Attendance value of user $uid could not be created for proposal $eid.');
    } else if (httpReqType == "DELETE") {
      response = await http.delete(
        "$_url/attenders/$eid/$uid",
        headers: await headers,
      );
      int status = response.statusCode;
      return status == 201
          ? Message.fromJson(json.decode(response.body)['message'])
          : throw Exception(
              'Attendance value of user $uid could not be deleted for proposal $eid.');
    }
  }
}
