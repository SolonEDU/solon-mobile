import 'package:flutter/material.dart';
import 'package:Solon/util/app_localizations.dart';

class VoteBar extends StatelessWidget {
  final int numYes;
  final int numNo;
  final bool noVotesCasted;

  VoteBar({
    this.numYes,
    this.numNo,
    this.noVotesCasted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width * 0.70,
          child: Text(''),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: noVotesCasted
                  ? [
                      Colors.grey,
                      Colors.grey,
                      Colors.grey,
                      Colors.grey,
                    ]
                  : [
                      Colors.green,
                      Colors.green,
                      Colors.red,
                      Colors.red,
                    ],
              stops: [
                0,
                numYes / (numYes + numNo),
                numYes / (numYes + numNo),
                1.0
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            top: 4,
            left: MediaQuery.of(context).size.width * 0.218,
            right: MediaQuery.of(context).size.width * 0.218,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "$numYes ${AppLocalizations.of(context).translate("yes")}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  "$numNo ${AppLocalizations.of(context).translate("no")}",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
