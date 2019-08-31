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
  // List<Widget> _eventsList = [];
  final db = Firestore.instance;
  final translator = GoogleTranslator();

  void _addEvent(
    title,
    description,
    date,
    time,
  ) async {
    Map<String, String> translatedEventTitlesMap = {
      'English': await translator.translate(title, to: 'en'),
      'Chinese (Simplified)': await translator.translate(title, to: 'zh-cn'),
      'Chinese (Traditional)': await translator.translate(title, to: 'zh-tw'),
      'Bengali': await translator.translate(title, to: 'bn'),
      'Korean': await translator.translate(title, to: 'ko'),
      'Russian': await translator.translate(title, to: 'ru'),
      'Japanese': await translator.translate(title, to: 'ja'),
      'Ukrainian': await translator.translate(title, to: 'uk'),
    };

    Map<String, String> translatedEventDescriptionsMap = {
      'English': await translator.translate(description, to: 'en'),
      'Chinese (Simplified)':
          await translator.translate(description, to: 'zh-cn'),
      'Chinese (Traditional)':
          await translator.translate(description, to: 'zh-tw'),
      'Bengali': await translator.translate(description, to: 'bn'),
      'Korean': await translator.translate(description, to: 'ko'),
      'Russian': await translator.translate(description, to: 'ru'),
      'Japanese': await translator.translate(description, to: 'ja'),
      'Ukrainian': await translator.translate(description, to: 'uk'),
    };

    db.collection('events').add(
      {
        'eventTitle': translatedEventTitlesMap,
        'eventDescription': translatedEventDescriptionsMap,
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
    // print('hey1');
    // Future proposalTitle = translator.translate(doc.data['proposalTitle'],
    //     to: languageCodes[nativeLanguage]);
    // print('hey2');
    List translatedEvent = List();
    translatedEvent.add(doc.data['eventTitle'][nativeLanguage]);
    translatedEvent.add(doc.data['eventDescription'][nativeLanguage]);
    print(translatedEvent[0]);
    return translatedEvent;
  }

  Widget buildEventCard(doc) {
    return FutureBuilder(
      future: translateEventToNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<List> translatedEvent) {
        //print('${translatedEvent.data[0]} ${translatedEvent.data[1]}');
        return EventCard(
          translatedEvent.hasData ? translatedEvent.data[0] : '',
          translatedEvent.hasData ? translatedEvent.data[1] : '',
          DateTime.parse(doc.data['eventDate']),
          TimeOfDay(
              hour: int.parse(doc.data['eventTime'].substring(10, 12)),
              minute: int.parse(doc.data['eventTime'].substring(13, 15))),
          doc,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('events')
          .orderBy('eventDate', descending: false)
          .snapshots(),
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
                heroTag: 'unq2',
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
