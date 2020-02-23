import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/screens/proposal/card.dart';
import 'package:Solon/screens/proposal/search.dart';
import 'package:Solon/screens/proposal/create.dart';
import 'package:Solon/services/proposal_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/proposal_util.dart';
import 'package:Solon/widgets/buttons/create_button.dart';
import 'package:Solon/widgets/buttons/search_button.dart';
import 'package:Solon/widgets/sort_dropdown_menu.dart';

class ProposalsScreen extends StatefulWidget {
  ProposalsScreen({Key key}) : super(key: key);

  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController<String> dropdownMenuStreamController =
      StreamController.broadcast();
  Stream<List<Proposal>> stream;
  TextEditingController editingController = TextEditingController();

  Future<Null> load() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final proposalsSortOption = sharedPrefs.getString('proposalsSortOption');
    dropdownMenuStreamController.sink.add(proposalsSortOption);
    stream = ProposalUtil.screenView(proposalsSortOption);
  }

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  void dispose() {
    dropdownMenuStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: dropdownMenuStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<String> optionVal) {
        switch (optionVal.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          default:
            return GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: load,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 17.0,
                        bottom: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            flex: 9,
                            child: SortDropdownMenu(
                              streamController: dropdownMenuStreamController,
                              value: optionVal.data,
                              preferences: 'proposalsSortOption',
                              items: <String>[
                                'Most votes',
                                'Least votes',
                                'Newly created',
                                'Oldest created',
                                'Upcoming deadlines',
                                'Oldest deadlines',
                              ].map<DropdownMenuItem<String>>((String value) {
                                Map<String, String> itemsMap = {
                                  'Most votes': AppLocalizations.of(context)
                                      .translate("mostVotes"),
                                  'Least votes': AppLocalizations.of(context)
                                      .translate("leastVotes"),
                                  'Newly created': AppLocalizations.of(context)
                                      .translate("newlyCreated"),
                                  'Oldest created': AppLocalizations.of(context)
                                      .translate("oldestCreated"),
                                  'Upcoming deadlines':
                                      AppLocalizations.of(context)
                                          .translate("upcomingDeadlines"),
                                  'Oldest deadlines':
                                      AppLocalizations.of(context)
                                          .translate("oldestDeadlines"),
                                };
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    itemsMap[value],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SearchButton(
                              delegate: ProposalsSearch(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<Proposal>>(
                        stream: Function.apply(
                            ProposalUtil.screenView, [optionVal.data]),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<Proposal>> snapshot,
                        ) {
                          if (snapshot.hasError)
                            return Text("${snapshot.error}");
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            default:
                              if (snapshot.data == null) {
                                return Text('An error occured');
                              }
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Scaffold(
                                  key: _scaffoldKey,
                                  body: ListView(
                                    padding: const EdgeInsets.all(4),
                                    children: snapshot.data
                                        .map(
                                          (json) =>
                                              ProposalCard(proposal: json),
                                        )
                                        .toList(),
                                  ),
                                  floatingActionButton: CreateButton(
                                    creator: CreateProposal(
                                      ProposalConnect.addProposal,
                                    ),
                                  ),
                                ),
                              );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
