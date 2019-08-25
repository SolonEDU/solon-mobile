import 'package:flutter/material.dart';

import './proposal.dart';
import './addproposal_screen.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  List<Widget> _proposalsList = [];

  void _addProposal(String proposalTitle, String proposalSubtitle, DateTime dateTime, TimeOfDay timeOfDay) {
    setState(() {
      _proposalsList.add(Proposal(proposalTitle, proposalSubtitle, dateTime, timeOfDay, 0, 0));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _proposalsList.length,
        itemBuilder: (BuildContext context, int index) {
          return _proposalsList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProposalScreen(_addProposal)),
          )
        },
      ),
    );
  }
}
