import 'dart:math';

import 'package:Solon/models/event.dart';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/event_util.dart';
import 'package:Solon/util/forum_util.dart';
import 'package:Solon/util/proposal_util.dart';
import 'package:Solon/util/user_util.dart';
import 'package:Solon/widgets/cards/event_card.dart';
import 'package:Solon/widgets/cards/forum_card.dart';
import 'package:Solon/widgets/cards/proposal_card.dart';
import 'package:flutter/material.dart';

class Search<T> extends SearchDelegate {
  BuildContext context;
  String searchLabel;

  Search(this.context, this.searchLabel);

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
    if (query.isEmpty)
      showSuggestions(
          context); // TODO: make keyboard unfocus cleaner when searching with empty query

    // UserUtil.cacheSearchQuery<T>(query);

    switch (T) {
      case Proposal:
        return StreamBuilder<List<Proposal>>(
          stream: Function.apply(
            ProposalUtil.searchView,
            [query],
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<Proposal>> snapshot) {
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
                      .map((json) => ProposalCard(proposal: json))
                      .toList(),
                );
            }
          },
        );
      case Event:
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
      case ForumPost:
        return StreamBuilder<List<ForumPost>>(
          stream: Function.apply(
            ForumUtil.searchView,
            [query],
          ),
          builder:
              (BuildContext context, AsyncSnapshot<List<ForumPost>> snapshot) {
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
                      .map((json) => ForumCard(post: json))
                      .toList(),
                );
            }
          },
        );
      default:
        return ListView();
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: UserUtil.getCachedSearches<T>(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            snapshot.hasData == null) {
          return Container();
        }
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: IconButton(
                icon: Icon(Icons.restore),
                onPressed: () => {
                  query = snapshot.data[index],
                  showResults(context),
                },
              ),
              trailing: Transform.rotate(
                angle: 270 * pi / 180,
                child: IconButton(
                  icon: Icon(
                    Icons.call_made,
                  ),
                  onPressed: () => {
                    query = snapshot.data[
                        index], // TODO: shows cursor in the beginning of query, which looks weird
                  },
                ),
              ),
              title: Text('${snapshot.data[index]}'),
              onTap: () => {
                query = snapshot.data[index],
                showResults(context),
              },
            );
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel =>
      AppLocalizations.of(context).translate(searchLabel);
}