import 'package:flutter/material.dart';

class CreateButton extends StatelessWidget {
  final Widget creator;

  CreateButton({this.creator});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'unq1',
      backgroundColor: Colors.pinkAccent[400],
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => creator),
        );
      },
    );
  }
}
