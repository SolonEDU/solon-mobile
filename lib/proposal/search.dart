import 'package:Solon/api/api_connect.dart';
import 'package:flutter/material.dart';
import 'package:Solon/generated/i18n.dart';

// TODO: move to another file after we're done experimenting
class ProposalsSearch extends SearchDelegate {
  BuildContext context;

  ProposalsSearch(this.context);
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
    return StreamBuilder(
      stream: Function.apply(
        APIConnect.proposalSearchListView,
        [
          query,
        ],
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              children: snapshot.data,
            );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
    // StreamBuilder(
    //   stream: Function.apply(
    //     APIConnect.proposalSearchListView,
    //     [
    //       query,
    //     ],
    //   ),
    //   builder: (BuildContext context, AsyncSnapshot snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Center();
    //       default:
    //         if (query == '') {
    //           return Center();
    //         } else if (snapshot.hasError) {
    //           return Center();
    //         }
    //         return ListView(
    //           children: snapshot.data,
    //         );
    //     }
    //   },
    // );
  }

  @override
  String get searchFieldLabel => I18n.of(context).searchProposals;
}