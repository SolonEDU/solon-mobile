import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function function;
  final String label;
  final EdgeInsets margin;

  Button({
    this.function,
    this.label,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Align(
        child: SizedBox(
          height: 55,
          width: 155,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30),
            ),
            color: Colors.pink[200],
            onPressed: function,
            child: Text(
              label,
              textScaleFactor: 1.5,
              style: TextStyle(fontFamily: 'Raleway', fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
