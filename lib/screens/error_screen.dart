import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final Object error;

  ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(children: <Widget>[
        Text('An error occurred!'),
        Text('$error'),
      ]),
      // TODO: Add a reload button
    );
  }
}
