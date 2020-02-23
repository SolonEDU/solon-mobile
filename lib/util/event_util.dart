import 'package:Solon/util/utility.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/services/event_connect.dart';

class EventUtil {

  static Stream<List<Event>> screenView(String query) {
    return Utility.getList(
      function: EventConnect.connectEvents,
      query: query,
      body: 'events',
      type: Event,
    );
  }

  static Stream<List<Event>> searchView(String query) {
    return Utility.getList(
      function: EventConnect.searchEvents,
      query: query,
      body: 'events',
      type: Event,
    );
  }
}
