import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // for jsonDecode
import 'package:Solon/api/info.dart';
import 'package:Solon/api/user.dart';
import 'package:Solon/api/proposal.dart';
import 'dart:io';

class APIConnect {
  static String _url = "https://api.solonedu.com";


  static Future<Info> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200 ? Info.fromJson(json.decode(response.body)) : throw Exception('data not found');
  }

  static Future<List<Proposal>> connectProposals() async {
    final response = await http.get("$_url/proposals", headers: {HttpHeaders.authorizationHeader: "onlyweknowthiskey"},);
    int status = response.statusCode;
    List collection = json.decode(response.body)['proposals'];
    List<Proposal> _proposals = collection.map((json) => Proposal.fromJson(json)).toList();
    return status == 200 ? _proposals : throw Exception('data not found');
  }
}