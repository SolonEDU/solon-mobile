import 'dart:async';

import 'package:Solon/models/model.dart';
import 'package:Solon/screens/error_screen.dart';
import 'package:Solon/screens/search.dart';
import 'package:Solon/services/network_info.dart';
import 'package:Solon/widgets/buttons/create_button.dart';
import 'package:Solon/widgets/buttons/search_button.dart';
import 'package:Solon/widgets/sort_dropdown_menu.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Screen<T extends Model<T>> extends StatefulWidget {
  final Function screenView;
  final String sortOption;
  final Function searchView;
  final String searchLabel;
  final Widget creator;
  final List<DropdownMenuItem<String>> dropdownItems;

  Screen({
    Key key,
    this.screenView,
    this.sortOption,
    this.searchView,
    this.searchLabel,
    this.creator,
    this.dropdownItems,
  }) : super(key: key);

  @override
  _ScreenState<T> createState() => _ScreenState<T>();
}

class _ScreenState<T extends Model<T>> extends State<Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  StreamController<String> dropdownMenuStreamController =
      StreamController.broadcast();
  Stream<List<T>> stream;
  TextEditingController editingController = TextEditingController();

  Future<Null> load() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    final proposalsSortOption = sharedPrefs.getString(widget.sortOption);
    dropdownMenuStreamController.sink.add(proposalsSortOption);
    stream = widget.screenView(proposalsSortOption);
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
            DataConnectionChecker dataConnectionChecker =
                DataConnectionChecker();
            NetworkInfoImpl networkInfoImpl =
                NetworkInfoImpl(dataConnectionChecker);
            return FutureBuilder<bool>(
              future: networkInfoImpl.isConnected,
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasError)
                  return ErrorScreen(
                    notifyParent: refresh,
                    error: snapshot.error,
                  );
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
                    return GestureDetector(
                      onTap: () =>
                          FocusScope.of(context).requestFocus(FocusNode()),
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: load,
                        child: Column(
                          children: <Widget>[
                            Visibility(
                              visible: snapshot.data,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 17.0,
                                  bottom: 10.0,
                                  right: 10.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 9,
                                      child: SortDropdownMenu(
                                        streamController:
                                            dropdownMenuStreamController,
                                        value: optionVal.data,
                                        preferences: widget.sortOption,
                                        items: widget.dropdownItems,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: SearchButton(
                                        delegate: Search<T>(
                                          context,
                                          widget.searchLabel,
                                          widget.searchView,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: StreamBuilder<List<T>>(
                                stream: Function.apply(
                                    widget.screenView, [optionVal.data]),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<List<T>> snapshot,
                                ) {
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
                                      if (snapshot.hasError) {
                                        return ErrorScreen(
                                          notifyParent: refresh,
                                          error: snapshot.error,
                                        );
                                      }
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: Scaffold(
                                          backgroundColor: Colors.grey[100],
                                          key: _scaffoldKey,
                                          body: ListView(
                                            padding: const EdgeInsets.only(
                                              top: 10.0,
                                              left: 10.0,
                                              right: 10.0,
                                              // bottom: 8.0,
                                            ),
                                            children: snapshot.data
                                                .map((obj) => obj.toCard())
                                                .toList(),
                                          ),
                                          floatingActionButton:
                                              (widget.creator == null)
                                                  ? null
                                                  : CreateButton(
                                                      creator: widget.creator,
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
      },
    );
  }
}
