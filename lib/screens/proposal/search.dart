import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/widgets/cards/proposal_card.dart';
import 'package:flutter/material.dart';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/proposal_util.dart';

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
    return StreamBuilder<List<Proposal>>(
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
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  String get searchFieldLabel =>
      AppLocalizations.of(context).translate("searchProposals");
}
