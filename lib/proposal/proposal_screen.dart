import 'package:flutter/material.dart';

class ProposalScreen extends StatelessWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  final int numYea;
  final int numNay;

  ProposalScreen(
    this.proposalTitle,
    this.proposalSubtitle,
    this.dateTime,
    this.timeOfDay,
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
              Text(proposalSubtitle),
              Icon(Icons.comment),
              Text('Votes for...'),
              Text('Yea: ${numYea}'),
              Text('Nay: ${numNay}'),
              Text('Deadline Date: ${dateTime}'),
              Text('Deadline Time: ${timeOfDay}'),
            ],
          ),
        ),
      ),
    );
  }
}
