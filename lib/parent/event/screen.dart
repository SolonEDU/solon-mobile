import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './card.dart';
import './create.dart';
import '../../loader.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final db = Firestore.instance;
  var snapshots;
  final translator = GoogleTranslator();

  void translateText(text, map, language, abbreviation) async {
    map[language] = await translator.translate(text, to: abbreviation);
  }

  void _addEvent(
    String title,
    String description,
    date,
    time,
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
    languages.forEach((k,v) {
      translateText(title, translatedTitles, k, v);
      translateText(description, translatedDescriptions, k, v);
    });
    // Map<String, String> translatedEventTitlesMap = {
    //   'English': await translator.translate(title, to: 'en'),
    //   'Chinese (Simplified)': await translator.translate(title, to: 'zh-cn'),
    //   'Chinese (Traditional)': await translator.translate(title, to: 'zh-tw'),
    //   'Bengali': await translator.translate(title, to: 'bn'),
    //   'Korean': await translator.translate(title, to: 'ko'),
    //   'Russian': await translator.translate(title, to: 'ru'),
    //   'Japanese': await translator.translate(title, to: 'ja'),
    //   'Ukrainian': await translator.translate(title, to: 'uk'),
    // };
    // Map<String, String> translatedEventDescriptionsMap = {
    //   'English': await translator.translate(description, to: 'en'),
    //   'Chinese (Simplified)':
    //       await translator.translate(description, to: 'zh-cn'),
    //   'Chinese (Traditional)':
    //       await translator.translate(description, to: 'zh-tw'),
    //   'Bengali': await translator.translate(description, to: 'bn'),
    //   'Korean': await translator.translate(description, to: 'ko'),
    //   'Russian': await translator.translate(description, to: 'ru'),
    //   'Japanese': await translator.translate(description, to: 'ja'),
    //   'Ukrainian': await translator.translate(description, to: 'uk'),
    // };
    db.collection('events').add(
      {
        'eventTitle': translatedTitles,
        'eventDescription': translatedDescriptions,
        'eventDate': date.toString(),
        'eventTime': time.toString(),
      },
    );
  }

  Future<List> translateEventToNativeLanguage(DocumentSnapshot doc) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData =
        await db.collection('users').document(user.uid).get();
    String nativeLanguage = userData.data['nativeLanguage'];
    List translatedEvent = List();
    translatedEvent.add(doc.data['eventTitle'][nativeLanguage]);
    translatedEvent.add(doc.data['eventDescription'][nativeLanguage]);
    return translatedEvent;
  }

  Widget buildEventCard(doc) {
    return FutureBuilder(
      future: translateEventToNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<List> translatedEvent) {
        return EventCard(
          key: UniqueKey(),
          title: translatedEvent.hasData ? translatedEvent.data[0] : '',
          description: translatedEvent.hasData ? translatedEvent.data[1] : '',
          date: DateTime.parse(doc.data['eventDate']),
          time: TimeOfDay(
              hour: int.parse(doc.data['eventTime'].substring(10, 12)),
              minute: int.parse(doc.data['eventTime'].substring(13, 15))),
          doc: doc,
        );
      },
    );
  }

  void getSnapshots() {
    setState(() {
      snapshots = db
          .collection('events')
          .orderBy('eventDate', descending: false)
          .snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    getSnapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Scaffold(
              body: Center(
                child: Loader(),
              ),
            );
          default:
            return Scaffold(
              body: Center(
                child: ListView(
                  padding: EdgeInsets.all(8),
                  children: <Widget>[
                    Column(
                      children: snapshot.data.documents
                          .map((doc) => buildEventCard(doc))
                          .toList(),
                    )
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: 'unq1',
                child: Icon(Icons.add),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateEvent(_addEvent)),
                  )
                },
              ),
            );
        }
      },
    );
  }
}
