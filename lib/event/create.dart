// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  final Function _addEvent;
  CreateEventPage(this._addEvent);

  @override
  _CreateEventPageState createState() => _CreateEventPageState(_addEvent);
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final Function addEvent;

  _CreateEventPageState(this.addEvent);
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Event'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title'
              ),
              controller: titleController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                } return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Descripton'
              ),
              controller: descriptionController,
              validator: (value) {
                if(value.isEmpty) {
                  return 'Please enter some text';
                } return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    addEvent(titleController.text, descriptionController.text);
                    Navigator.pop(context);
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
