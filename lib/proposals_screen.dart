import 'package:flutter/material.dart';

import './proposal.dart';
import './add_proposal_modal_screen.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  List<Widget> _proposalsList = [];
  AddProposalModalScreen modal = new AddProposalModalScreen();

  void _addProposal() {
    setState(() {
      _proposalsList.add(Proposal());
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
        onPressed: () => modal.mainBottomSheet(context),
      ),
    );
  }
}
