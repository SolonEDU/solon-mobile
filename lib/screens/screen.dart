import 'dart:async';

import 'package:Solon/models/model.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Screen<T extends Model> extends StatefulWidget {
  Screen({Key key}) : super(key: key);

  @override
  _ScreenState<T> createState() => _ScreenState<T>();
}

class _ScreenState<T extends Model> extends State<Screen> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();

  // StreamController<String> dropdownMenuStreamController =
  //     StreamController.broadcast();
  Stream<List<T>> stream;
  TextEditingController editingController = TextEditingController();

  Future<Null> load() async {
    // final sharedPrefs = await SharedPreferences.getInstance();
    // final proposalsSortOption = sharedPrefs.getString('proposalsSortOption');
    // dropdownMenuStreamController.sink.add(proposalsSortOption);
    // stream = ProposalUtil.screenView(proposalsSortOption);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
