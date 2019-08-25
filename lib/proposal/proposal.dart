import 'package:flutter/material.dart';

import './proposal_screen.dart';

class Proposal extends StatefulWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  int numYea;
  int numNay;

  Proposal(this.proposalTitle, this.proposalSubtitle, this.dateTime,
      this.timeOfDay, this.numYea, this.numNay);

  @override
  _ProposalState createState() => _ProposalState(
      proposalTitle, proposalSubtitle, dateTime, timeOfDay, numYea, numNay);
}

class _ProposalState extends State<Proposal> {
  final String proposalTitle;
  final String proposalSubtitle;
  final DateTime dateTime;
  final TimeOfDay timeOfDay;
  int numYea;
  int numNay;
  var voteChoiceVisibility = true;

  _ProposalState(this.proposalTitle, this.proposalSubtitle, this.dateTime,
      this.timeOfDay, this.numYea, this.numNay);

  @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     child: ListTile(
  //       title: Text(proposalTitle),
  //       subtitle: Text(proposalSubtitle),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalScreen(
                widget.proposalTitle,
                widget.proposalSubtitle,
                widget.dateTime,
                widget.timeOfDay,
                widget.numYea,
                widget.numNay),
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
              Text(DateTime.now().difference(dateTime).inDays < 0
                  ? 'Cooldown Exceeded'
                  : '${DateTime.now().difference(dateTime).inDays}'),
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
