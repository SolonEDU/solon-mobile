import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:Solon/api/message.dart';
// import 'package:Solon/api/user.dart';
import 'package:Solon/api/proposal.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class APIConnect {
  static String _url = "https://api.solonedu.com";

  static Future<String> loadHeader() async {
    return await rootBundle.loadString('assets/secret');
  }

  static Future<Message> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200 ? Message.fromJson(json.decode(response.body)['message']) : throw Exception('data not found');
  }

  static Future<List<Proposal>> connectProposals() async {
    final response = await http.get("$_url/proposals", headers: {HttpHeaders.authorizationHeader: await loadHeader()},);
    int status = response.statusCode;
    List collection = json.decode(response.body)['proposals'];
    List<Proposal> _proposals = collection.map((json) => Proposal.fromJson(json)).toList();
    return status == 200 ? _proposals : throw Exception('data not found');
  }

  static Future<Message> deleteProposal(pid) async {
    final response = await http.get("INSERT DELETE ROUTE HERE");
    int status = response.statusCode;
    return status == 200 ? Message.fromJson(json.decode(response.body)['message']) : throw Exception('data not found');
  }
}