import 'package:Solon/models/proposal.dart';
import 'package:Solon/screens/proposal/card.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/proposal_util.dart';
import 'package:flutter/material.dart';

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
        ProposalUtil.searchView,
        [query],
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Proposal>> snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              children: snapshot.data
                  .map((json) => ProposalCard(
                        proposal: json,
                      ))
                  .toList(),
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
      AppLocalizations.of(context).translate("searchProposals");
}