import 'dart:async';
import 'package:Solon/models/proposal.dart';
import 'package:Solon/screens/proposal/card.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/screens/proposal/search.dart';
import 'package:Solon/util/proposal_util.dart';
import 'package:Solon/widgets/create_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/util/screen.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/screens/proposal/create.dart';

class ProposalsScreen extends StatefulWidget {
  ProposalsScreen({Key key}) : super(key: key);

  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> with Screen {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController dropdownMenuStreamController = StreamController.broadcast();
  Stream<List<Proposal>> stream;
  TextEditingController editingController = TextEditingController();

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final proposalsSortOption = prefs.getString('proposalsSortOption');
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
    return StreamBuilder(
      stream: dropdownMenuStreamController.stream,
      builder: (context, optionVal) {
        switch (optionVal.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              //TODO: can be abstracted
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
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
                          Row(
                            children: <Widget>[
                              Text(AppLocalizations.of(context)
                                  .translate("sortBy")),
                              Container(
                                // TODO: is this Container() needed here ?
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: optionVal.data,
                                      iconSize: 24,
                                      elevation: 8,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.pink[400],
                                      ),
                                      onChanged: (String newValue) async {
                                        dropdownMenuStreamController.sink
                                            .add(newValue);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setString(
                                          'proposalsSortOption',
                                          newValue,
                                        );
                                      },
                                      items: <String>[
                                        'Most votes',
                                        'Least votes',
                                        'Newly created',
                                        'Oldest created',
                                        'Upcoming deadlines',
                                        'Oldest deadlines',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        Map<String, String> itemsMap = {
                                          'Most votes':
                                              AppLocalizations.of(context)
                                                  .translate("mostVotes"),
                                          'Least votes':
                                              AppLocalizations.of(context)
                                                  .translate("leastVotes"),
                                          'Newly created':
                                              AppLocalizations.of(context)
                                                  .translate("newlyCreated"),
                                          'Oldest created':
                                              AppLocalizations.of(context)
                                                  .translate("oldestCreated"),
                                          'Upcoming deadlines':
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      "upcomingDeadlines"),
                                          'Oldest deadlines':
                                              AppLocalizations.of(context)
                                                  .translate("oldestDeadlines"),
                                        };
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            itemsMap[value],
                                            // textAlign: TextAlign.left,
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 45.0,
                            height: 45.0,
                            child: RawMaterialButton(
                              onPressed: () {
                                showSearch(
                                  context: context,
                                  delegate: ProposalsSearch(context),
                                );
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.pink[400],
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.white,
                              // padding: const EdgeInsets.all(15.0),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: Function.apply(ProposalUtil.screenView, [
                          optionVal.data,
                        ]),
                        // stream: Function.apply(
                        //   ProposalUtil.getListView,
                        //   null, // no positional arguments
                        //   {
                        //     #function: ProposalConnect.connectProposals,
                        //     #query: optionVal.data,
                        //   },
                        // ),
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<List<Proposal>> snapshot,
                        ) {
                          if (snapshot.hasError)
                            return Text(
                              "${snapshot.error}",
                            );
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Scaffold(
                                  body: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              );
                            default:
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Scaffold(
                                  key: _scaffoldKey,
                                  body: ListView(
                                      padding: const EdgeInsets.all(4),
                                      children: snapshot.data
                                          .map((json) =>
                                              ProposalCard(proposal: json))
                                          .toList()),
                                  floatingActionButton: CreateButton(
                                    creator: CreateProposal(
                                      APIConnect.addProposal,
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
