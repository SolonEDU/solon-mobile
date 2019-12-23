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
  static String _url = "https://api.solonedu.com";

  //for StreamBuilder
  final StreamController<List<Proposal>> _proposals =
      StreamController<List<Proposal>>();

  final StreamController<List<ForumPost>> _forumposts =
      StreamController<List<ForumPost>>();

  Stream<List<Proposal>> get proposals => _proposals.stream;
  Stream<List<ForumPost>> get forumposts => _forumposts.stream;

  static Future<String> loadHeader() async {
    return await rootBundle.loadString('assets/secret');
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
      headers: {HttpHeaders.authorizationHeader: await loadHeader()},
    );

    int status = response.statusCode;
    List collection = json.decode(response.body)['proposals'];
    List<Proposal> _proposals =
        collection.map((json) => Proposal.fromJson(json)).toList();
    print(status);
    return _proposals;
  }

  static Stream<List<Proposal>> get proposalListView async* {
    yield await connectProposals();
  }

  static Stream<List<ForumPost>> get forumListView async* {
    yield await connectForumPosts();
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
    print("${startTime.toIso8601String()} ${endTime.toIso8601String()}");
    final response = await http.post(
      "$_url/proposals",
      body: json.encode(newProposal.toProposalMap()),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: await loadHeader()
      },
    );
    print(json.encode(newProposal.toProposalMap()).toString());
    print(response.body);
    int status = response.statusCode;
    print(status);
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
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: await loadHeader(),
      },
    );
    print(json.encode(newUser.toRegisterMap()).toString());
    print(response.body);
    int status = response.statusCode;
    print(status);
    print(json.decode(response.body));
    return json.decode(response.body);
    // return Message.fromJson(json.decode(response.body)['message']);
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
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: await loadHeader(),
      },
    );
    print(json.encode(user.toLoginMap()).toString());
    print(response.body);
    int status = response.statusCode;
    print(status);
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> connectVotes(String httpReqType, {int pid, int uidUser, int voteVal}) async {
    Vote vote = new Vote(
      pid: pid,
      uidUser: uidUser,
      voteVal: voteVal,
    );
    var response;
    if(httpReqType == 'POST') { // need pid, uid, and voteVal
      response = await http.post(
        "$_url/votes",
        body: json.encode(vote.toVoteMap()),
        headers: {
          HttpHeaders.authorizationHeader: await loadHeader(),
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
    } else if (httpReqType == 'GET') { // need pid and uidUser
      response = await http.get(
        "$_url/votes/$pid/$uidUser",
        headers: {
          HttpHeaders.authorizationHeader: await loadHeader(),
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
    } else if (httpReqType == 'PATCH') { // need pid, uid, and voteVal
      response = await http.patch(
        "$_url/votes",
        body: json.encode(vote.toVoteMap()),
        headers: {
          HttpHeaders.authorizationHeader: await loadHeader(),
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
    }
    return json.decode(response.body);
  }

  static Future<List<ForumPost>> connectForumPosts() async {
    final http.Response response = await http.get(
      "$_url/forumposts",
      headers: {HttpHeaders.authorizationHeader: await loadHeader()},
    );

    int status = response.statusCode;
    List collection = json.decode(response.body)['forumposts'];
    List<ForumPost> _proposals =
        collection.map((json) => ForumPost.fromJson(json)).toList();
    print(status);
    return _proposals;
  }
}
