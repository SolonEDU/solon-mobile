import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
import 'package:Solon/app_localizations.dart';
// import 'dart:convert'; // for jsonDecode

import './page.dart';

class ProposalCard extends StatefulWidget {
  final String title;
  final String descripton;
  // final double daysLeft;
  // final DateTime endDate;
  // final DocumentSnapshot doc;
  // int numYea;
  // int numNay;
  // final String creator;

  ProposalCard({
    Key key,
    this.title,
    this.descripton,
    // this.daysLeft,
    // this.endDate,
    // this.numYea,
    // this.numNay,
    // this.doc,
    // this.creator,
  }) : super(key: key);

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> {
  var voteChoiceVisibility = true;
  var collection;
  // final db = Firestore.instance;
  // String creatorName;

  void getCollection() {
    setState(() {
      // collection = db.collection('proposals');
    });
  }

  // Future<DocumentSnapshot> getCreator() async {
  //   return await db.collection('users').document(widget.creator).get();
  // }

  @override
  Widget build(BuildContext context) {
    getCollection();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalPage(
              widget.title,
              widget.descripton,
              // widget.daysLeft,
              // widget.endDate,
              // widget.numYea,
              // widget.numNay,
              // getCreator(),
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
                leading: Icon(Icons.account_balance),
                title: Text(widget.title),
                subtitle: Text(widget.descripton),
              ),
              // Text('Voting on proposal ends on: ' +
              //     new DateFormat.yMMMMd("en_US")
              //         .add_jm()
              //         .format(widget.endDate)),
              // Text('Days left: ' + widget.daysLeft.toInt().toString()),
              Visibility(
                visible: voteChoiceVisibility ? true : false,
                replacement: Text('You voted already!'),
                // make buttons use the appropriate styles for cards
                child: ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child:
                          Text(AppLocalizations.of(context).translate('yea')),
                      onPressed: () {
                        // widget.numYea++;
                        setState(() {
                          voteChoiceVisibility = false;
                        });
                      },
                    ),
                    FlatButton(
                      child:
                          Text(AppLocalizations.of(context).translate('nay')),
                      onPressed: () {
                        // widget.numNay++;
                        setState(() {
                          voteChoiceVisibility = false;
                        });
                      },
                    ),
                    FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: () {
                        // collection.document(widget.doc.documentID).delete();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
