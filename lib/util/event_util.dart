import 'dart:convert';
import 'package:Solon/util/user_util.dart';
import 'package:http/http.dart' as http;
import 'package:Solon/models/event.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/services/event_connect.dart';

class EventUtil {
  static Stream<List<Event>> _getList(
      {Function function, String query}) async* {
    http.Response response = await function(query: query);
    final sharedPrefs = await UserUtil.connectSharedPreferences();
    final prefLangCode = APIConnect.languages[sharedPrefs['lang']];
    List<Event> _events;
    List collection;
    if (response.statusCode == 200) {
      collection = json.decode(response.body)['events'];
      _events = collection
          .map((json) => Event.fromJson(map: json, prefLangCode: prefLangCode))
          .toList();
    }
    yield _events;
  }

  static Stream<List<Event>> screenView(String query) {
    return _getList(
      function: EventConnect.connectEvents,
      query: query,
    );
  }

  static Stream<List<Event>> searchView(String query) {
    return _getList(
      function: EventConnect.searchEvents,
      query: query,
    );
  }
}
