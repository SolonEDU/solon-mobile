import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        'dateTime': dateTime.toString(),
        'timeOfDay': timeOfDay.toString(),
      },
    );
  }

  Proposal buildProposal(doc) {
    return Proposal(
      doc.data['proposalTitle'],
      doc.data['proposalSubtitle'],
      DateTime.parse(doc.data['dateTime']),
      TimeOfDay(
          hour: int.parse(doc.data['timeOfDay'].substring(10, 12)),
          minute: int.parse(doc.data['timeOfDay'].substring(13, 15))),
      0,
      0,
      doc.documentID,
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
