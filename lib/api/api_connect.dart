import 'package:Solon/api/forumpost.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:Solon/api/message.dart';
// import 'package:Solon/api/user.dart';
import 'package:Solon/api/proposal.dart';
// import 'package:Solon/api/comment.dart';
// import 'package:Solon/api/event.dart';
import 'package:Solon/api/vote.dart';
import 'package:Solon/api/register.dart';
import 'package:Solon/api/login.dart';
import 'dart:io';
import 'package:flutter/services.dart';

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

  static Stream<List<Proposal>> get proposalListView async* {
    yield await connectProposals();
  }

  static Stream<List<ForumPost>> get forumListView async* {
    yield await connectForumPosts();
  }

  static Future<Message> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception('Message for root not found.');
  }

  static Future<List<Proposal>> connectProposals() async {
    final http.Response response = await http.get(
      "$_url/proposals",
      headers: await headers,
    );
    List collection = json.decode(response.body)['proposals'];
    List<Proposal> _proposals =
        collection.map((json) => Proposal.fromJson(json)).toList();
    return _proposals;
  }

  static Future<List<ForumPost>> connectForumPosts() async {
    final http.Response response = await http.get(
      "$_url/forumposts",
      headers: await headers,
    );

    List collection = json.decode(response.body)['forumposts'];
    List<ForumPost> _proposals =
        collection.map((json) => ForumPost.fromJson(json)).toList();
    return _proposals;
  }

  static Future<Message> addProposal(
    String title,
    String description,
    DateTime startTime,
    DateTime endTime,
    int uid,
  ) async {
    Proposal newProposal = new Proposal(
      title: title,
      description: description,
      startTime: startTime.toIso8601String(),
      endTime: endTime.toIso8601String(),
      uid: uid,
    );
    final response = await http.post(
      "$_url/proposals",
      body: json.encode(newProposal.toProposalMap()),
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
    Register newUser = new Register(
      lang: lang,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    final response = await http.post(
      "$_url/users/register",
      body: json.encode(newUser.toRegisterMap()),
      headers: await headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
  ) async {
    Login user = new Login(
      email: email,
      password: password,
    );
    final response = await http.post(
      "$_url/users/login",
      body: json.encode(user.toLoginMap()),
      headers: await headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> connectVotes(String httpReqType,
      {int pid, int uidUser, int voteVal}) async {
    Vote vote = new Vote(
      pid: pid,
      uidUser: uidUser,
      voteVal: voteVal,
    );
    var response = (httpReqType == 'POST') // need pid, uid, and voteVal
        ? await http.post(
            "$_url/votes",
            body: json.encode(vote.toVoteMap()),
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
                body: json.encode(vote.toVoteMap()),
                headers: await headers,
              );
    return json.decode(response.body);
  }
}
