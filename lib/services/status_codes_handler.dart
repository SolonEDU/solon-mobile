import 'dart:convert';

import 'package:Solon/models/message.dart';
import 'package:http/http.dart' as http;

class StatusCodesHandler {
  static Message handleStatusCode(http.Response response, int statusCode) {
    if (statusCode == 200) {
      return Message.fromJson(json.decode(response.body)['message']);
    } else if (statusCode == 500) {
      throw Exception('Internal Server Error -- We had a problem with our server. Try again later.');
    } else if (statusCode == 504) {
      throw Exception('Gateway Timeout');
    } else {
      return Message.fromJson('Unknown Error; care.');
    }
  }
}