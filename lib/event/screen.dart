import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert'; // for jsonDecode

import './card.dart';
import './create.dart';
import './../loader.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // final db = Firestore.instance; 
  final translator = GoogleTranslator();

  Future<String> translateText(text, code) async {
    return await translator.translate(text, to: code);

  }

  Future<List<Map>> translateAll(String title, String description,
      List<Map> maps, Map<String, String> languages) async {
    for (var language in languages.keys) {
      maps[0][language] = await translateText(title, languages[language]);
      maps[1][language] = await translateText(description, languages[language]);
    }
    return maps;
  }

  void _addEvent(
    String title,
    String description,
    DateTime time,
  ) async {
    Map<String, String> languages = {
      'English': 'en',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Bengali': 'bn',
      'Korean': 'ko',
      'Russian': 'ru',
      'Japanese': 'ja',
      'Ukrainian': 'uk'
    };
    Map<String, String> translatedTitles = {};
    Map<String, String> translatedDescriptions = {};
    List<Map> translated = [translatedTitles, translatedDescriptions];
    translated = await translateAll(title, description, translated, languages);
    // db.collection('events').add( //send a POST request to the API with title, desc, and date
    //   {
    //     'title': translated[0],
    //     'description': translated[1],
    //     'date': time.toString(),
    //   },
    // );
  }

  // Future<List> toNativeLanguage(DocumentSnapshot doc) async { //GET the native language of the user 
  //   FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   DocumentSnapshot userData =
  //       await db.collection('users').document(user.uid).get();
  //   String nativeLanguage = userData.data['nativeLanguage'];
  //   List translatedEvent = List();
  //   translatedEvent.add(doc.data['title'][nativeLanguage]);
  //   translatedEvent.add(doc.data['description'][nativeLanguage]);
  //   return translatedEvent;
  // }

  // Widget buildEventCard(doc) {
  //   return FutureBuilder(
  //     future: toNativeLanguage(doc),
  //     builder: (BuildContext context, AsyncSnapshot<List> translatedEvent) {
    //       return EventCard(
    //         key: UniqueKey(),
  //         title: translatedEvent.hasData ? translatedEvent.data[0] : '',
  //         description: translatedEvent.hasData ? translatedEvent.data[1] : '',
  //         time: DateTime.parse(doc.data['date']),
  //         doc: doc,
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
    // return StreamBuilder<QuerySnapshot>( 
    //   stream: db
    //       .collection('events')
    //       .orderBy('date', descending: false)
    //       .snapshots(),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasError) return Text('Error: ${snapshot.error}');
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting:
    //         return Scaffold(
    //           body: Center(
    //             child: Loader(),
    //           ),
    //         );
    //       default:
    //         return Scaffold(
    //           body: Center(
    //             child: ListView(
    //               padding: EdgeInsets.all(8),
    //               children: <Widget>[
    //                 Column(
    //                   children: snapshot.data.documents
    //                       .map((doc) => buildEventCard(doc))
    //                       .toList(),
    //                 )
    //               ],
    //             ),
    //           ),
    //           floatingActionButton: FloatingActionButton(
    //             heroTag: 'unq1',
    //             child: Icon(Icons.add),
    //             onPressed: () => {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => CreateEvent(_addEvent)),
    //               )
    //             },
    //           ),
    //         );
    //     }
    //   },
    // );
  }
}
