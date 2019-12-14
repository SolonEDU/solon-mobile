import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // for jsonDecode
import 'package:Solon/info.dart';
import 'package:Solon/users.dart';

class api_connect {
  static String _url = "https://api.solonedu.com/";
  

  static Future<Info> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200 ? Info.fromJson(json.decode(response.body)) : throw Exception('data not found');
  }

  static Future<List<Users>> connectUsers() async {
    final response = await http.get(_url + 'users');
    String responseBody = response.body;
    int status = response.statusCode;
    List collection = json.decode(responseBody);
    List<Users> _users = collection.map((json) => Users.fromJson(json)).toList();

    return _users;
  }
}