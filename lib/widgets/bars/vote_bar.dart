import 'package:flutter/material.dart';
import 'package:Solon/util/app_localizations.dart';

class VoteBar extends StatelessWidget {
  final int numyes;
  final int numno;

  VoteBar({this.numyes, this.numno});

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
              stops: [0, numyes / (numyes + numno), numyes / (numyes + numno), 1.0],
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
                "$numyes ${AppLocalizations.of(context).translate("yes")}",
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(
              child: Text(
                "$numno ${AppLocalizations.of(context).translate("no")}",
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
