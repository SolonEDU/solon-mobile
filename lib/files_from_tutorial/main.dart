import 'package:flutter/material.dart';

import "./quiz.dart";
import "./result.dart";

// void main() {
//   runApp(MyApp());
// }

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var _questionIndex = 0;
  var _totalScore = 0;

  void _restartQuiz() {
    setState(() {
      _questionIndex = 0;
      _totalScore = 0;
    });
  }

  void _answerQuestion(int score) {
    _totalScore += score; 
    setState(() {
      _questionIndex++;
    });
    print(_questionIndex);
    if (_questionIndex < _questions.length) {
      print("we have more questions");
    }
  }

  final _questions = const [
    {
      'questionText': "what is your favorite color?",
      'answers': [
        {'text': 'black', 'score': 10},
        {'text': 'red', 'score': 6},
        {'text': 'green', 'score': 3},
        {'text': 'white', 'score': 1}
      ]
    },
    {
      'questionText': "what is your favorite food?",
      'answers': [
        {'text': 'pizza', 'score': 10},
        {'text': 'hamburger', 'score': 6},
        {'text': 'durian', 'score': 3},
        {'text': 'rice', 'score': 1}
      ]
    },
    {
      'questionText': "what is your favorite animal?",
      'answers': [
        {'text': 'dog', 'score': 10},
        {'text': 'cat', 'score': 6},
        {'text': 'fish', 'score': 3},
        {'text': 'tiger', 'score': 1}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("My First App"),
        ),
        body: _questionIndex < _questions.length
            ? Quiz(
                answerQuestion: _answerQuestion,
                questionIndex: _questionIndex,
                questions: _questions,
              )
            : Result(_totalScore, _restartQuiz),
      ),
    );
  }
}
