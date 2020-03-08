import 'package:Solon/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:Solon/services/api_connect.dart';
import 'package:Solon/models/message.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int uid = null;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Message>(
          future: APIConnect.connectRoot(),
          builder: (context, snapshot) {
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
                return Text(
                  "${snapshot.data.message}",
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 17,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
