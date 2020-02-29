import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:Solon/models/message.dart';

class StatusCodesHandler {
  static Message handleStatusCode(http.Response response, int statusCode) {
    if (statusCode == 200 || statusCode == 201) {
      return Message.fromJson(json.decode(response.body)['message']);
    } else if (statusCode == 500) {
      return Message.fromJson(
          'Internal Server Error -- We had a problem with our server. Try again later.');
    } else if (statusCode == 504) {
      return Message.fromJson('Gateway Timeout');
    } else {
      return Message.fromJson('Unknown Error; care.');
    }
  }
}
