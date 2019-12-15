import 'package:Solon/API/secret.dart';
import 'package:flutter/material.dart';
// import 'package:Solon/app_localizations.dart';
import 'package:Solon/API/api_connect.dart';
import 'package:Solon/API/info.dart';
import 'package:Solon/loader.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Secret>(
          future: SecretLoader.load("./API/secrets.json"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text("${snapshot.data.apikey}");
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Loader();
          }
        ),
      ),
    );
  }
}
