// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProposalPage extends StatelessWidget {
  final String title;
  final String description;
  final double daysLeft;
  final DateTime endDate;
  final int numYea;
  final int numNay;
  // final Future<DocumentSnapshot> creator;

  ProposalPage(
    this.title,
    this.description,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
    // this.creator,
  );
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              // FutureBuilder(
              //   future: creator,
              //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //     return Text(snapshot.data['name']);
              //   },
              // ),
              Text(description),
              Icon(Icons.comment),
              Text('Votes for...'),
              Text('Yea: $numYea'),
              Text('Nay: $numNay'),
              Text('Voting on proposal ends on: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
              Text('Days left: ' + daysLeft.toInt().toString()),
            ],
          ),
        ),
      ),
    );
  }
}
