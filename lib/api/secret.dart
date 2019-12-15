import 'dart:convert';

import 'package:flutter/services.dart';

class Secret {
  final String apikey;

  Secret({this.apikey});

  factory Secret.fromJson(Map<String, dynamic> json) {
    return Secret(apikey: json['apikey']);
  }
}

class SecretLoader {

  static Future<Secret> load(path) {
    return rootBundle.loadStructuredData<Secret>(path,
        (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}
