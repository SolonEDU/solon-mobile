// import 'dart:convert';

import 'dart:collection';

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
  final Map<String, String> languageCodes = {
    'English': 'en',
    'Chinese (Simplified)': 'zh-cn',
    'Chinese (Traditional)': 'zh-tw',
    'Bengali': 'bn',
    'Korean': 'ko',
    'Russian': 'ru',
    'Japanese': 'ja',
  };
  // String _languageCode;

  void _addProposal(
    String proposalTitle,
    String proposalSubtitle,
    double daysLeft,
    DateTime endDate,
  ) async {
    Map<String, String> translatedProposalTitlesMap = {
      'English': await translator.translate(proposalTitle, to: 'en'),
      'Chinese (Simplified)': await translator.translate(proposalTitle, to: 'zh-cn'),
      'Chinese (Traditional)': await translator.translate(proposalTitle, to: 'zh-tw'),
      'Bengali': await translator.translate(proposalTitle, to: 'bn'),
      'Korean': await translator.translate(proposalTitle, to: 'ko'),
      'Russian': await translator.translate(proposalTitle, to: 'ru'),
      'Japanese': await translator.translate(proposalTitle, to: 'ja'),
      'Ukrainian': await translator.translate(proposalTitle, to: 'uk'),
    };
    Map<String, String> translatedProposalDescriptionsMap = {
      'English': await translator.translate(proposalSubtitle, to: 'en'),
      'Chinese (Simplified)': await translator.translate(proposalSubtitle, to: 'zh-cn'),
      'Chinese (Traditional)': await translator.translate(proposalSubtitle, to: 'zh-tw'),
      'Bengali': await translator.translate(proposalSubtitle, to: 'bn'),
      'Korean': await translator.translate(proposalSubtitle, to: 'ko'),
      'Russian': await translator.translate(proposalSubtitle, to: 'ru'),
      'Japanese': await translator.translate(proposalSubtitle, to: 'ja'),
      'Ukrainian': await translator.translate(proposalSubtitle, to: 'uk'),
    };

    // for(int i = 0; i < languageCodes.keys.length; i++) {
    //   String translatedProposalTitleText = await translator.translate(proposalTitle, to: languageCodes);
    //   String translatedProposalDescriptionText = await translator.translate(proposalSubtitle, to: languageCodes[i]);
    //   translatedProposalTitlesMap[key] = translatedProposalTitleText;
    // }

    // languageCodes.forEach(
    //   (key, value) async {
    //     String translatedProposalTitleText = await translator.translate(proposalTitle, to: value);
    //     String translatedProposalDescriptionText = await translator.translate(proposalSubtitle, to: value);
    //     translatedProposalTitlesMap[key] = translatedProposalTitleText;
    //     translatedProposalDescriptionsMap[key] = translatedProposalDescriptionText;
    //     print('${translatedProposalTitleText} ${value}');
    //   },
    // );
    //String translatedText = await translator.translate(proposalTitle, to: 'zh-cn');
    print('Length: ${translatedProposalTitlesMap.length}');
    db.collection('proposals').add(
      {
        'proposalTitle': translatedProposalTitlesMap,
        'proposalSubtitle': translatedProposalDescriptionsMap,
        'daysLeft': daysLeft,
        'endDate': endDate.toString(),
      },
    );
  }

  Future<List> translateProposalTitleToNativeLanguage(
      DocumentSnapshot doc) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot userData =
        await db.collection('users').document(user.uid).get();
    String nativeLanguage = userData.data['nativeLanguage'];
    // print('hey1');
    // Future proposalTitle = translator.translate(doc.data['proposalTitle'],
    //     to: languageCodes[nativeLanguage]);
    // print('hey2');
    List translatedProposal = List();
    translatedProposal.add(doc.data['proposalTitle'][nativeLanguage]);
    translatedProposal.add(doc.data['proposalSubtitle'][nativeLanguage]);
    return translatedProposal;
  }

  Widget buildProposal(doc) {
    return FutureBuilder(
      future: translateProposalTitleToNativeLanguage(doc),
      builder: (BuildContext context, AsyncSnapshot<List> translatedProposal) {
        // print(proposalTitle.data);
        return Proposal(
          translatedProposal.hasData ? translatedProposal.data[0] : '',
          translatedProposal.hasData ? translatedProposal.data[1] : '',
          doc.data['daysLeft'],
          DateTime.parse(doc.data['endDate']),
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
