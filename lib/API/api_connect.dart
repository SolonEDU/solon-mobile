import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert'; // for jsonDecode
import 'package:Solon/info.dart';

class api_connect {
  static String _url = "https://api.solonedu.com/";

  static Future<Info> connect() async {
    final response = await http.get(_url);

    return Info.fromJson(json.decode(response.body));
  }
}