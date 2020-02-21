import 'package:Solon/models/forum_post.dart';
import 'package:Solon/screens/forum/card.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/forum_util.dart';
import 'package:flutter/material.dart';

class ForumSearch extends SearchDelegate {
  BuildContext context;

  ForumSearch(this.context);

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
    return StreamBuilder<List<ForumPost>>(
      stream: Function.apply(
        ForumUtil.searchView,
        [
          query,
        ],
      ),
      builder: (BuildContext context, AsyncSnapshot<List<ForumPost>> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              children:
                  snapshot.data.map((json) => PostCard(post: json)).toList(),
            );
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
      AppLocalizations.of(context).translate("searchForum");
}
