import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text('An error occurred!'),
          RaisedButton(
            onPressed: () {
              // setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
