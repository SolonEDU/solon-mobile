import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProposalScreen extends StatelessWidget {
  final String creator;
  final String proposalTitle;
  final String proposalSubtitle;
  final double daysLeft;
  final DateTime endDate;
  final int numYea;
  final int numNay;

  ProposalScreen(
    this.creator,
    this.proposalTitle,
    this.proposalSubtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(proposalTitle),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text('Created by ' + creator),
              Text(proposalSubtitle),
              Icon(Icons.comment),
              Text('Votes for...'),
              Text('Yea: $numYea'),
              Text('Nay: $numNay'),
              Text('Voting on proposal ends on: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
              Text('Days left: ' + daysLeft.toInt().toString()),
              //Text('Deadline Time: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
              //Text('Deadline Date: ${dateTime.toString().substring(0, 10)}'),
              //Text('Deadline Time: ${timeOfDay.toString().substring(10,15)}'),
            ],
          ),
        ),
      ),
    );
  }
}
