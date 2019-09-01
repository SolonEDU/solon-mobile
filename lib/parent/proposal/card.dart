import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './page.dart';

class Proposal extends StatefulWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final double daysLeft;
  final DateTime endDate;
  final String creator;
  int numYea;
  int numNay;
  final doc;

  Proposal({
    Key key,
    this.creator,
    this.proposalTitle,
    this.proposalSubtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    this.doc,
  }) : super(key: key);

  @override
  _ProposalState createState() => _ProposalState(
        creator,
        proposalTitle,
        proposalSubtitle,
        daysLeft,
        endDate,
        numYea,
        numNay,
        doc,
      );
}

class _ProposalState extends State<Proposal> {
  final String proposalTitle;
  final String proposalSubtitle;
  final double daysLeft;
  final DateTime endDate;
  final String creator;
  int numYea;
  int numNay;
  var doc;
  var voteChoiceVisibility = true;
  var collection;
  final db = Firestore.instance;

  _ProposalState(
    this.creator,
    this.proposalTitle,
    this.proposalSubtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    this.doc,
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
              widget.creator,
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
                        onPressed: () {
                          collection
                              .document(doc.documentID
                                  // doc
                                  )
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
