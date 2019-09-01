import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './card.dart';
import './create.dart';
import '../../loader.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  final db = Firestore.instance;
  var user;
  var snapshots;
  final translator = GoogleTranslator();

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  void _getUser() async {
    user = await FirebaseAuth.instance.currentUser();
  }

  void _addProposal(
    String proposalTitle,
    String proposalSubtitle,
    double daysLeft,
    DateTime endDate,
  ) async {
    Map<String, String> translatedProposalTitlesMap = {
      'English': await translator.translate(proposalTitle, to: 'en'),
      'Chinese (Simplified)':
          await translator.translate(proposalTitle, to: 'zh-cn'),
      'Chinese (Traditional)':
          await translator.translate(proposalTitle, to: 'zh-tw'),
      'Bengali': await translator.translate(proposalTitle, to: 'bn'),
      'Korean': await translator.translate(proposalTitle, to: 'ko'),
      'Russian': await translator.translate(proposalTitle, to: 'ru'),
      'Japanese': await translator.translate(proposalTitle, to: 'ja'),
      'Ukrainian': await translator.translate(proposalTitle, to: 'uk'),
    };
    Map<String, String> translatedProposalDescriptionsMap = {
      'English': await translator.translate(proposalSubtitle, to: 'en'),
      'Chinese (Simplified)':
          await translator.translate(proposalSubtitle, to: 'zh-cn'),
      'Chinese (Traditional)':
          await translator.translate(proposalSubtitle, to: 'zh-tw'),
      'Bengali': await translator.translate(proposalSubtitle, to: 'bn'),
      'Korean': await translator.translate(proposalSubtitle, to: 'ko'),
      'Russian': await translator.translate(proposalSubtitle, to: 'ru'),
      'Japanese': await translator.translate(proposalSubtitle, to: 'ja'),
      'Ukrainian': await translator.translate(proposalSubtitle, to: 'uk'),
    };
    db.collection('proposals').add(
      {
        'proposalTitle': translatedProposalTitlesMap,
        'proposalSubtitle': translatedProposalDescriptionsMap,
        'daysLeft': daysLeft,
        'endDate': endDate.toString(),
        'creator': user.uid
      },
    );
  }

  Future<List> translateProposalTitleToNativeLanguage(
      DocumentSnapshot doc) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData =
        await db.collection('users').document(user.uid).get();
    String nativeLanguage = userData.data['nativeLanguage'];
    DocumentSnapshot creator = await db.collection('users').document(doc.data['creator']).get();
    List translatedProposal = List();
    translatedProposal.add(creator.data['name']);
    translatedProposal.add(doc.data['proposalTitle'][nativeLanguage]);
    translatedProposal.add(doc.data['proposalSubtitle'][nativeLanguage]);
    return translatedProposal;
  }

  Widget buildProposal(doc) {
    return FutureBuilder(
      future: translateProposalTitleToNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<List> translatedProposal) {
        return Proposal(
          key: UniqueKey(),
          creator: translatedProposal.hasData ? translatedProposal.data[0] : '',
          proposalTitle:
              translatedProposal.hasData ? translatedProposal.data[1] : '',
          proposalSubtitle:
              translatedProposal.hasData ? translatedProposal.data[2] : '',
          daysLeft: doc.data['daysLeft'],
          endDate: DateTime.parse(doc.data['endDate']),
          numYea: 0,
          numNay: 0,
          doc: doc,
        );
      },
    );
  }

  void getSnapshots() {
    setState(() {
      snapshots = db
          .collection('proposals')
          .orderBy('daysLeft', descending: false)
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
                      builder: (context) => AddProposalScreen(_addProposal),
                    ),
                  )
                },
              ),
            );
        }
      },
    );
  }
}
