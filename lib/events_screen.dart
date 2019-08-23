import 'package:flutter/material.dart';

import './event.dart';

class EventsScreen extends StatelessWidget {
  List<Widget> eventsList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: eventsList,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}