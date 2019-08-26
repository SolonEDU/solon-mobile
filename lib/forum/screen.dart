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
      body: ListView(
        padding: EdgeInsets.all(8),
        children: _postList
          // StreamBuilder<QuerySnapshot>(
          //   stream: db.collection('events').snapshots(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Column(
          //         children: snapshot.data.documents
          //             .map((doc) => buildEventCard(doc))
          //             .toList(),
          //       );
          //     }
          //     return Container();
          //   },
          // ),
        ,
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