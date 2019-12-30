// import 'package:Solon/api/api_connect.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:Solon/app_localizations.dart';
// import 'dart:convert'; // for jsonDecode

// import 'package:Solon/api/api_connect.dart';
import './page.dart';

class ProposalCard extends StatefulWidget {
  final int pid;
  final String title;
  final String description;
  final String endTime;
  final int uid;
  final int totalVotes;

  ProposalCard(
      {Key key,
      this.pid,
      this.title,
      this.description,
      this.endTime,
      this.uid,
      this.totalVotes})
      : super(key: key);

  factory ProposalCard.fromJson(Map<String, dynamic> json) {
    DateTime endTime = DateTime.parse(json['endtime']);
    String endTimeParsed = formatDate(
        endTime, [mm, '/', dd, '/', yyyy, ' ', hh, ':', nn, ':', ss, ' ', am]);
    return ProposalCard(
      pid: json['pid'],
      title: json['title'],
      description: json['description'],
      endTime: endTimeParsed,
      uid: json['uid'],
      totalVotes: json['numyes'] + json['numno'],
    );
  }

  @override
  _ProposalCardState createState() => _ProposalCardState();
}

class _ProposalCardState extends State<ProposalCard> {
  var voteChoiceVisibility = true;
  var collection;
  // final db = Firestore.instance;
  // String creatorName;

  // Future<DocumentSnapshot> getCreator() async {
  //   return await db.collection('users').document(widget.creator).get();
  // }

  // Future<void> getVote(int pid, int uidUser) async {
  //   final responseMessage = await APIConnect.connectVotes(
  //     'GET',
  //     pid: pid,
  //     uidUser: uidUser,
  //   );
  //   print(responseMessage['message']);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProposalPage(
              pid: widget.pid,
              title: widget.title,
              description: widget.description,
              uidUser: widget.uid,
              endTime: widget.endTime,
            ),
          ),
        );
      },
      child: Center(
        child: Card(
          // margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Text(
                  widget.totalVotes.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                title: Text(widget.title),
                subtitle: Column(
                  children: <Widget>[
                    // Text(widget.description),
                    Text('Voting ends on ' + widget.endTime),
                  ],
                ),
              ),

              // Text('Voting on proposal ends on: ' +
              //     new DateFormat.yMMMMd("en_US")
              //         .add_jm()
              //         .format(widget.endDate)),
              // Text('Days left: ' + widget.daysLeft.toInt().toString()),
              // Visibility(
              //   visible: voteChoiceVisibility ? true : false,
              //   replacement: Text('You voted already!'),
              //   // make buttons use the appropriate styles for cards
              //   child: ButtonBar(
              //     alignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       FlatButton(
              //         child:
              //             Text(AppLocalizations.of(context).translate('yea')),
              //         color: pressAttention ? Colors.grey : Colors.blue,
              //         onPressed: () {
              //           // widget.numYea++;
              //           setState(() {
              //             voteChoiceVisibility = false;
              //           });
              //         },
              //       ),
              //       FlatButton(
              //         child:
              //             Text(AppLocalizations.of(context).translate('nay')),
              //         onPressed: () {
              //           // widget.numNay++;
              //           setState(() {
              //             voteChoiceVisibility = false;
              //           });
              //         },
              //       ),
              //       // FlatButton(
              //       //   child: Icon(Icons.delete),
              //       //   onPressed: () {
              //       //     APIConnect.deleteProposal(widget.pid);
              //       //     // collection.document(widget.doc.documentID).delete();
              //       //   },
              //       // ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
