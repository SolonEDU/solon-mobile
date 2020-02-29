import 'package:Solon/services/status_codes_handler.dart';
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
    return StatusCodesHandler.handleStatusCode(response, response.statusCode);
  }
}
