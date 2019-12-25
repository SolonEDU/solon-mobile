import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:Solon/api/message.dart';

import 'package:Solon/proposal/card.dart';
import 'package:Solon/forum/card.dart';
import 'package:Solon/forum/comment.dart';
// import 'package:Solon/event/card.dart';

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

  // static Stream<List<EventCard>> get eventListView async* {
  //   yield await connectEvents();
  // }

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
    Map<String, String> languages = {
      'English': 'en',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Bengali': 'bn',
      'Korean': 'ko',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Ukrainian': 'uk',
    };
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
    final response = await http.post(
      "$_url/users/login",
      body: json.encode({'email': email, 'password': password}),
      headers: await headers,
    );
    return json.decode(response.body);
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
}
