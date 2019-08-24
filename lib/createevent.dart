// import 'package:flutter/material.dart';

// class CreateEventPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('SECOND PAGE'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Text('this is the second page'),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an Event'),
      ),
    );
  }
}
