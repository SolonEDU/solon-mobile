import 'package:flutter/material.dart';

import './card.dart';
import './create.dart';

class ForumScreen extends StatefulWidget {
  @override
  _ForumScreenState createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  List<Widget> _postList = [];
  //final db = Firestore.instance;

  void _addPost(title, description) {
    setState(
      () {
        _postList.add(
          PostCard(
            title,
            description,
            DateTime.now().toString(),
          ),
        );
      },
    );

    //DocumentReference ref = await db.collection('events').add(
    //  {
    //    'eventTitle': title,
    //    'eventDescription': description,
    //    'eventTime': time.toString(),
    //  },
    //);
  }

  // PostCard buildPostCard(doc) {
  //   return PostCard(
  //     doc.data['eventTitle'],
  //     doc.data['eventDescription'],
  //     doc,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _postList.length,
        itemBuilder: (BuildContext context, int index) {
          return _postList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePost(_addPost),
            ),
          );
        },
      ),
    );
  }
}
