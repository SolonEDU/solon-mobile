import 'package:flutter/material.dart';

class PostPage extends StatefulWidget {
  final String title;
  final String description;
  final String time;
  PostPage(this.title, this.description, this.time);

  _PostPageState createState() => _PostPageState(
        title,
        description,
        time,
   );
}

class _PostPageState extends State<PostPage> {
    final String title;
    final String description;
    final String time;
    List<Widget> _comments = [];
  
  _PostPageState(
    this.title,
    this.description,
    this.time,
  );

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    print(_comments);

    return Scaffold(
      appBar: AppBar(
      title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Text(description),
          Text(time),
          ListView.builder(
           itemCount: _comments.length,
           itemBuilder: (BuildContext context, int index) {
            return _comments[index];
           },
          ),
        ],
      ),
      bottomSheet: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState.validate()) {
                  // Process data.
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
