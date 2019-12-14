import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/API/api_connect.dart';
import 'package:Solon/info.dart';
import 'package:Solon/loader.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Info>(
          future: api_connect.connect(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("${snapshot.data.info}");
            }
            return Loader();
          }
        ),
      ),
    );
  }
}
