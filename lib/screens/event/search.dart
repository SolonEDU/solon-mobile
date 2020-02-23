import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/widgets/cards/event_card.dart';
import 'package:flutter/material.dart';
import 'package:Solon/models/event.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/event_util.dart';

class EventsSearch extends SearchDelegate {
  BuildContext context;

  EventsSearch(this.context);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query == '') return Container();
    return StreamBuilder<List<Event>>(
      stream: Function.apply(
        EventUtil.searchView,
        [
          query,
        ],
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            if (snapshot.data == null) {
              return ErrorScreen();
            }
            return ListView(
                children: snapshot.data
                    .map((json) => EventCard(event: json))
                    .toList());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel =>
      AppLocalizations.of(context).translate("searchEvents");
}
