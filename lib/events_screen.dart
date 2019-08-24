import 'package:flutter/material.dart';

import './event.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Widget> _eventsList = [];
  String _selectedItem = '';

  void _addEvent() {
    // setState(() {
    //  _eventsList.add(Event());
    // });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Cooling'),
                onTap: () => _selectItem('Cooling'),
              )
            ],
          );
        });
  }

  void _selectItem(String name) {
    // Navigator.pop(context);
    setState(() {
      _selectedItem = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _eventsList.length,
        itemBuilder: (BuildContext context, int index) {
          return _eventsList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {}//_addEvent,
      ),
    );
  }
}
