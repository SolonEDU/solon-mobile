import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  final String title;
  final String description;

  Event(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text(title),
    //   subtitle: Text(description),
    // );
    return Center(
      child: Card(
        child: ListTile(
          leading: Icon(Icons.adb),
          title: Text(title),
          subtitle: Text(description),
          onTap: () {
            print("i am tapping this");
          },
        ),
      ),
    );
  }
}
