import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import './proposal_screen.dart';

class Proposal extends StatefulWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  int numYea;
  int numNay;
  DocumentSnapshot doc;

  Proposal(
    this.proposalTitle,
    this.proposalSubtitle,
    this.dateTime,
    this.timeOfDay,
    this.numYea,
    this.numNay,
    this.doc,
  );

  @override
  _ProposalState createState() => _ProposalState(
        proposalTitle,
        proposalSubtitle,
        dateTime,
        timeOfDay,
        numYea,
        numNay,
        doc,
      );
}

class _ProposalState extends State<Proposal> {
  final String proposalTitle;
  final String proposalSubtitle;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  int numYea;
  int numNay;
  DocumentSnapshot doc;
  var voteChoiceVisibility = true;
  final db = Firestore.instance;

  _ProposalState(
    this.proposalTitle,
    this.proposalSubtitle,
    this.dateTime,
    this.timeOfDay,
    this.numYea,
    this.numNay,
    this.doc,
  );

  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: ListTile(
  //       title: Text(proposalTitle),
  //       subtitle: Text(proposalSubtitle),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    DateTime cooldownTime;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalScreen(
              widget.proposalTitle,
              widget.proposalSubtitle,
              widget.dateTime,
              widget.timeOfDay,
              widget.numYea,
              widget.numNay,
            ),
          ),
        );
      },
      child: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                //used to be const
                leading: Icon(Icons.account_balance),
                title: Text(widget.proposalTitle),
                subtitle: Text(widget.proposalSubtitle),
              ),
              Text(
                  'Cooldown Date and Time: '),
              Visibility(
                visible: voteChoiceVisibility ? true : false,
                replacement: Text('You voted already!'),
                child: ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('YEA'),
                        onPressed: () {
                          widget.numYea++;
                          setState(() {
                            voteChoiceVisibility = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: const Text('NAY'),
                        onPressed: () {
                          widget.numNay++;
                          setState(() {
                            voteChoiceVisibility = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: Icon(Icons.delete),
                        onPressed: () async {
                          await db.collection('proposals').document(doc.documentID).delete();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
