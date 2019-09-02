import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProposalPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final double daysLeft;
  final DateTime endDate;
  final int numYea;
  final int numNay;

  ProposalPage(
    this.title,
    this.subtitle,
    this.daysLeft,
    this.endDate,
    this.numYea,
    this.numNay,
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
              Text(subtitle),
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
