import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:Solon/api/message.dart';
import 'package:Solon/api/user.dart';
import 'package:Solon/api/proposal.dart';
import 'package:Solon/api/comment.dart';
import 'package:Solon/api/event.dart';
import 'package:Solon/api/forumpost.dart';
import 'package:Solon/api/vote.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class APIConnect {
  static String _url = "https://api.solonedu.com";

  //for StreamBuilder
  final StreamController<List<Proposal>> _proposals =
      StreamController<List<Proposal>>();
  Stream<List<Proposal>> get proposals => _proposals.stream;

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

    // await Future.delayed(Duration(seconds: 1));

    int status = response.statusCode;
    List collection = json.decode(response.body)['proposals'];
    List<Proposal> _proposals =
        collection.map((json) => Proposal.fromJson(json)).toList();
    return status == 200
        ? _proposals
        : throw Exception('failed to retrieve proposals');
  }

  //for StreamBuilder
  static Stream<List<Proposal>> get proposalListView async* {
    yield await connectProposals();
  }

  // static Future<Message> deleteProposal(pid) async {
  //   final response = await http.post("INSERT DELETE ROUTE HERE");
  //   int status = response.statusCode;
  //   return status == 200 ? Message.fromJson(json.decode(response.body)['message']) : throw Exception('data not found');
  // }

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

  static Future<Vote> connectVotes() async {
    final response = await http.get(
      "$_url/votes",
      headers: {HttpHeaders.authorizationHeader: await loadHeader()},
    );
  }
}
