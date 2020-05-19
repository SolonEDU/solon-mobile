import 'dart:math';

import 'package:Solon/models/model.dart';
import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/user_util.dart';
import 'package:flutter/material.dart';

class Search<T extends Model<T>> extends SearchDelegate {
  BuildContext context;
  String searchLabel;
  Function view;

  Search(this.context, this.searchLabel, this.view);

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
    if (query.isEmpty) {
      return Container(
          color: Colors.grey[
              100]); // TODO: make keyboard unfocus cleaner when searching with empty query
    }

    UserUtil.cacheSearchQuery<T>(query);

    return StatefulBuilder(builder: (
      BuildContext context,
      StateSetter setState,
    ) {
      return StreamBuilder<List<T>>(
        stream: Function.apply(
          view,
          [query],
        ),
        builder: (BuildContext context, AsyncSnapshot<List<T>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ErrorScreen(
                notifyParent: () => setState(() {}),
                error: snapshot.error,
              );
            case ConnectionState.active:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return ErrorScreen(
                  notifyParent: () => setState(() {}),
                  error: snapshot.error,
                );
              }
              return Container(
                color: Colors.grey[100],
                child: ListView(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                  children: snapshot.data.map((obj) => obj.toCard()).toList(),
                ),
              );
          }
        },
      );
    });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return FutureBuilder(
          future: UserUtil.getCachedSearches<T>(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Container();
              default:
                if (snapshot.hasError) {
                  return ErrorScreen(
                    notifyParent: () => setState(() {}),
                    error: snapshot.error,
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.search),
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
            }
          },
        );
      },
    );
  }

  @override
  String get searchFieldLabel =>
      AppLocalizations.of(context).translate(searchLabel);
}
