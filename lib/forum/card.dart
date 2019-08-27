import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './page.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String description;
  final DateTime time;
  final DocumentSnapshot doc;
  PostCard(this.title, this.description, this.time, this.doc);

  @override
  _PostCardState createState() => _PostCardState(
        title,
        description,
        time,
        doc,
      );
}

class _PostCardState extends State<PostCard> {
  final String title;
  final String description;
  final DateTime time;
  DocumentSnapshot doc;
  final db = Firestore.instance;

  _PostCardState(
    this.title,
    this.description,
    this.time,
    this.doc,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              //leading: Icon(Icons.calendar_today),
              title: Text(title),
              subtitle: Text(description + "\n" + time.toString()),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(
                      title,
                      description,
                      time,
                      doc,
                    ),
                  ),
                );
              },
            ),
            // ButtonTheme.bar(
            //   child: ButtonBar(
            //     children: <Widget>[
            //       FlatButton(
            //         child: Icon(Icons.delete),
            //         onPressed: () async => {
            //           await db
            //               .collection('events')
            //               .document(doc.documentID)
            //               .delete()
            //         },
            //       ),
            //       Switch.adaptive(
            //         value: attending,
            //         onChanged: (value) {
            //           setState(
            //             () => attending = value,
            //           );
            //         },
            //         activeTrackColor: Colors.lightGreenAccent,
            //         activeColor: Colors.green,
            //       ),
            //       Text('Attending?')
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
