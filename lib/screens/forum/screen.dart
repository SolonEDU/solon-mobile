import 'dart:async';
import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/screens/search.dart';
import 'package:Solon/widgets/cards/forum_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Solon/models/forum_post.dart';
import 'package:Solon/screens/forum/create.dart';
import 'package:Solon/services/forum_connect.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/util/forum_util.dart';
import 'package:Solon/widgets/buttons/create_button.dart';
import 'package:Solon/widgets/buttons/search_button.dart';
import 'package:Solon/widgets/sort_dropdown_menu.dart';

class ForumScreen extends StatefulWidget {
  ForumScreen({Key key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController<String> dropdownMenuStreamController =
      StreamController.broadcast();
  Stream<List<ForumPost>> stream;

  Future<Null> load() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final forumSortOption = sharedPrefs.getString('forumSortOption');
    dropdownMenuStreamController.sink.add(forumSortOption);
    stream = ForumUtil.screenView(forumSortOption);
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

  void refresh() {
    setState(() {});
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
                              preferences: 'forumSortOption',
                              items: <String>[
                                'Newly created',
                                'Oldest created',
                                'Most comments',
                                'Least comments',
                              ].map<DropdownMenuItem<String>>((String value) {
                                Map<String, String> itemsMap = {
                                  'Newly created': AppLocalizations.of(context)
                                      .translate("newlyCreated"),
                                  'Oldest created': AppLocalizations.of(context)
                                      .translate("oldestCreated"),
                                  'Most comments': AppLocalizations.of(context)
                                      .translate("mostComments"),
                                  'Least comments': AppLocalizations.of(context)
                                      .translate("leastComments"),
                                };
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(itemsMap[value]),
                                );
                              }).toList(),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SearchButton(
                              delegate:
                                  Search<ForumPost>(context, "searchForum", ForumUtil.searchView),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder<List<ForumPost>>(
                        stream: Function.apply(
                          ForumUtil.screenView,
                          [
                            optionVal.data,
                          ],
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ForumPost>> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return ErrorScreen(
                                notifyParent: refresh,
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
                              if (snapshot.hasError)
                                return ErrorScreen(
                                  notifyParent: refresh,
                                  error: snapshot.error,
                                );
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Scaffold(
                                  key: _scaffoldKey,
                                  body: ListView(
                                    padding: const EdgeInsets.all(4),
                                    children: snapshot.data
                                        .map((json) => ForumCard(post: json))
                                        .toList(),
                                  ),
                                  floatingActionButton: CreateButton(
                                    creator:
                                        CreatePost(ForumConnect.addForumPost),
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
