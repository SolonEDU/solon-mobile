import "package:flutter/material.dart";

class Result extends StatelessWidget {
  final int resultScore;
  final Function restartHandler;

  Result(this.resultScore, this.restartHandler);

  String get resultPhrase {
    var resultText = 'you did it';
    if (resultScore <= 8) {
      resultText = 'you are cool';
    } else if (resultScore <= 12) {
      resultText = 'you are awesome';
    } else if (resultScore <= 16)  {
      resultText = 'you are the best';
    } else {
      resultText = 'wow';
    }
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            resultPhrase,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)
          ),
          FlatButton(child: Text("Restart Quiz"), onPressed: restartHandler,)
        ],
      ),
    );
  }
}
