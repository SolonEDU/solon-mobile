import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './page.dart';

class Proposal extends StatefulWidget {
  final String title;
  final String subtitle;
  final double daysLeft;
  final DateTime endDate;
  final DocumentSnapshot doc;
  int numYea;
  int numNay;

  Proposal({
    Key key,
    this.title,
    this.subtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    this.doc,
  }) : super(key: key);

  @override
  _ProposalState createState() => _ProposalState();
}

class _ProposalState extends State<Proposal> {
  var voteChoiceVisibility = true;
  var collection;
  final db = Firestore.instance;

  void getCollection() {
    setState(() {
      collection = db.collection('proposals');
    });
  }

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
              widget.subtitle,
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
                title: Text(widget.title),
                subtitle: Text(widget.subtitle),
              ),
              Text('Voting on proposal ends on: ' +
                  new DateFormat.yMMMMd("en_US")
                      .add_jm()
                      .format(widget.endDate)),
              Text('Days left: ' + widget.daysLeft.toInt().toString()),
              Text(widget.doc.documentID),
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
                          collection.document(widget.doc.documentID).delete();
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
