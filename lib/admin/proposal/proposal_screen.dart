import 'package:flutter/material.dart';
import 'package:Solon/app_localizations.dart';

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
              Text(AppLocalizations.of(context).translate('votesFor')),
              Text('${AppLocalizations.of(context).translate('yea')}: $numYea'),
              Text('${AppLocalizations.of(context).translate('nay')}: $numNay'),
              Text('Deadline Date: ${dateTime.toString().substring(0, 10)}'),
              Text('${AppLocalizations.of(context).translate('deadlineTime')}: ${timeOfDay.toString().substring(10,15)}'),
            ],
          ),
        ),
      ),
    );
  }
}
