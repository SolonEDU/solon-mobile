import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:Solon/models/message.dart';

class APIConnect {
  static final String url = "https://api.solonedu.com";

  static final Future<Map<String, String>> headers = getHeaders();

  static Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.authorizationHeader:
          await rootBundle.loadString('assets/secret'),
      HttpHeaders.contentTypeHeader: "application/json"
    };
  }

  static Future<Message> connectRoot() async {
    final response = await http.get(url);
    int status = response.statusCode;
    if (status == 200) {
      return Message.fromJson(json.decode(response.body)['message']);
    } else if (status == 500) {
      throw Exception('Internal Server Error -- We had a problem with our server. Try again later.');
    } else if (status == 504) {
      throw Exception('Gateway Timeout');
    } else {
      throw Exception('An unknown error occurred. care.');
    }
  }
}
