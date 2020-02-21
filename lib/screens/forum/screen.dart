import 'dart:async';
import 'package:Solon/models/forum_post.dart';
import 'package:Solon/util/app_localizations.dart';
import 'package:Solon/screens/forum/search.dart';
import 'package:Solon/util/forum_util.dart';
import 'package:Solon/widgets/create_button.dart';
import 'package:Solon/widgets/search_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Solon/util/screen.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/screens/forum/card.dart';
import 'package:Solon/screens/forum/create.dart';

class ForumScreen extends StatefulWidget {
  ForumScreen({Key key}) : super(key: key);

  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> with Screen {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController dropdownMenuStreamController = StreamController.broadcast();
  Stream<List<ForumPost>> stream;

  Future<Null> load() async {
    final prefs = await SharedPreferences.getInstance();
    final forumSortOption = prefs.getString('forumSortOption');
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
                                          'forumSortOption',
                                          newValue,
                                        );
                                      },
                                      items: <String>[
                                        'Newly created',
                                        'Oldest created',
                                        'Most comments',
                                        'Least comments',
                                      ].map<DropdownMenuItem<String>>(
                                          (String value) {
                                        Map<String, String> itemsMap = {
                                          'Newly created':
                                              AppLocalizations.of(context)
                                                  .translate("newlyCreated"),
                                          'Oldest created':
                                              AppLocalizations.of(context)
                                                  .translate("oldestCreated"),
                                          'Most comments':
                                              AppLocalizations.of(context)
                                                  .translate("mostComments"),
                                          'Least comments':
                                              AppLocalizations.of(context)
                                                  .translate("leastComments"),
                                        };
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(itemsMap[value]),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SearchButton(
                            delegate: ForumSearch(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: Function.apply(
                          ForumUtil.screenView,
                          [
                            optionVal.data,
                          ],
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ForumPost>> snapshot) {
                          if (snapshot.hasError)
                            return Text("${snapshot.error}");
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
                                        .map((json) => PostCard(post: json))
                                        .toList(),
                                  ),
                                  floatingActionButton: CreateButton(
                                    creator:
                                        CreatePost(APIConnect.addForumPost),
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
