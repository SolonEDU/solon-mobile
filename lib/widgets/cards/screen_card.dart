import 'package:flutter/material.dart';

class ScreenCard extends StatelessWidget {
  final Function function;
  final ListTile tile;

  ScreenCard({this.function, this.tile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 10.0,
      ),
      constraints: BoxConstraints(
        minWidth: 300,
        maxWidth: MediaQuery.of(context).size.width,
      ),
      width: MediaQuery.of(context).size.width,
      child: Align(
        child: SizedBox(
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            color: Colors.white,
            child: tile,
            onPressed: function,
            // elevation: 0.0,
          ),
        ),
      ),
      // decoration: new BoxDecoration(
      //   // color: new Color(0xFF333366),
      //   shape: BoxShape.rectangle,
      //   borderRadius: new BorderRadius.circular(30.0),
      //   boxShadow: <BoxShadow>[
      //     new BoxShadow(
      //       color: Colors.black12,
      //       blurRadius: 0,
      //       // spreadRadius: 1.0,
      //       // offset: new Offset(0.0, 10.0),
      //     ),
      //   ],
      // ),
    );
  }
}
