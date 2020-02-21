import 'package:flutter/material.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/models/message.dart';

class HomeScreen extends StatelessWidget {
  final int uid;
  HomeScreen({Key key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Message>(
            future: APIConnect.connectRoot(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("${snapshot.data.message} Your uid is: $uid");
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}