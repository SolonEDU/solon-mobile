// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:Solon/app_localizations.dart';

// class ProposalPage0 extends StatelessWidget {
//   final int pid;
//   final String title;
//   final String description;
//   // final double daysLeft;
//   // final DateTime endDate;
//   // final int numYea;
//   // final int numNay;
//   // final Future<DocumentSnapshot> creator;

//   ProposalPage0(
//     this.pid,
//     this.title,
//     this.description,
//     // this.daysLeft,
//     // this.endDate,
//     // this.numYea,
//     // this.numNay,
//     // this.creator,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: Container(
//         width: double.infinity,
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: <Widget>[
//               // FutureBuilder(
//               //   future: creator,
//               //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//               //     return Text(snapshot.data['name']);
//               //   },
//               // ),
//               Text(description),
//               Icon(Icons.comment),
//               Text(AppLocalizations.of(context).translate('votesFor')),
//               // Text('${AppLocalizations.of(context).translate('yea')}: $numYea'),
//               // Text('${AppLocalizations.of(context).translate('nay')}: $numNay'),
//               // Text('Voting on proposal ends on: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
//               // Text('Days left: ' + daysLeft.toInt().toString()),
//               ButtonBar(
//                 alignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   FlatButton(
//                     child: Text(AppLocalizations.of(context).translate('yea')),
//                     color: pressAttention ? Colors.grey : Colors.blue,
//                     onPressed: () {
//                       // widget.numYea++;
//                       setState(() {
//                         voteChoiceVisibility = false;
//                       });
//                     },
//                   ),
//                   FlatButton(
//                     child: Text(AppLocalizations.of(context).translate('nay')),
//                     onPressed: () {
//                       // widget.numNay++;
//                       setState(() {
//                         voteChoiceVisibility = false;
//                       });
//                     },
//                   ),
//                   // FlatButton(
//                   //   child: Icon(Icons.delete),
//                   //   onPressed: () {
//                   //     APIConnect.deleteProposal(widget.pid);
//                   //     // collection.document(widget.doc.documentID).delete();
//                   //   },
//                   // ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class ProposalPage extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final int uidUser;
  // final double daysLeft;
  // final DateTime endDate;
  // final int numYea;
  // final int numNay;
  // final Future<DocumentSnapshot> creator;

  ProposalPage({
    Key key,
    this.pid,
    this.title,
    this.description,
    this.uidUser,
    // this.daysLeft,
    // this.endDate,
    // this.numYea,
    // this.numNay,
    // this.creator,
  }) : super(key: key);
  @override
  _ProposalPageState createState() => _ProposalPageState();
}

class _ProposalPageState extends State<ProposalPage> {
  bool pressAttention = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column( //MIGHT convert to ListView
            children: <Widget>[
              // FutureBuilder(
              //   future: creator,
              //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              //     return Text(snapshot.data['name']);
              //   },
              // ),
              Text(widget.description),
              Icon(Icons.comment),
              Text(AppLocalizations.of(context).translate('votesFor')),
              // Text('${AppLocalizations.of(context).translate('yea')}: $numYea'),
              // Text('${AppLocalizations.of(context).translate('nay')}: $numNay'),
              // Text('Voting on proposal ends on: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
              // Text('Days left: ' + daysLeft.toInt().toString()),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text(AppLocalizations.of(context).translate('yea')),
                    color: pressAttention ? Colors.white : Colors.blue,
                    onPressed: () {
                      // widget.numYea++;
                      setState(() {
                        pressAttention = !pressAttention;
                        // voteChoiceVisibility = false;
                      });
                      APIConnect.connectVotes(widget.pid, widget.uidUser, 1);
                    },
                  ),
                  FlatButton(
                    child: Text(AppLocalizations.of(context).translate('nay')),
                    color: !pressAttention ? Colors.white : Colors.blue,
                    onPressed: () {
                      // widget.numNay++;
                      setState(() {
                        pressAttention = !pressAttention;
                        // voteChoiceVisibility = false;
                      });
                      APIConnect.connectVotes(widget.pid, widget.uidUser, 0);
                    },
                  ),
                  // FlatButton(
                  //   child: Icon(Icons.delete),
                  //   onPressed: () {
                  //     APIConnect.deleteProposal(widget.pid);
                  //     // collection.document(widget.doc.documentID).delete();
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
