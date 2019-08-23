import 'package:flutter/material.dart';

import './proposal.dart';

class ProposalsScreen extends StatefulWidget {
  @override
  _ProposalsScreenState createState() => _ProposalsScreenState();
}

class _ProposalsScreenState extends State<ProposalsScreen> {
  List<Widget> proposalsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: proposalsList,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            proposalsList.add(Proposal());
            print('added ${proposalsList.length}');
          });
        },
      ),
    );
  }
}
