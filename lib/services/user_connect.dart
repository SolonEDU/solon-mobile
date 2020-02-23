import 'dart:convert';

import 'package:Solon/models/message.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/util/user_util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserConnect {
  static Future<Map<String, dynamic>> registerUser(
    String lang,
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final response = await http.post(
      "${APIConnect.url}/users/register",
      body: json.encode({
        'lang': UserUtil.languages[lang],
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'password': password,
      }),
      headers: await APIConnect.headers,
    );
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
    String email,
    String password,
  ) async {
    try {
      final http.Response response = await http.post(
        "${APIConnect.url}/users/login",
        body: json.encode({'email': email, 'password': password}),
        headers: await APIConnect.headers,
      );

      if (json.decode(response.body)['message'] == 'Error') {
        return json.decode(response.body);
      }

      final userUid = json.decode(response.body)["uid"];

      final http.Response userDataResponse = await http.get(
        "${APIConnect.url}/users/$userUid",
        headers: await APIConnect.headers,
      );
      final userDataResponseJson = json.decode(userDataResponse.body)['user'];
      userDataResponseJson['lang'] =
          UserUtil.langCodeToLang[userDataResponseJson['lang']];
      if (userDataResponseJson['lang'] == null) {
        userDataResponseJson['lang'] = 'English';
        print('NULL LANG'); // TODO: lang resets to English when user signs out and signs back in
        print(userDataResponseJson);
      }
      final userData = json.encode(userDataResponseJson);
      final sharedPrefs = await SharedPreferences.getInstance();
      sharedPrefs.setString('userData', userData);
      sharedPrefs.setString('proposalsSortOption', 'Newly created');
      sharedPrefs.setString('eventsSortOption', 'Upcoming');
      sharedPrefs.setString('forumSortOption', 'Newly created');
      return json.decode(response.body);
    } catch (error) {
      throw error;
    }
  }

  static Future<Map<String, dynamic>> connectUser({int uid}) async {
    final http.Response response = await http.get(
      "${APIConnect.url}/users/$uid",
      headers: await APIConnect.headers,
    );
    return json.decode(response.body)['user'];
  }

  static Future<Message> changeLanguage({int uid, String updatedLang}) async {
    String updatedLangISO6391Code = UserUtil.languages[updatedLang];
    final response = await http.patch(
      "${APIConnect.url}/users/language",
      body: json.encode({
        'uid': uid,
        'lang': updatedLangISO6391Code,
      }),
      headers: await APIConnect.headers,
    );
    int status = response.statusCode;
    return status == 201
        ? Message.fromJson(json.decode(response.body)['message'])
        : throw Exception(
            'Language could not be changed to $updatedLang for user with uid $uid');
  }
}
