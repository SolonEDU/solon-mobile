import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // for jsonDecode
import 'package:Solon/API/info.dart';
import 'package:Solon/API/user.dart';

class APIConnect {
  static String _url = "https://api.solonedu.com";


  static Future<Info> connectRoot() async {
    final response = await http.get(_url);
    int status = response.statusCode;
    return status == 200 ? Info.fromJson(json.decode(response.body)) : throw Exception('data not found');
  }

  static Future<List<User>> connectUsers() async {
    final response = await http.get(_url + '/users');
    String responseBody = response.body;
    int status = response.statusCode;
    List collection = json.decode(responseBody);
    List<User> _users = collection.map((json) => User.fromJson(json)).toList();

    return status == 200 ? _users : throw Exception('data not found');
  }


}