import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  final String title;
  final String description;
  final String time;

  PostPage(
    this.title,
    this.description,
    this.time,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Text(description),
          Text(time),
        ],
      ),
    );
  }
}
