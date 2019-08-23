import 'package:flutter/material.dart';

import './proposal.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  List<Widget> _proposalsList = [];

  void _addProposal() {
    setState(() {
      _proposalsList.add(Proposal());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: _proposalsList.length,
          itemBuilder: (BuildContext context, int index) {
            return _proposalsList[index];
          },
        ),
        FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: _addProposal,
        )
      ],
    );
  }
}
