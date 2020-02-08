import 'package:Solon/auth/button.dart';
import 'package:flutter/material.dart';

typedef FutureFunction<T> = Future<T> Function();

class PreventDoubleTap extends StatefulWidget {
  final List<Map> body;

  PreventDoubleTap({
    Key key,
    this.body,
  }) : super(key: key);

  @override
  PreventDoubleTapState createState() {
    return new PreventDoubleTapState();
  }
}

class PreventDoubleTapState extends State<PreventDoubleTap> {
  //boolean value to determine whether button is tapped
  bool _isButtonTapped = false;

  _onTapped(FutureFunction<void> function) {
    setState(() {
      _isButtonTapped = !_isButtonTapped;
    });
    function();
  }

  List<Button> getBody() {
    List<Button> body = new List<Button>();
    widget.body.forEach((map) {
      body.add(
        Button(
          color: map['color'],
          function: _isButtonTapped
              ? null
              : () {
                  _onTapped(map['function']);
                },
          label: map['label'],
          margin: map['margin'],
          width: map['width'],
          height: map['height'],
        ),
      );
    });
    return body;
  }

  @override
  Widget build(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: getBody(),
    );
  }
}
