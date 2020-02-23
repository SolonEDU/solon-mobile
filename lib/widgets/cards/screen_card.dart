import 'package:flutter/material.dart';

class ScreenCard extends StatelessWidget {
  final Function function;
  final ListTile tile;

  ScreenCard({this.function, this.tile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: MediaQuery.of(context).size.width - 10,
      ),
      child: Align(
        child: SizedBox(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30),
            ),
            color: Colors.white,
            child: tile,
            onPressed: function,
          ),
        ),
      ),
    );
  }
}
