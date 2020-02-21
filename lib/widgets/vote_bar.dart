import 'package:Solon/app_localizations.dart';
import 'package:flutter/material.dart';

class VoteBar extends StatelessWidget {
  final int yes;
  final int no;

  VoteBar(this.yes, this.no);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(top: 10),
          width: double.infinity,
          child: Text(''),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.green,
                Colors.red,
                Colors.red,
              ],
              stops: [0, yes / (yes + no), yes / (yes + no), 1.0],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "$yes ${AppLocalizations.of(context).translate("yes")}",
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                "$no ${AppLocalizations.of(context).translate("no")}",
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
