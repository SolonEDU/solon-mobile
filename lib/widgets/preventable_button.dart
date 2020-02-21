import 'package:Solon/widgets/button.dart';
import 'package:flutter/material.dart';

typedef DynamicStream<T> = Stream<T> Function();

class PreventableButton extends StatefulWidget {
  final List<Map> body;

  PreventableButton({
    Key key,
    this.body,
  }) : super(key: key);

  @override
  PreventableButtonState createState() {
    return new PreventableButtonState();
  }
}

class PreventableButtonState extends State<PreventableButton> {
  //boolean value to determine whether button is tapped
  bool _isButtonTapped = false;

  _onTapped(DynamicStream<bool> function) async {
    function().listen((boolean) {
      setState(() {
        _isButtonTapped = boolean;
      });
    });
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