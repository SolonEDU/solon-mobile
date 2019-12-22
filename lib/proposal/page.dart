// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Solon/api/api_connect.dart';
import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
import 'package:Solon/app_localizations.dart';
import 'package:Solon/loader.dart';

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
  int voteVal;
  String voteOutput;
  String httpReq;
  bool voteVisibility;

  Future<void> vote(int pid, int uidUser, int voteVal) async {
    final responseMessage = await APIConnect.connectVotes('POST',
        pid: pid, uidUser: uidUser, voteVal: voteVal);
    // print(responseMessage['message']);
  }

  Future<Map<String, dynamic>> getVote(int pid, int uidUser) async {
    final responseMessage = await APIConnect.connectVotes(
      'GET',
      pid: pid,
      uidUser: uidUser,
    );
    return responseMessage;
  }

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
          child: FutureBuilder<Map<String, dynamic>>(
              future: getVote(widget.pid, widget.uidUser),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: Loader(),
                  );
                }
                if (snapshot.data['message'] == 'Error') {
                  voteOutput = "You have not voted yet!";
                  voteVal = null;
                  httpReq = 'POST';
                  voteVisibility = true;
                } else {
                  voteOutput = "${snapshot.data['message']}";
                  voteVal = snapshot.data['vote']['value'];
                  voteOutput = voteVal == 1
                      ? "You have voted Yea!"
                      : "You have voted Nay!";
                  pressAttention = voteVal == 1 ? false : true;
                  print(voteVal);
                  httpReq = 'PATCH';
                  voteVisibility = false;
                }
                print(snapshot.data['message']);
                return Column(
                  //MIGHT convert to ListView
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
                    Text(voteOutput),
                    // Text('${AppLocalizations.of(context).translate('yea')}: $numYea'),
                    // Text('${AppLocalizations.of(context).translate('nay')}: $numNay'),
                    // Text('Voting on proposal ends on: ' + new DateFormat.yMMMMd("en_US").add_jm().format(endDate)),
                    // Text('Days left: ' + daysLeft.toInt().toString()),
                    Visibility(
                      visible: voteVisibility,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                                AppLocalizations.of(context).translate('yea')),
                            color: voteVal == null
                                ? Colors.white
                                : pressAttention ? Colors.white : Colors.blue,
                            onPressed: () {
                              // widget.numYea++;
                              setState(() {
                                voteVisibility = false;
                                voteVal = 1;
                                pressAttention = pressAttention;
                                // voteVal = pressAttention == true ? null : 0;
                                // voteChoiceVisibility = false;
                              });
                              vote(widget.pid, widget.uidUser, 1);
                            },
                          ),
                          FlatButton(
                            child: Text(
                                AppLocalizations.of(context).translate('nay')),
                            color: voteVal == null
                                ? Colors.white
                                : !pressAttention ? Colors.white : Colors.blue,
                            onPressed: () {
                              // widget.numNay++;
                              voteVisibility = false;
                              setState(() {
                                voteVal = 0;
                                // voteVal = pressAttention == false ? null : 1;
                                pressAttention = true;
                                // voteChoiceVisibility = false;
                              });
                              vote(widget.pid, widget.uidUser, 0);
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
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
