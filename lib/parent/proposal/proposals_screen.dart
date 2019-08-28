// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './proposal.dart';
import './addproposal_screen.dart';
import '../../loader.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  //List<Widget> _proposalsList = [];
  final db = Firestore.instance;
  var snapshots;
  final translator = GoogleTranslator();
  // String _languageCode;

  void _addProposal(
    String proposalTitle,
    String proposalSubtitle,
    DateTime dateTime,
    TimeOfDay timeOfDay,
  ) {
    db.collection('proposals').add(
      {
        'proposalTitle': proposalTitle,
        'proposalSubtitle': proposalSubtitle,
        'timeOfDay': timeOfDay.toString(),
        'dateTime': dateTime.toString(),
      },
    );
  }

  Future<String> translateProposalTitleToNativeLanguage(
      DocumentSnapshot doc) async {
    final Map<String, String> languageCodes = {
      'English': 'en',
      'Chinese (Simplified)': 'zh-cn',
      'Chinese (Traditional)': 'zh-tw',
      'Bengali': 'bn',
      'Korean': 'ko',
      'Russian': 'ru',
      'Japanese': 'ja',
    };
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData =
        await db.collection('users').document(user.uid).get();
    String nativeLanguage = userData.data['nativeLanguage'];
    // print('hey1');
    Future proposalTitle = translator.translate(doc.data['proposalTitle'],
        to: languageCodes[nativeLanguage]);
    // print('hey2');
    return proposalTitle;
  }

  Widget buildProposal(doc) {
    return FutureBuilder(
      future: translateProposalTitleToNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<String> proposalTitle) {
        // print(proposalTitle.data);
        return Proposal(
          proposalTitle.hasData ? proposalTitle.data : '',
          doc.data['proposalSubtitle'],
          DateTime.parse(doc.data['dateTime']),
          TimeOfDay(
              hour: int.parse(doc.data['timeOfDay'].substring(10, 12)),
              minute: int.parse(doc.data['timeOfDay'].substring(13, 15))),
          0,
          0,
          doc.documentID,
        );
      },
    );
  }

  void getSnapshots() {
    setState(() {
      snapshots = db
          .collection('proposals')
          .orderBy('dateTime', descending: false)
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
                          .map((doc) => buildProposal(doc))
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
                        builder: (context) => AddProposalScreen(_addProposal)),
                  )
                },
              ),
            );
        }
      },
    );
  }
}
