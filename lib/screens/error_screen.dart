import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(children: <Widget>[
        Text('An error occurred!'),
      ]),
      // TODO: Add a reload button
    );
  }
}
