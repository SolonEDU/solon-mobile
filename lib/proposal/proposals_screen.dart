import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import './proposal.dart';
import './addproposal_screen.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  //List<Widget> _proposalsList = [];
  final db = Firestore.instance;

  void _addProposal(
    String proposalTitle,
    String proposalSubtitle,
    DateTime dateTime,
    TimeOfDay timeOfDay,
  ) async {
    // Firestore.instance.collection('proposals').add({
    //   'title': proposalTitle,
    //   'subtitle': proposalSubtitle,
    //   'dateTime': dateTime.toString(),
    //   'timeOfDay': timeOfDay.toString(),
    // });
    // setState(() {
    //   _proposalsList.add(
    //     Proposal(
    //       proposalTitle,
    //       proposalSubtitle,
    //       dateTime,
    //       timeOfDay,
    //       DateTime(
    //         dateTime.year,
    //         dateTime.month,
    //         dateTime.day,
    //         timeOfDay.hour,
    //         timeOfDay.minute,
    //       ),
    //       0,
    //       0,
    //     ),
    //   );
    // });
    DocumentReference ref = await db.collection('proposals').add(
      {
        'proposalTitle': proposalTitle,
        'proposalSubtitle': proposalSubtitle,
        'dateTime': dateTime.toString(),
        'timeOfDay': timeOfDay.toString(),
      },
    );
  }
//  List<Widget> makeListWidget(AsyncSnapshot snapshot) {
//    return snapshot.data.documents.map<Widget>((document) {
//      return Text("DATA");
//    }).toList();
//  }

  Proposal buildProposal(doc) {
    return Proposal(
      doc.data['proposalTitle'],
      doc.data['proposalSubtitle'],
      DateTime.parse(doc.data['dateTime']),
      null,
      0,
      0,
      doc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('proposals').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents
                      .map((doc) => buildProposal(doc))
                      .toList(),
                );
              }
              return Container();
            },
          ),
        ],
      ),
//      body:
//      Container(
//        child: StreamBuilder(
//          stream: Firestore.instance.collection("proposals").snapshots(),
//          builder: (context, snapshot) {
//            return ListView(
//              children: makeListWidget(snapshot),
//            );
//          },
//        ),
//      ),
//      ListView.builder(
//        itemCount: _proposalsList.length,
//        itemBuilder: (BuildContext context, int index) {
//          return _proposalsList[index];
//        },
//      ),
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
}
