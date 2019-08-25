import 'package:flutter/material.dart';

class Proposal extends StatelessWidget {
  final String proposalTitle;
  final String proposalSubtitle;
  Proposal(this.proposalTitle, this.proposalSubtitle);

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
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile( //used to be const
              leading: Icon(Icons.account_balance),
              title: Text(proposalTitle),
              subtitle: Text(proposalSubtitle),
            ),
            ButtonTheme.bar( // make buttons use the appropriate styles for cards
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('YEA'),
                    onPressed: () { /* ... */ },
                  ),
                  FlatButton(
                    child: const Text('NAY'),
                    onPressed: () { /* ... */ },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
