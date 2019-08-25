import 'package:flutter/material.dart';

class ProposalScreen extends StatelessWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final int numYea;
  final int numNay;

  ProposalScreen(this.proposalTitle, this.proposalSubtitle, this.numYea, this.numNay);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(proposalTitle),
      ),
      body: Column(
        children: <Widget>[
          Text(proposalSubtitle),
          Icon(Icons.comment),
          Text('Votes for...'),
          Text('Yea: ${numYea}'),
          Text('Nay: ${numNay}'),
        ],
      ),
    );
  }
}