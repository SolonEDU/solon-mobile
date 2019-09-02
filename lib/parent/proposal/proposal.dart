import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
import 'package:Solon/app_localizations.dart';
=======
>>>>>>> master

import './proposal_screen.dart';

class Proposal extends StatefulWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final double daysLeft;
  final DateTime endDate;
  int numYea;
  int numNay;
  final doc;
  final creatorName;

  Proposal({
    Key key,
    this.proposalTitle,
    this.proposalSubtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    this.doc,
    this.creatorName,
  }) : super(key: key);

  @override
  _ProposalState createState() => _ProposalState(
        proposalTitle,
        proposalSubtitle,
        daysLeft,
        endDate,
        numYea,
        numNay,
        doc,
        creatorName
      );
}

class _ProposalState extends State<Proposal> {
  final String proposalTitle;
  final String proposalSubtitle;
  final double daysLeft;
  final DateTime endDate;
  int numYea;
  int numNay;
  var doc;
  var voteChoiceVisibility = true;
  var collection;
  final db = Firestore.instance;
  String creatorName;

  _ProposalState(
    this.proposalTitle,
    this.proposalSubtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    this.doc,
    this.creatorName,
  );

  void getCollection() {
    setState(() {
      collection = db.collection('proposals');
    });
  }

  @override
  Widget build(BuildContext context) {
    // DateTime cooldownTime;
    getCollection();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalScreen(
              widget.proposalTitle,
              widget.proposalSubtitle,
              widget.daysLeft,
              widget.endDate,
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
              Text('Voting on proposal ends on: ' +
                  new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
              Text('Days left: ' + daysLeft.toInt().toString()),
              Text(doc.documentID),
<<<<<<< HEAD
=======
              Text('Created by: ${creatorName}'),
>>>>>>> master
              Visibility(
                visible: voteChoiceVisibility ? true : false,
                replacement: Text('You voted already!'),
                child: ButtonTheme.bar(
                  // make buttons use the appropriate styles for cards
                  child: ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: Text(AppLocalizations.of(context).translate('yea')),
                        onPressed: () {
                          widget.numYea++;
                          setState(() {
                            voteChoiceVisibility = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: Text(AppLocalizations.of(context).translate('nay')),
                        onPressed: () {
                          widget.numNay++;
                          setState(() {
                            voteChoiceVisibility = false;
                          });
                        },
                      ),
                      FlatButton(
                        child: Icon(Icons.delete),
                        onPressed: () {
<<<<<<< HEAD
                          db
                              .collection('proposals')
                              .document(
                                doc.documentID
                                // doc
                                )
=======
                          collection
                              .document(doc.documentID
                                  // doc
                                  )
>>>>>>> master
                              .delete()
                              .then((v) {
                            print('deleted ${doc.documentID}');
                          });
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
